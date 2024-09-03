import 'package:flutter/material.dart';
import 'package:frontend/backend.dart';
import 'package:frontend/type/word_dictionary.dart';
import 'kindleController.dart';

/// Widget to search for a word and get a list of definitions.
/// Each PDF is marked a language (may support more) and user is expected
/// to search for the definition of a word they find on the book.
/// TODO: Implement language tag and store it in KindleController
/// TODO: Create a widget for word definition
/// TODO: Integrate Anki
class KindleDefinitionSearch extends StatefulWidget {
  final KindleController controller;
  const KindleDefinitionSearch(this.controller, {super.key});

  @override
  State<StatefulWidget> createState() => _KindleDefinitionSearchState();
}

class _KindleDefinitionSearchState extends State<KindleDefinitionSearch> {
  late TextEditingController textController;
  String temp = "";
  @override
  void initState() {
    super.initState();
    widget.controller.onTextSelected.add(onTextSelected);
    textController = TextEditingController();
    textController.text = widget.controller.getSelectedString();
  }

  @override
  void dispose() {
    widget.controller.onTextSelected.remove(onTextSelected);
    textController.dispose();
    super.dispose();
  }

  void onTextSelected(String value) => setState(() {
        textController.text = value;
      });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                width: 200,
                height: 100,
                child: TextField(controller: textController)),
            TextButton(
              child: const Text('Search'),
              onPressed: () async {
                // TODO
                WordDictionary dict =
                    await Backend.definition(textController.text, "en");
                setState(() {
                  temp = dict.meanings[0].definitions[0].definition;
                });
              },
            ),
          ],
        ),
        Text(temp),
      ],
    );
  }
}
