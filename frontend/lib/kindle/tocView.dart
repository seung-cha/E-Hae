import 'package:flutter/material.dart';
import 'kindleController.dart';
import '../type/bookMetadata.dart';

class TocView extends StatefulWidget {
  final KindleController controller;
  final VoidCallback onPageChanged;
  const TocView(this.controller, this.onPageChanged, {super.key});

  @override
  State<StatefulWidget> createState() => _TocViewState();
}

class _TocViewState extends State<TocView> {
  late TableOfContents toc;

  @override
  void initState() {
    toc = widget.controller.metadata.tableOfContents;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, i) {
        return TextButton(
          child: Text(toc.elements[i].name),
          onPressed: () {
            widget.controller.toPage(toc.elements[i].page);
            widget.onPageChanged();
          },
        );
      },
      itemCount: toc.elements.length,
    );
  }

  /// TODO: Recursively build clickable toc tree
  Widget buildTocTree(BuildContext context) {
    throw UnimplementedError();
  }
}
