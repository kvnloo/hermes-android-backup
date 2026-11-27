import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

// Mark the rendered message text, not the bubble's sender label, tool
// disclosures, media cards or actions. MetaData does not affect layout.
enum _TranscriptPart { body }

Widget transcriptBody(Widget child) =>
    MetaData(metaData: _TranscriptPart.body, child: child);

bool isTranscriptBody(RenderObject node) =>
    node is RenderMetaData && node.metaData == _TranscriptPart.body;
