import 'package:flutter/material.dart';
import 'type/kindlePage.dart';
import 'backend.dart';

class KindlePageView extends StatefulWidget {
  KindlePageView(this.id, this.pageCount, this.width, this.height);

  final String id;
  final double width;
  final double height;
  final int pageCount;
  final _KindlePageView state = _KindlePageView();

  void next() {
    state.next();
  }

  void prev() {
    state.prev();
  }

  @override
  createState() => state;
}

class _KindlePageView extends State<KindlePageView> {
  late List<KindlePage> pages = [];
  bool ready = false;
  int index = 0;
  double scale = 1.0;

  void initPages() async {
    for (int i = 0; i < widget.pageCount; i++) {
      pages.add(await Backend.getPage(widget.id, i));
    }

    ready = true;
    setState(() {});
  }

  void next() {
    if (index >= widget.pageCount) return;
    index++;
    setState(() {});
  }

  void prev() {
    if (index <= 0) return;
    index--;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    initPages();
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
            scale: MediaQuery.of(context).size.height / widget.height * 0.9,
            child: Container(
              width: widget.width,
              height: widget.height,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 250, 250, 250),
                border: Border.all(),
              ),
              child: ready ? pages[index].build() : const Text("Loading"),
            ),
          ),
        ],
      ),
    );
  }
}
