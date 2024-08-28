import 'package:flutter/material.dart';
import 'kindlePageView.dart';
import 'package:flutter/services.dart';
import 'kindleController.dart';

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
    controller = KindleController(await Backend.OpenFile(widget.path),
        onSomePagesLoad: () {
      setState(() {});
    });
    // Calculate scale, fit to height
    scale = 1.0;
  }

  @override
  void initState() {
    super.initState();
    openFile();
  }

  @override
  Widget build(BuildContext context) {
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
      child: !controller.ready
          ? const Text("Loading")
          : Stack(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: SelectionArea(
                    child: KindlePageView(controller.getPage(), scale),
                  ),
                ),
              ],
            ),
    );
  }
}
