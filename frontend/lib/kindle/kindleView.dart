import 'package:flutter/material.dart';
import 'package:frontend/kindle/kindleControlWidget.dart';
import 'package:frontend/kindle/kindleToolbar.dart';
import 'kindlePageView.dart';
import 'package:flutter/services.dart';
import 'kindleController.dart';
import 'tocView.dart';

import '../backend.dart';

class KindleView extends StatefulWidget {
  const KindleView({super.key});

  // TODO: REMOVE THIS
  final String path = './book_samples/novel_text_only.pdf';
  @override
  State<StatefulWidget> createState() => _KindleViewState();
}

class _KindleViewState extends State<KindleView> {
  int page = 0;

  late KindleController controller = KindleController.init();

  void openFile() async {
    controller = KindleController(await Backend.openFile(widget.path),
        onSomePagesLoad: () {
      setState(() {});
    });
  }

  @override
  void initState() {
    BrowserContextMenu.disableContextMenu();
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
          controller.toNextPage();
        },
        const SingleActivator(LogicalKeyboardKey.arrowLeft): () {
          controller.toPrevPage();
        }
      },
      child: Row(
        children: [
          // Align(
          //   alignment: Alignment.centerLeft,
          //   child: SizedBox(
          //     width: MediaQuery.of(context).size.width * 0.25,
          //     child: TocView(controller),
          //   ),
          // ),
          KindleToolBar(controller, context),
          Expanded(
            child: SelectionArea(
              onSelectionChanged: (value) {
                print(value?.plainText);
              },
              child: KindlePageView(controller),
            ),
          ),
          // Align(
          //   alignment: Alignment.bottomLeft,
          //   child: KindleControlWidget(controller, context),
          // ),
        ],
      ),
    );
  }
}
