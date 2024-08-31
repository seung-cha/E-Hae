import 'package:flutter/material.dart';
import 'kindleController.dart';
import '../type/bookMetadata.dart';

/// Vertical list that displays table of contents.
/// Consists of TocView which holds each ToC element and ExpansionTileToc
/// which is clickable and expandable (if it has children). onPageChanged is invoked
/// whenever a Toc element is clikced to change page.

class TocView extends StatefulWidget {
  final KindleController controller;
  final VoidCallback onPageChanged;
  const TocView(this.controller, this.onPageChanged, {super.key});

  @override
  State<StatefulWidget> createState() => _TocViewState();
}

class _TocViewState extends State<TocView> {
  late TableOfContents toc;
  final List<ExpansionTileToc> list = [];

  @override
  void initState() {
    toc = widget.controller.metadata.tableOfContents;

    for (var elem in toc.elements) {
      list.add(ExpansionTileToc(widget.controller, elem, widget.onPageChanged));
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: list,
    );
  }
}

class ExpansionTileToc extends StatefulWidget {
  final KindleController controller;
  final TocElement tocElement;
  final VoidCallback onPageChange;
  const ExpansionTileToc(this.controller, this.tocElement, this.onPageChange,
      {super.key});
  @override
  State<StatefulWidget> createState() => _ExpansionTileTocState();
}

/// Expansion panel for nested toc elements.
/// Use this even if an element doesn't have any child.
class _ExpansionTileTocState extends State<ExpansionTileToc> {
  bool expanded = false;

  final List<ExpansionTileToc> _list = [];

  @override
  void initState() {
    super.initState();
    for (var elem in widget.tocElement.childs) {
      _list.add(ExpansionTileToc(widget.controller, elem, widget.onPageChange));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.tocElement.childs.isNotEmpty) {
      return ExpansionTile(
        title: Text(widget.tocElement.name),
        children: _list,
        onExpansionChanged: (value) {
          widget.controller.toPage(widget.tocElement.page);
          widget.onPageChange();
        },
      );
    } else {
      return TextButton(
          onPressed: () {
            widget.controller.toPage(widget.tocElement.page);
            widget.onPageChange();
          },
          child: Text(widget.tocElement.name));
    }
  }
}
