import 'package:flutter/material.dart';
import 'kindlePageView.dart';
import 'type/bookMetadata.dart';
import 'package:flutter/services.dart';
import 'kindleController.dart';

import 'backend.dart';

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

  late KindleController controller = KindleController.NotReady();

  void OpenFile() async {
    controller = KindleController(await Backend.OpenFile(widget.path),
        onSomePagesLoad: () {
      setState(() {});
    });
    // Calculate scale, fit to height
    scale =
        MediaQuery.of(context).size.height / controller.metadata.height * 0.8;
  }

  @override
  void initState() {
    super.initState();
    OpenFile();
  }

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: {
        SingleActivator(LogicalKeyboardKey.space): () {
          setState(() {
            controller.ToNextPage();
          });
        },
        SingleActivator(LogicalKeyboardKey.arrowLeft): () {
          setState(() {
            controller.ToPrevPage();
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
                    child: KindlePageView(controller.GetPage(), scale),
                  ),
                ),
              ],
            ),
    );
  }
}
