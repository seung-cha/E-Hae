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

class KindleController {
  final List<KindlePage> _pages = [];
  final BookMetadata metadata;
  int _index = 0;
  bool ready = false;
  double scale = 1.0;

  /// Callbacks for state change
  final List<VoidCallback> onSomePagesLoad = [];
  final List<DoubleCallback> onScaleChanged = [];
  final List<PageCallback> onPageChanged = [];

  KindleController.init() : metadata = BookMetadata();

  KindleController(this.metadata,
      {VoidCallback? onSomePagesLoad,
      DoubleCallback? onScaleChanged,
      PageCallback? onPageChanged}) {
    // Subscribe to events
    if (onSomePagesLoad != null) this.onSomePagesLoad.add(onSomePagesLoad);
    if (onScaleChanged != null) this.onScaleChanged.add(onScaleChanged);
    if (onPageChanged != null) this.onPageChanged.add(onPageChanged);

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
    this.scale = scale;

    for (var callback in onScaleChanged) {
      callback(scale);
    }

    return scale;
  }

  /// Get the current scale.
  double getScale() {
    return scale;
  }
}
