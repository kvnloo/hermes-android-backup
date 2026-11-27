; Ares for Windows: Inno Setup installer for testing and direct distribution.
; The Microsoft Store route uses the MSIX package instead (see README.md).
;
; Build on Windows after `flutter build windows --release`:
;   ISCC.exe windows\installer\ares.iss
; Output: build\windows\installer\Ares-<version>-windows-x64-setup.exe
;
; The app needs the Visual C++ runtime DLLs beside ares.exe. `msix:build` adds
; them to the Store package but removes them from Release afterwards, so to
; ship exactly what the Store package contains, point SourceDir at an unpacked
; MSIX (the package metadata is left out below):
;   ISCC.exe /DSourceDir=C:\path\to\unpacked-msix windows\installer\ares.iss
;
; Installs for the current user only; no administrator rights needed.

#define MyAppName "Ares"
; Keep in step with pubspec.yaml, or pass /DMyAppVersion=x.y.z to ISCC.
#ifndef MyAppVersion
  #define MyAppVersion "5.0.0"
#endif
#define MyAppPublisher "Sam Russell"
#define MyAppURL "https://github.com/rusty4444/ares"
#define MyAppExeName "ares.exe"
#ifndef SourceDir
  #define SourceDir "..\..\build\windows\x64\runner\Release"
#endif

[Setup]
; Stable AppId: keep across versions so upgrades replace the same install.
AppId={{DE4D43E8-2BC7-4840-8A68-6A57D0FF0DF9}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
DefaultDirName={localappdata}\Programs\{#MyAppName}
DefaultGroupName={#MyAppName}
PrivilegesRequired=lowest
OutputDir=..\..\build\windows\installer
OutputBaseFilename=Ares-{#MyAppVersion}-windows-x64-setup
SetupIconFile=..\runner\resources\app_icon.ico
UninstallDisplayIcon={app}\{#MyAppExeName}
UninstallDisplayName={#MyAppName}
Compression=lzma2/ultra64
SolidCompression=yes
WizardStyle=modern
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
DisableProgramGroupPage=yes
; Update in place: reuse the previous install directory.
UsePreviousAppDir=yes
DisableDirPage=auto
; PrepareToInstall closes the running app itself.
CloseApplications=no
RestartApplications=no
VersionInfoCompany={#MyAppPublisher}
VersionInfoDescription={#MyAppName} for Windows
VersionInfoProductName={#MyAppName}
VersionInfoProductVersion={#MyAppVersion}
VersionInfoVersion={#MyAppVersion}.0

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
; hermes:// is also the Hermes Desktop app's scheme, so taking it over is a
; visible choice (on by default).
Name: "hermeslinks"; Description: "Open hermes:// links with Ares"; GroupDescription: "Links:"

[Files]
; The whole app folder: engine, Dart AOT, plugin DLLs, PDFium, the FFmpeg
; helpers and the licence texts. MSIX package metadata is not part of the app.
Source: "{#SourceDir}\*"; DestDir: "{app}"; Excludes: "AppxManifest.xml,AppxBlockMap.xml,AppxSignature.p7x,[Content_Types].xml,resources*.pri,\Images\*,\AppxMetadata\*"; Flags: ignoreversion recursesubdirs

[Registry]
; Only a fixed opaque toast ticket is accepted by the runner. The shell never
; evaluates or expands it. A distinct scheme is used by the MSIX manifest.
Root: HKCU; Subkey: "Software\Classes\ares-notification"; ValueType: string; ValueData: "URL:Ares notification"; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\Classes\ares-notification"; ValueName: "URL Protocol"; ValueType: string; ValueData: ""
Root: HKCU; Subkey: "Software\Classes\ares-notification\shell\open\command"; ValueType: string; ValueData: """{app}\{#MyAppExeName}"" ""%1"""
; hermes:// links: the runner accepts the whole link as the sole argument,
; forwards it to the running primary window (the toast ticket's single-instance
; path, no second activator) and Dart's router validates it. A link can
; navigate and prefill a draft; it never sends, approves or installs anything.
Root: HKCU; Subkey: "Software\Classes\hermes"; ValueType: string; ValueData: "URL:Hermes link"; Flags: uninsdeletekey; Tasks: hermeslinks
Root: HKCU; Subkey: "Software\Classes\hermes"; ValueName: "URL Protocol"; ValueType: string; ValueData: ""; Tasks: hermeslinks
Root: HKCU; Subkey: "Software\Classes\hermes\DefaultIcon"; ValueType: string; ValueData: """{app}\{#MyAppExeName}"",0"; Tasks: hermeslinks
Root: HKCU; Subkey: "Software\Classes\hermes\shell\open\command"; ValueType: string; ValueData: """{app}\{#MyAppExeName}"" ""%1"""; Tasks: hermeslinks

[Icons]
; Protocol-only activation uses Microsoft's stub-CLSID desktop toast model.
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; AppUserModelID: "com.hermesagent.ares"; AppUserModelToastActivatorCLSID: "F2BCD1C8-EDAB-4F31-A09F-39C2ED0F2A37"
Name: "{group}\Uninstall {#MyAppName}"; Filename: "{uninstallexe}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent

; Uninstalling keeps %APPDATA%\Sam Russell\Ares (saved connections and
; settings) and the secure-storage entries.

[Code]
function PrepareToInstall(var NeedsRestart: Boolean): String;
var
  ResultCode: Integer;
begin
  Result := '';
  NeedsRestart := False;
  // Close a running copy so its files can be replaced. Settings live in
  // %APPDATA% and are not touched.
  if Exec('taskkill.exe', '/IM {#MyAppExeName} /T /F', '', SW_HIDE,
    ewWaitUntilTerminated, ResultCode) then
    Sleep(500);
end;
