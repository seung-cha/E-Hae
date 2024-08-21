import 'package:flutter/material.dart';
import 'type/pdfPage.dart';

class KindleViewPage extends StatelessWidget {
  final PdfPage page;

  KindleViewPage(this.page);

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 1.5,
      child: page.build(),
    );
  }
}
