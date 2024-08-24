import 'package:flutter/material.dart';
import 'kindlePageView.dart';
import 'type/bookMetadata.dart';
import 'package:flutter/services.dart';

import 'backend.dart';

class KindleView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _KindleViewState();
}

class _KindleViewState extends State<KindleView> {
  double scale = 1.0;
  int page = 0;
  BookMetadata metaData = BookMetadata();
  KindlePageView? pageView;

  void openFile() async {
    metaData = await Backend.openFile('./book_samples/novel_text_only.pdf');
    pageView = KindlePageView(
        metaData.id, metaData.pageCount, metaData.width, metaData.height);

    setState(() {});
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
        SingleActivator(LogicalKeyboardKey.space): () {
          pageView?.next();
        },
        SingleActivator(LogicalKeyboardKey.arrowLeft): () {
          pageView?.prev();
        }
      },
      child: Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
            child: SelectionArea(
              child: pageView ?? const Text("loading"),
            ),
          ),
          metaData.tableOfContents.build(),
        ],
      ),
    );
  }
}
