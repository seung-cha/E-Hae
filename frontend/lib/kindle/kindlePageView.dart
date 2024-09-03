import 'package:flutter/material.dart';
import 'package:frontend/kindle/kindleController.dart';
import '../type/kindlePage.dart';

class KindlePageView extends StatefulWidget {
  const KindlePageView(this.controller, {super.key});

  final KindleController controller;
  @override
  createState() => _KindlePageView();
}

class _KindlePageView extends State<KindlePageView> {
  double scale = 1.0;
  late KindlePage page;
  @override
  void initState() {
    super.initState();
    page = widget.controller.getPage();

    widget.controller.onPageChanged.add(onPageChanged);
    widget.controller.onScaleChanged.add(onScaleChanged);
  }

  @override
  void dispose() {
    widget.controller.onPageChanged.remove(onPageChanged);
    widget.controller.onScaleChanged.remove(onScaleChanged);
    super.dispose();
  }

  void onPageChanged(KindlePage page) => setState(() => this.page = page);
  void onScaleChanged(double scale) => setState(() => this.scale = scale);

  @override
  Widget build(BuildContext context) {
    return FocusScope(
      autofocus: true,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(color: Colors.black45),
          Transform.scale(
            scale: scale,
            child: Container(
              width: page.width,
              height: page.height,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 250, 250, 250),
                border: Border.all(),
              ),
              child: page.build(),
            ),
          ),
        ],
      ),
    );
  }
}
