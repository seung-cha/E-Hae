import 'package:flutter/material.dart';
import 'package:frontend/kindle/kindleController.dart';

/// Kindle controlling tools, including zoom-in/out, page display.
class KindleControlWidget extends StatefulWidget {
  const KindleControlWidget(this.controller, this.kindleViewContext,
      {super.key});
  final KindleController controller;
  final BuildContext kindleViewContext;
  @override
  State<StatefulWidget> createState() => _KindleControlWidgetState();
}

class _KindleControlWidgetState extends State<KindleControlWidget> {
  late double scale;
  final iconSize = 32.0;
  final fontSize = 24.0;

  @override
  void initState() {
    super.initState();
    scale = widget.controller.getScale();
    widget.controller.onScaleChanged.add((scale) => setState(() {
          this.scale = scale;
        }));
    widget.controller.onPageChanged.add((page) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Zoom out, fit to screen, zoom in, zoom level,
        // To prev, Page/Pagecount, To next
        // TODO: Design the layout.
        IconButton(
          iconSize: iconSize,
          icon: const Icon(Icons.keyboard_arrow_up),
          onPressed: () {
            widget.controller.toPrevPage();
          },
        ),
        Text(
            "${widget.controller.getIndex()}/${widget.controller.metadata.pageCount}",
            style: TextStyle(fontSize: fontSize)),
        IconButton(
          iconSize: iconSize,
          icon: const Icon(Icons.keyboard_arrow_down),
          onPressed: () {
            widget.controller.toNextPage();
          },
        ),
        IconButton(
          iconSize: iconSize,
          icon: const Icon(Icons.zoom_in),
          onPressed: () {
            widget.controller.changeScale(scale + 0.3);
          },
        ),
        IconButton(
          iconSize: iconSize,
          icon: const Icon(Icons.zoom_out_map),
          onPressed: () {
            double h = MediaQuery.of(widget.kindleViewContext).size.height;
            widget.controller
                .changeScale(h / widget.controller.metadata.height);
          },
        ),
        IconButton(
          iconSize: iconSize,
          icon: const Icon(Icons.zoom_out),
          onPressed: () {
            widget.controller.changeScale(scale - 0.3);
          },
        ),
        Text(scale.toStringAsFixed(2), style: TextStyle(fontSize: fontSize)),
      ],
    );
  }
}
