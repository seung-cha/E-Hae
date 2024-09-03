import 'package:flutter/material.dart';
import 'package:frontend/kindle/kindleToolbar.dart';
import 'kindlePageView.dart';
import 'package:flutter/services.dart';
import 'kindleController.dart';

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
    controller = KindleController(await Backend.openFile(widget.path));
    controller.onSomePagesLoad.add(onSomePagesLoad);
  }

  @override
  void initState() {
    BrowserContextMenu.disableContextMenu();
    openFile();
    super.initState();
  }

  @override
  void dispose() {
    controller.onSomePagesLoad.remove(onSomePagesLoad);
    super.dispose();
  }

  void onSomePagesLoad() => setState(() {});

  @override
  Widget build(BuildContext context) {
    // Wait until kindle controller is initialised.
    if (!controller.ready) {
      return const Text("Loading");
    }

    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.arrowUp): () {
          controller.toPrevPage();
        },
        const SingleActivator(LogicalKeyboardKey.arrowDown): () {
          controller.toNextPage();
        },
      },
      child: Row(
        children: [
          KindleToolBar(controller, context),
          Expanded(
            child: SelectionArea(
              onSelectionChanged: (value) => setState(() {
                controller
                    .notifyTextSelection(value != null ? value.plainText : "");
              }),
              child: KindlePageView(controller),
            ),
          ),
        ],
      ),
    );
  }
}
