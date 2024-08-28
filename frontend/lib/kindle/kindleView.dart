import 'package:flutter/material.dart';
import 'kindlePageView.dart';
import 'package:flutter/services.dart';
import 'kindleController.dart';
import 'tocView.dart';

import '../backend.dart';

class KindleView extends StatefulWidget {
  KindleView();

  // TODO: REMOVE THIS
  final String path = './book_samples/novel_text_only.pdf';
  @override
  State<StatefulWidget> createState() => _KindleViewState();
}

class _KindleViewState extends State<KindleView> {
  double scale = 1.0;
  int page = 0;

  late KindleController controller = KindleController.init();

  void openFile() async {
    controller = KindleController(await Backend.openFile(widget.path),
        onSomePagesLoad: () {
      setState(() {});
    });
    // Calculate scale, fit to height
  }

  @override
  void initState() {
    scale = 1.0;
    openFile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Wait until kindle controller is initialised.
    if (!controller.ready) {
      return const Text("Loading");
    }

    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.space): () {
          setState(() {
            controller.toNextPage();
          });
        },
        const SingleActivator(LogicalKeyboardKey.arrowLeft): () {
          setState(() {
            controller.toPrevPage();
          });
        }
      },
      child: Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
            child: SelectionArea(
              child: KindlePageView(controller.getPage(), scale),
            ),
          ),
          Align(
              alignment: Alignment.centerLeft,
              child: TocView(controller, () {
                setState(() {});
              })),
        ],
      ),
    );
  }
}
