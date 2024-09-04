import 'package:flutter/material.dart';
import 'package:frontend/kindle/kindleControlWidget.dart';
import 'package:frontend/kindle/kindleDefinitionSearch.dart';
import 'package:frontend/kindle/tocView.dart';
import 'kindleController.dart';

class KindleToolBar extends StatefulWidget {
  final KindleController controller;
  final BuildContext kindleViewContext;

  const KindleToolBar(this.controller, this.kindleViewContext, {super.key});

  @override
  State<StatefulWidget> createState() => _KindleToolbarState();
}

class _KindleToolbarState extends State<KindleToolBar> {
  late List<Widget> toolbarOptions;
  late List<Widget> toolbarIcons;
  late List<bool> toolbarOptionsSelected = List.filled(2, false);

  bool hasItemSelected = false;
  Widget selectedWidget = Container();

  @override
  void initState() {
    super.initState();

    toolbarOptions = [
      TocView(widget.controller),
      KindleDefinitionSearch(widget.controller),
      const SizedBox(),
    ];

    toolbarIcons = const [
      Icon(Icons.list_alt, size: 32.0),
      Icon(Icons.translate, size: 32.0),
      Icon(Icons.bookmark_sharp, size: 32.0),
    ];

    toolbarOptionsSelected = List.filled(toolbarOptions.length, false);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(border: Border.all()),
          width: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const Divider(thickness: 5.0),
                  ToggleButtons(
                    isSelected: toolbarOptionsSelected,
                    direction: Axis.vertical,
                    onPressed: (index) => setState(() {
                      // Handle toggle/widget display
                      for (int i = 0; i < toolbarOptionsSelected.length; i++) {
                        if (i == index) {
                          toolbarOptionsSelected[i] =
                              !toolbarOptionsSelected[i];
                          hasItemSelected = toolbarOptionsSelected[i];

                          if (hasItemSelected) {
                            selectedWidget = toolbarOptions[i];
                          } else {
                            selectedWidget = Container();
                          }
                        } else {
                          toolbarOptionsSelected[i] = false;
                        }
                      }
                    }),
                    children: toolbarIcons,
                  ),
                ],
              ),
              Column(
                children: [
                  KindleControlWidget(
                      widget.controller, widget.kindleViewContext),
                  const Divider(thickness: 5.0),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          width: hasItemSelected ? 500 : 0,
          child: selectedWidget,
        )
      ],
    );
  }
}
