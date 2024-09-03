import 'package:flutter/material.dart';
import '../type/kindlePage.dart';
import '../type/bookMetadata.dart';
import '../backend.dart';

/// An widgetless controller for all kindle features
/// such as moving between pages, jumping to specific page etc etc.
/// Controlle is essentially a giant component that bundles sub-features together,
/// allowing for exchange of data between classes

typedef DoubleCallback = void Function(double value);
typedef PageCallback = void Function(KindlePage page);
typedef StringCallback = void Function(String value);

class KindleController {
  final List<KindlePage> _pages = [];
  final BookMetadata metadata;
  int _index = 0;
  bool ready = false;
  double _scale = 1.0;
  String _selectedStr = "";

  /// Callbacks for state change
  final List<VoidCallback> onSomePagesLoad = [];
  final List<DoubleCallback> onScaleChanged = [];
  final List<PageCallback> onPageChanged = [];
  final List<StringCallback> onTextSelected = [];

  KindleController.init() : metadata = BookMetadata();

  KindleController(
    this.metadata,
  ) {
    _loadPage();
  }

  void _loadPage() async {
    for (int i = 0; i < metadata.pageCount; i++) {
      _pages.add(await Backend.getPage(metadata.id, i));
      if (!ready) {
        for (var callback in onSomePagesLoad) {
          callback();
        }

        ready = true;
      }
    }
  }

  int getIndex() {
    return _index;
  }

  /// Get the next page, if exists.
  /// Return the current page otherwise.
  /// Invoke callbacks in onPageChanged.
  KindlePage toNextPage() {
    KindlePage p =
        _index >= _pages.length - 1 ? _pages[_index] : _pages[++_index];

    for (var callback in onPageChanged) {
      callback(p);
    }

    return p;
  }

  /// Get the prev page, similar to ToNextPage()
  /// Invoke callbacks in onPageChanged.
  KindlePage toPrevPage() {
    KindlePage p = _index <= 0 ? _pages[_index] : _pages[--_index];

    for (var callback in onPageChanged) {
      callback(p);
    }

    return p;
  }

  /// Move to page, assume valid index.
  KindlePage toPage(int index) {
    _index = index;
    KindlePage p = _pages[_index];

    for (var callback in onPageChanged) {
      callback(p);
    }

    return p;
  }

  /// Get the current page.
  KindlePage getPage() {
    return _pages[_index];
  }

  /// Change the controller's scale.
  /// Invokes onScaleChanged.
  /// Return the new scale.
  double changeScale(double scale) {
    _scale = scale;

    for (var callback in onScaleChanged) {
      callback(scale);
    }

    return scale;
  }

  /// Get the current scale.
  double getScale() => _scale;

  /// Notify subscribers that user dragged and selected text
  void notifyTextSelection(String str) {
    _selectedStr = str;
    for (var callback in onTextSelected) {
      callback(str);
    }
  }

  String getSelectedString() => _selectedStr;
}
