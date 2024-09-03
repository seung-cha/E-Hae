import 'package:http/http.dart' as http;
import 'type/kindlePage.dart';
import 'type/bookMetadata.dart';
import 'type/word_dictionary.dart';
import 'dart:convert';
// Helper for calling backend functions

class Backend {
  static const String _url = '127.0.0.1:5000';
  static Future<KindlePage> getPage(String id, int i) async {
    final res = await http
        .get(Uri.http(_url, '/getPage', {'id': id, 'no': i.toString()}));
    return KindlePage.fromJson(json.decode(res.body) as Map<String, dynamic>);
  }

  static Future<BookMetadata> openFile(String path) async {
    final res = await http.post(Uri.http(_url, '/open', {'path': path}));
    return BookMetadata.fromJson(json.decode(res.body) as Map<String, dynamic>);
  }

  static Future<WordDictionary> definition(String word, String lang) async {
    final res = await http
        .get(Uri.http(_url, '/definition', {'word': word, 'lang': lang}));

    return WordDictionary.json(json.decode(res.body) as Map<String, dynamic>);
  }
}
