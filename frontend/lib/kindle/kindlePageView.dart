import 'package:flutter/material.dart';
import 'type/kindlePage.dart';

class KindlePageView extends StatefulWidget {
  KindlePageView(this._page, this._scale);

  final KindlePage _page;
  final double _scale;
  @override
  createState() => _KindlePageView();
}

class _KindlePageView extends State<KindlePageView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FocusScope(
      autofocus: true,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(color: Colors.black45),
          Transform.scale(
            scale: widget._scale,
            child: Container(
              width: widget._page.width,
              height: widget._page.height,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 250, 250, 250),
                border: Border.all(),
              ),
              child: widget._page.build(),
            ),
          ),
        ],
      ),
    );
  }
}
