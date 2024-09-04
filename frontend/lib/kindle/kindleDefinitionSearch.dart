import 'package:flutter/material.dart';
import 'package:frontend/backend.dart';
import 'package:frontend/type/word_dictionary.dart';
import 'kindleController.dart';
import 'dart:convert';

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
  late WordDictionary dictionary;
  bool showDefinition = false;

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
                try {
                  dictionary =
                      await Backend.definition(textController.text, "jp");
                  showDefinition = true;
                  setState(() {});
                } catch (e) {
                  print(e);
                  showDefinition = false;
                }
              },
            ),
          ],
        ),
        showDefinition
            ? KindleDefinitionCard(dictionary: dictionary)
            : Container(),
      ],
    );
  }
}

class KindleDefinitionCard extends StatefulWidget {
  final WordDictionary dictionary;

  const KindleDefinitionCard({super.key, required this.dictionary});

  @override
  State<StatefulWidget> createState() => _KindleDefinitionCardState();
}

class _KindleDefinitionCardState extends State<KindleDefinitionCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(widget.dictionary.word, style: const TextStyle(fontSize: 28)),
        const Divider(),
        Scrollbar(
          child: ListView.separated(
            separatorBuilder: (context, index) => const Divider(),
            shrinkWrap: true,
            itemCount: widget.dictionary.meanings.length,
            itemBuilder: (context, meaningIndex) => ListView.builder(
              shrinkWrap: true,
              itemCount:
                  widget.dictionary.meanings[meaningIndex].definitions.length,
              itemBuilder: (context, definitionIndex) => Row(
                children: [
                  Flexible(
                      child: Text(
                          widget.dictionary.meanings[meaningIndex]
                              .definitions[definitionIndex].definition,
                          style: const TextStyle(fontSize: 23))),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
