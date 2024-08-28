import 'package:flutter/material.dart';
import '../type/kindlePage.dart';
import '../type/bookMetadata.dart';
import '../backend.dart';

/// An widgetless controller for all kindle features
/// such as moving between pages, jumping to specific page etc etc.
/// Controlle is essentially a giant component that bundles sub-features together,
/// allowing for exchange of data between classes

class KindleController {
  final List<KindlePage> _pages = [];
  final BookMetadata metadata;
  int _index = 0;
  bool ready = false;
  VoidCallback? onSomePagesLoad;

  KindleController.init() : metadata = BookMetadata();

  KindleController(this.metadata, {this.onSomePagesLoad}) {
    _loadPage();
  }

  void _loadPage() async {
    for (int i = 0; i < metadata.pageCount; i++) {
      _pages.add(await Backend.GetPage(metadata.id, i));
      if (!ready) {
        onSomePagesLoad?.call();
        ready = true;
      }
    }
  }

  /// Get the next page, if exists.
  /// Return the current page otherwise.
  KindlePage toNextPage() {
    if (_index >= _pages.length - 1) return _pages[_index];
    return _pages[++_index];
  }

  /// Get the prev page, similar to ToNextPage()
  KindlePage toPrevPage() {
    if (_index <= 0) return _pages[_index];
    return _pages[--_index];
  }

  /// Move to page, assume valid index.
  KindlePage toPage(int index) {
    _index = index;
    return _pages[_index];
  }

  /// Get the current page.
  KindlePage getPage() {
    return _pages[_index];
  }
}
