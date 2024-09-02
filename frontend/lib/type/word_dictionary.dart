class WordDictionary {
  final String word;
  final List<WordMeaning> meanings = [];

  WordDictionary.json(Map<String, dynamic> json) : word = json['word'] {
    for (var meaning in json['meanings']) {
      meanings.add(WordMeaning.json(meaning));
    }
  }
}

class WordMeaning {
  final String type;
  final List<WordDefinition> definitions = [];

  WordMeaning.json(Map<String, dynamic> json) : type = json['type'] {
    for (var definition in json['definitions']) {
      definitions.add(WordDefinition.json(definition));
    }
  }
}

class WordDefinition {
  final String definition;
  final String example;

  WordDefinition.json(Map<String, dynamic> json)
      : definition = json['definition'],
        example = json['example'];
}
