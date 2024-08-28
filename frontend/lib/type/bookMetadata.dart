import 'dart:collection';
import 'package:flutter/material.dart';

class BookMetadata {
  late double width;
  late double height;
  late String id;
  late int pageCount;
  TableOfContents tableOfContents = TableOfContents();

  BookMetadata();
  BookMetadata.fromJson(Map<String, dynamic> json)
      : width = json['width'] as double,
        height = json['height'] as double,
        id = json['id'] as String,
        pageCount = json['pageCount'] as int,
        tableOfContents =
            TableOfContents.fromJson(Queue<List<dynamic>>.from(json['toc']));
}

/// The root of all table of contents elements, stored as a tree.
class TableOfContents {
  final List<TocElement> elements = [];

  TableOfContents();
  TableOfContents.fromJson(Queue<List<dynamic>> json) {
    while (json.isNotEmpty) {
      elements.add(TocElement.fromJson(json));
    }
  }
}

class TocElement {
  final List<TocElement> childs = [];
  late int page;
  late String name = "";

  TocElement({this.page = 0});
  TocElement.fromJson(Queue<List<dynamic>> json)
      : page = json.first[2] as int,
        name = json.first[1] as String {
    final int lvl = json.first[0];
    json.removeFirst();
    while (json.isNotEmpty) {
      final int nextLvl = json.first[0];

      if (nextLvl > lvl) {
        // Nested ToC, append.
        childs.add(TocElement.fromJson(json));
      } else {
        break;
      }
    }
  }
}
