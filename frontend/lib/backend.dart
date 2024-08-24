import 'package:http/http.dart' as http;
import 'type/kindlePage.dart';
import 'type/bookMetadata.dart';
import 'dart:convert';
// Helper for calling backend functions

class Backend {
  static final String _url = '127.0.0.1:5000';
  static Future<KindlePage> GetPage(String id, int i) async {
    final res =
        await http.get(Uri.http(_url, '/get', {'id': id, 'no': i.toString()}));
    return KindlePage.fromJson(json.decode(res.body) as Map<String, dynamic>);
  }

  static Future<BookMetadata> OpenFile(String path) async {
    final res = await http.post(Uri.http(_url, 'open', {'path': path}));
    return BookMetadata.fromJson(json.decode(res.body) as Map<String, dynamic>);
  }
}
