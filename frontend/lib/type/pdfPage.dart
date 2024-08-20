import 'package:flutter/material.dart';

/// complies with PyMuPDF's Json structure.
class PdfPage {
  final double width;
  final double height;
  final List<TextBlock> blocks = [];

  PdfPage(this.width, this.height);

  /// Create a base object, to be filled with JSON.
  PdfPage.base()
      : width = 0,
        height = 0;

  PdfPage.fromJson(Map<String, dynamic> json)
      : width = json['width'] as double,
        height = json['height'] as double {
    final b = json['blocks'];

    for (var block in b) {
      blocks.add(TextBlock.fromJson(block));
    }
  }

  /// Return widgets making up for this page.
  List<Widget> build({TextAlign? alignMode = null}) {
    final List<Widget> widgets = [];

    for (var block in blocks) {
      for (var line in block.lines) {
        List<TextSpan> textSpans = [];

        for (var span in line.spans) {
          // Spans essentially make up a line.
          // Therefore, merge all into one.
          textSpans.add(
            TextSpan(
              text: span.text,
              style: TextStyle(fontSize: span.fontSize),
            ),
          );
        }

        TextSpan span0 = TextSpan(children: textSpans);

        widgets.add(
          Text.rich(
            span0,
            textAlign: alignMode,
            softWrap: true,
          ),
        );
      }
    }

    return widgets;
  }
}

class TextBlock {
  final List<Line> lines = [];

  TextBlock.fromJson(Map<String, dynamic> json) {
    final l = json['lines'];
    for (var line in l) {
      lines.add(Line.fromJson(line));
    }
  }
}

class Line {
  final List<Span> spans = [];

  Line.fromJson(Map<String, dynamic> json) {
    final s = json['spans'];
    for (var span in s) {
      spans.add(Span.fromJson(span));
    }
  }
}

class Span {
  final String font;
  final double fontSize;
  late Origin origin = Origin.zero();
  final String text;

  Span.fromJson(Map<String, dynamic> json)
      : font = json['font'] as String,
        fontSize = json['size'] as double,
        text = json['text'] as String {
    origin = Origin.fromJson(json['origin']);
  }
}

class Origin {
  final double x;
  final double y;

  Origin(this.x, this.y);
  Origin.zero()
      : x = 0,
        y = 0;

  Origin.fromJson(List<dynamic> json)
      : x = json[0] as double,
        y = json[1] as double;
}
