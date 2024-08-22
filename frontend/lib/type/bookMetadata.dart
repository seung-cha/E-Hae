import 'dart:collection';
import 'package:flutter/material.dart';

class BookMetadata {
  final double width;
  final double height;
  final String id;
  final int pageCount;
  final TableOfContents tableOfContents;

  BookMetadata(
      this.id, this.pageCount, this.width, this.height, this.tableOfContents);
  BookMetadata.fromJson(Map<String, dynamic> json)
      : width = json['width'] as double,
        height = json['height'] as double,
        id = json['id'] as String,
        pageCount = json['pageCount'] as int,
        tableOfContents = TableOfContents.fromJson(
            new Queue<List<dynamic>>.from(json['toc']));
}

/// The root of all table of contents elements, stored as a tree.
class TableOfContents {
  final List<TocElement> elements = [];

  TableOfContents.fromJson(Queue<List<dynamic>> json) {
    while (json.isNotEmpty) {
      elements.add(TocElement.fromJson(json));
    }
  }

  List<Widget> build() {
    List<Widget> widgets = [];
    for (var element in elements) {
      element.build(widgets);
    }

    return widgets;
  }
}

class TocElement {
  final List<TocElement> childs = [];
  final int page;

  TocElement(this.page);
  TocElement.fromJson(Queue<List<dynamic>> json) : page = json.first[2] as int {
    final int lvl = json.first[0];
    json.removeFirst();
    while (json.isNotEmpty) {
      final int nextLvl = json.first[0];

      if (nextLvl <= lvl) {
        break;
      } else {
        // Nested ToC, append.
        childs.add(TocElement.fromJson(json));
      }
    }
  }

  /// Interface for building a hierarchy of widgets.
  void build(List<Widget> out) {
    out.add(_build());
    for (var child in childs) {
      child.build(out);
    }
  }

  /// Build actual widget for this TOC element.
  Widget _build() {
    return Container();
  }
}
