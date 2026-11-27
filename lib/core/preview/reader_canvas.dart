import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../l10n/l10n.dart';
import 'preview_evidence.dart';
import 'reader_document.dart';

typedef AddPreviewPin =
    Future<void> Function(Rect documentRect, String selector, Uint8List crop);

class _CropBoundary extends SingleChildRenderObjectWidget {
  const _CropBoundary({required super.key, required super.child});
  @override
  _CropLayer createRenderObject(BuildContext context) => _CropLayer();
}

class _CropLayer extends RenderRepaintBoundary {
  Future<ui.Image> capture(Rect rect) => (layer! as OffsetLayer).toImage(
    rect,
    pixelRatio: math.min(1.0, 768 / math.max(rect.width, rect.height)),
  );
}

class ReaderCanvas extends StatefulWidget {
  const ReaderCanvas({
    super.key,
    required this.document,
    required this.annotate,
    required this.pins,
    required this.scroll,
    required this.onLink,
    required this.onCrop,
    required this.onError,
  });
  final ReaderDocument document;
  final bool annotate;
  final List<PreviewPin> pins;
  final ScrollController scroll;
  final ValueChanged<Uri> onLink;
  final AddPreviewPin onCrop;
  final VoidCallback onError;
  @override
  State<ReaderCanvas> createState() => _ReaderCanvasState();
}

class _ReaderCanvasState extends State<ReaderCanvas> {
  final _boundary = GlobalKey();
  final _rows = <int, GlobalKey>{};
  Offset? _start, _end;
  bool _capturing = false;
  _CropLayer get _surface =>
      _boundary.currentContext!.findRenderObject()! as _CropLayer;
  Rect? _rowRect(GlobalKey key) {
    final row = key.currentContext?.findRenderObject();
    if (row is! RenderBox || !row.attached || !row.hasSize) return null;
    return row.localToGlobal(Offset.zero, ancestor: _surface) & row.size;
  }

  @override
  void didUpdateWidget(ReaderCanvas old) {
    super.didUpdateWidget(old);
    if (!identical(old.document, widget.document)) {
      _rows.clear();
      _start = null;
      _end = null;
    }
  }

  double get _offset {
    final positions = widget.scroll.positions;
    return positions.length == 1 ? positions.first.pixels : 0;
  }

  Future<void> _capture(Rect requested, String label) async {
    if (_capturing || !widget.annotate) return;
    final document = widget.document;
    final rect = requested.intersect(Offset.zero & _surface.size);
    if (rect.width < 2 ||
        rect.height < 2 ||
        widget.scroll.positions.length != 1) {
      return;
    }
    final location = rect.shift(Offset(0, _offset));
    _capturing = true;
    try {
      final image = await _surface.capture(rect);
      try {
        final data = await image.toByteData(format: ui.ImageByteFormat.png);
        if (data == null) throw StateError('No crop');
        if (!mounted ||
            !identical(widget.document, document) ||
            !widget.annotate) {
          return;
        }
        await widget.onCrop(
          location,
          label,
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
        );
      } finally {
        image.dispose();
      }
    } catch (_) {
      if (mounted) widget.onError();
    } finally {
      _capturing = false;
    }
  }

  void _element(Offset point) {
    for (final entry in _rows.entries) {
      final r = _rowRect(entry.value);
      if (r != null && r.contains(point)) {
        _capture(r, widget.document.blocks[entry.key].selector);
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final entries = widget.document.blocks;
    return ClipRect(
      child: Stack(
        fit: StackFit.expand,
        children: [
          _CropBoundary(
            key: _boundary,
            child: ColoredBox(
              color: Theme.of(context).colorScheme.surface,
              child: ListView.builder(
                controller: widget.scroll,
                itemCount: entries.length,
                padding: const EdgeInsets.all(12),
                itemBuilder: (context, i) {
                  final b = entries[i];
                  final heading = RegExp(r'^h[1-6]$').hasMatch(b.tag);
                  return Container(
                    key: _rows.putIfAbsent(i, GlobalKey.new),
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: InkWell(
                      onTap: b.link == null
                          ? null
                          : () => widget.onLink(b.link!),
                      child: Text(
                        b.text,
                        style: TextStyle(
                          fontSize: heading ? 22 : 15,
                          fontWeight: heading ? FontWeight.bold : null,
                          fontFamily: b.tag == 'pre' || b.tag == 'code'
                              ? 'monospace'
                              : null,
                          color: b.link != null
                              ? Theme.of(context).colorScheme.primary
                              : null,
                          decoration: b.link != null
                              ? TextDecoration.underline
                              : null,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          IgnorePointer(
            child: AnimatedBuilder(
              animation: widget.scroll,
              builder: (_, _) => Stack(
                children: [
                  for (final p in widget.pins)
                    Positioned(
                      left: p.rect.left,
                      top: p.rect.top - _offset,
                      child: Badge(
                        label: Text(
                          context.sharedL10n.rel_chat_preview_pin_number(
                            p.number,
                          ),
                        ),
                      ),
                    ),
                  if (_start != null && _end != null)
                    Positioned.fromRect(
                      rect: Rect.fromPoints(_start!, _end!),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).colorScheme.tertiary,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (widget.annotate)
            GestureDetector(
              key: const ValueKey('preview-annotation-surface'),
              behavior: HitTestBehavior.opaque,
              onTapUp: (d) => _element(d.localPosition),
              onPanDown: (d) => _start = d.localPosition,
              onPanUpdate: (d) => setState(() => _end = d.localPosition),
              onPanCancel: () => setState(() {
                _start = null;
                _end = null;
              }),
              onPanEnd: (_) {
                final a = _start, b = _end;
                setState(() {
                  _start = null;
                  _end = null;
                });
                if (a != null && b != null) {
                  _capture(
                    Rect.fromPoints(a, b),
                    context.sharedL10n.release_preview_reader_region,
                  );
                }
              },
            ),
        ],
      ),
    );
  }
}
