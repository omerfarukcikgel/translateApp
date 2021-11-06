import 'package:flutter/foundation.dart';
import 'package:translateapp/main.dart';
import 'package:translateapp/models/language.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'package:http/http.dart' as http;

String sourceText = "";
String targetText = "";
List<String> sList = [];
String translatedText = "";

Future<List<Language>> fetchLanguages(http.Client client) async {
  final response =
      await client.get(Uri.parse('https://libretranslate.de/languages'));

  return compute(parseLanguages, response.body);
}

List<Language> parseLanguages(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Language>((json) => Language.fromJson(json)).toList();
}

Future postLanguages() async {
  final req = await http
      .post(Uri.parse('https://libretranslate.de/translate'), headers: {
    'accept': 'application/json',
    'Content-Type': 'application/x-www-form-urlencoded'
  }, body: {
    'q': sourceController.text,
    'source': sourceText,
    'target': targetText
  });

  translatedText = req.body;

  return translatedText.split(":").last.replaceAll('}', "").replaceAll('"', "");
}
