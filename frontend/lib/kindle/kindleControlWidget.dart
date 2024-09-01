import 'package:flutter/material.dart';
import 'package:frontend/kindle/kindleController.dart';

/// Kindle controlling tools, including zoom-in/out, page display.
class KindleControlWidget extends StatefulWidget {
  const KindleControlWidget(this.controller, this.kindlePageViewContext,
      {super.key});
  final KindleController controller;
  final BuildContext kindlePageViewContext;
  @override
  State<StatefulWidget> createState() => _KindleControlWidgetState();
}

class _KindleControlWidgetState extends State<KindleControlWidget> {
  late double scale;

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
    return Row(
      children: [
        // Zoom out, fit to screen, zoom in, zoom level, page/pagecount
        // TODO: Design the layout.
        IconButton(
          icon: const Icon(Icons.zoom_out),
          onPressed: () {
            widget.controller.changeScale(scale - 0.3);
          },
        ),
        IconButton(
          icon: const Icon(Icons.zoom_out_map),
          onPressed: () {
            double h = MediaQuery.of(widget.kindlePageViewContext).size.height;
            widget.controller
                .changeScale(h / widget.controller.metadata.height);
          },
        ),
        IconButton(
          icon: const Icon(Icons.zoom_in),
          onPressed: () {
            widget.controller.changeScale(scale + 0.3);
          },
        ),
        Text(scale.toStringAsFixed(2)),
        Text(
            "${widget.controller.getIndex()}/${widget.controller.metadata.pageCount}"),
      ],
    );
  }
}
