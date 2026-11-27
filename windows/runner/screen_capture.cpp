#include "screen_capture.h"

// These rely on types from windows.h and must come after it.
#include <unknwn.h>
#include <shobjidl.h>
#include <d3d11.h>
#include <dxgi.h>
#include <wincodec.h>
#include <windows.graphics.capture.interop.h>
#include <windows.graphics.directx.direct3d11.interop.h>
#include <wrl/client.h>
#include <winrt/Windows.Foundation.h>
#include <winrt/Windows.Graphics.Capture.h>
#include <winrt/Windows.Graphics.DirectX.Direct3D11.h>
#include <winrt/Windows.Graphics.DirectX.h>

#include <algorithm>
#include <chrono>
#include <memory>
#include <thread>
#include <utility>
#include <vector>

namespace ares::capture {

using Microsoft::WRL::ComPtr;
namespace wf = winrt::Windows::Foundation;
namespace wgc = winrt::Windows::Graphics::Capture;
namespace wgdx = winrt::Windows::Graphics::DirectX;
namespace wgd3d = winrt::Windows::Graphics::DirectX::Direct3D11;

struct Picked {
  wgc::GraphicsCaptureItem item{nullptr};
};

namespace {

std::string Utf8(const std::wstring& wide) {
  if (wide.empty()) return std::string();
  const int size = static_cast<int>(wide.size());
  const int length = ::WideCharToMultiByte(CP_UTF8, 0, wide.c_str(), size,
                                           nullptr, 0, nullptr, nullptr);
  if (length <= 0) return std::string();
  std::string text(static_cast<size_t>(length), '\0');
  ::WideCharToMultiByte(CP_UTF8, 0, wide.c_str(), size, text.data(), length,
                        nullptr, nullptr);
  return text;
}

// Writes opaque BGRA rows as a PNG with WIC.
HRESULT WritePng(const std::wstring& path, UINT width, UINT height,
                 UINT stride, const BYTE* pixels) {
  ComPtr<IWICImagingFactory> factory;
  HRESULT hr = ::CoCreateInstance(CLSID_WICImagingFactory, nullptr,
                                  CLSCTX_INPROC_SERVER, IID_PPV_ARGS(&factory));
  if (FAILED(hr)) return hr;
  ComPtr<IWICStream> stream;
  hr = factory->CreateStream(&stream);
  if (FAILED(hr)) return hr;
  hr = stream->InitializeFromFilename(path.c_str(), GENERIC_WRITE);
  if (FAILED(hr)) return hr;
  ComPtr<IWICBitmapEncoder> encoder;
  hr = factory->CreateEncoder(GUID_ContainerFormatPng, nullptr, &encoder);
  if (FAILED(hr)) return hr;
  hr = encoder->Initialize(stream.Get(), WICBitmapEncoderNoCache);
  if (FAILED(hr)) return hr;
  ComPtr<IWICBitmapFrameEncode> frame;
  hr = encoder->CreateNewFrame(&frame, nullptr);
  if (FAILED(hr)) return hr;
  hr = frame->Initialize(nullptr);
  if (FAILED(hr)) return hr;
  hr = frame->SetSize(width, height);
  if (FAILED(hr)) return hr;
  WICPixelFormatGUID format = GUID_WICPixelFormat32bppBGRA;
  hr = frame->SetPixelFormat(&format);
  if (FAILED(hr)) return hr;
  if (format != GUID_WICPixelFormat32bppBGRA) return E_FAIL;
  hr = frame->WritePixels(height, stride, stride * height,
                          const_cast<BYTE*>(pixels));
  if (FAILED(hr)) return hr;
  hr = frame->Commit();
  if (FAILED(hr)) return hr;
  return encoder->Commit();
}

// One frame of [item] as a PNG in [directory]; returns the UTF-8 path.
std::string CaptureToPng(const wgc::GraphicsCaptureItem& item,
                         const std::wstring& directory) {
  ComPtr<ID3D11Device> device;
  ComPtr<ID3D11DeviceContext> context;
  const UINT flags = D3D11_CREATE_DEVICE_BGRA_SUPPORT;
  HRESULT hr = ::D3D11CreateDevice(nullptr, D3D_DRIVER_TYPE_HARDWARE, nullptr,
                                   flags, nullptr, 0, D3D11_SDK_VERSION,
                                   &device, nullptr, &context);
  if (FAILED(hr)) {
    hr = ::D3D11CreateDevice(nullptr, D3D_DRIVER_TYPE_WARP, nullptr, flags,
                             nullptr, 0, D3D11_SDK_VERSION, &device, nullptr,
                             &context);
  }
  winrt::check_hresult(hr);
  ComPtr<IDXGIDevice> dxgi;
  winrt::check_hresult(device.As(&dxgi));
  winrt::com_ptr<::IInspectable> inspectable;
  winrt::check_hresult(
      ::CreateDirect3D11DeviceFromDXGIDevice(dxgi.Get(), inspectable.put()));
  const auto d3d = inspectable.as<wgd3d::IDirect3DDevice>();

  const auto pool = wgc::Direct3D11CaptureFramePool::CreateFreeThreaded(
      d3d, wgdx::DirectXPixelFormat::B8G8R8A8UIntNormalized, 1, item.Size());
  const auto session = pool.CreateCaptureSession(item);
  try {
    session.IsCursorCaptureEnabled(false);  // Windows 10 2004 and later.
  } catch (...) {
  }
  session.StartCapture();
  wgc::Direct3D11CaptureFrame frame{nullptr};
  const auto deadline =
      std::chrono::steady_clock::now() + std::chrono::seconds(3);
  while (!(frame = pool.TryGetNextFrame())) {
    if (std::chrono::steady_clock::now() > deadline) {
      session.Close();
      pool.Close();
      throw winrt::hresult_error(E_FAIL);
    }
    std::this_thread::sleep_for(std::chrono::milliseconds(15));
  }
  const auto access = frame.Surface().as<
      ::Windows::Graphics::DirectX::Direct3D11::IDirect3DDxgiInterfaceAccess>();
  ComPtr<ID3D11Texture2D> texture;
  winrt::check_hresult(access->GetInterface(IID_PPV_ARGS(&texture)));
  D3D11_TEXTURE2D_DESC desc{};
  texture->GetDesc(&desc);
  const auto content = frame.ContentSize();
  const UINT width = std::min<UINT>(
      desc.Width, static_cast<UINT>(std::max<int32_t>(1, content.Width)));
  const UINT height = std::min<UINT>(
      desc.Height, static_cast<UINT>(std::max<int32_t>(1, content.Height)));
  desc.Usage = D3D11_USAGE_STAGING;
  desc.BindFlags = 0;
  desc.CPUAccessFlags = D3D11_CPU_ACCESS_READ;
  desc.MiscFlags = 0;
  ComPtr<ID3D11Texture2D> staging;
  winrt::check_hresult(device->CreateTexture2D(&desc, nullptr, &staging));
  context->CopyResource(staging.Get(), texture.Get());
  frame.Close();
  session.Close();
  pool.Close();

  D3D11_MAPPED_SUBRESOURCE mapped{};
  winrt::check_hresult(context->Map(staging.Get(), 0, D3D11_MAP_READ, 0, &mapped));
  // Copy the visible rows and make every pixel opaque: composited window
  // edges can carry zero alpha.
  const UINT stride = width * 4;
  std::vector<BYTE> pixels(static_cast<size_t>(stride) * height);
  const auto* source = static_cast<const BYTE*>(mapped.pData);
  for (UINT y = 0; y < height; ++y) {
    BYTE* row = pixels.data() + static_cast<size_t>(y) * stride;
    std::copy_n(source + static_cast<size_t>(y) * mapped.RowPitch, stride, row);
    for (UINT x = 3; x < stride; x += 4) row[x] = 0xFF;
  }
  context->Unmap(staging.Get(), 0);

  const std::wstring path = directory + L"\\screenshot-" +
                            std::to_wstring(::GetTickCount64()) + L".png";
  winrt::check_hresult(WritePng(path, width, height, stride, pixels.data()));
  return Utf8(path);
}

}  // namespace

bool Supported() {
  try {
    return wgc::GraphicsCaptureSession::IsSupported();
  } catch (...) {
    return false;
  }
}

bool Pick(HWND owner, UINT message) {
  try {
    wgc::GraphicsCapturePicker picker;
    winrt::check_hresult(picker.as<IInitializeWithWindow>()->Initialize(owner));
    picker.PickSingleItemAsync().Completed(
        [owner, message](const wf::IAsyncOperation<wgc::GraphicsCaptureItem>& op,
                         wf::AsyncStatus status) {
          auto picked = std::make_unique<Picked>();
          if (status == wf::AsyncStatus::Completed) {
            try {
              picked->item = op.GetResults();
            } catch (...) {
            }
          }
          Picked* raw = picked->item ? picked.release() : nullptr;
          if (!::PostMessageW(owner, message, 0, reinterpret_cast<LPARAM>(raw))) {
            delete raw;
          }
        });
    return true;
  } catch (...) {
    return false;
  }
}

void CaptureAsync(HWND owner, UINT message, Picked* picked,
                  std::wstring directory) {
  std::unique_ptr<Picked> item(picked);
  std::thread([owner, message, item = std::move(item),
               directory = std::move(directory)]() mutable {
    auto outcome = std::make_unique<Outcome>();
    try {
      winrt::init_apartment(winrt::apartment_type::multi_threaded);
      outcome->path = CaptureToPng(item->item, directory);
      if (outcome->path.empty()) outcome->error = "failed";
    } catch (...) {
      outcome->error = "failed";
    }
    item.reset();
    winrt::uninit_apartment();
    Outcome* raw = outcome.release();
    if (!::PostMessageW(owner, message, 0, reinterpret_cast<LPARAM>(raw))) {
      delete raw;
    }
  }).detach();
}

void Release(Picked* picked) { delete picked; }

}  // namespace ares::capture
