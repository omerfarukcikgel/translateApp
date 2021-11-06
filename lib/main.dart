import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:translateapp/models/language.dart';
import 'package:translateapp/services/language_services.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Language>>(
        future: fetchLanguages(http.Client()),
        builder: (context, snapshot) {
          sourceText = snapshot.data!.first.code.toString();
          targetText = snapshot.data!.first.code.toString();

          for (var element in snapshot.data!) {
            sList.add(element.code);
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text('An error has occurred!'),
            );
          } else if (snapshot.hasData) {
            return LanguagesList(Languages: snapshot.data!);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

class LanguagesList extends StatefulWidget {
  const LanguagesList({Key? key, required this.Languages}) : super(key: key);

  final List<Language> Languages;

  @override
  State<LanguagesList> createState() => _LanguagesListState();
}

TextEditingController sourceController = TextEditingController();

class _LanguagesListState extends State<LanguagesList> {
  bool active = true;
  bool activeForDarkMode = false;

  void handleTap() {
    setState(() {
      active = false;
      
    });
  }

  void darkMode() {
    setState(() {
      activeForDarkMode = !activeForDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: activeForDarkMode ? Colors.black : Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(top: 40.0),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right:25.0),
                  child: TextButton(
                      onPressed: () {
                        darkMode();
                      },
                      child: Icon(
                        Icons.dark_mode,
                        color: activeForDarkMode ? Colors.white : Colors.black,
                      )),
                )
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height*0.05,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                DropdownButton<String>(
                  value: sourceText,
                  dropdownColor:
                      activeForDarkMode ? Colors.black : Colors.white,
                  icon: Icon(Icons.arrow_drop_down,
                      color: activeForDarkMode ? Colors.white : Colors.black),
                  iconSize: 24,
                  elevation: 16,
                  style: TextStyle(
                    color: activeForDarkMode ? Colors.white : Colors.black,
                  ),
                  underline: Container(
                    height: 2,
                    color: activeForDarkMode ? Colors.white : Colors.black,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      sourceText = newValue!;
                    });
                  },
                  items: sList.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                DropdownButton<String>(
                  dropdownColor:
                      activeForDarkMode ? Colors.black : Colors.white,
                  value: targetText,
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: activeForDarkMode ? Colors.white : Colors.black,
                  ),
                  iconSize: 24,
                  elevation: 16,
                  style: TextStyle(
                      color: activeForDarkMode ? Colors.white : Colors.black),
                  underline: Container(
                    height: 2,
                    color: activeForDarkMode ? Colors.white : Colors.black,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      targetText = newValue!;
                    });
                  },
                  items: sList.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height / 10),
            SizedBox(
              height: MediaQuery.of(context).size.height / 10,
              width: MediaQuery.of(context).size.width / 1.75,
              child: TextField(
                controller: sourceController,
                decoration: InputDecoration(
                    fillColor: Colors.white,
                    hintText: 'Metin girin',
                    filled: true,
                    contentPadding: EdgeInsets.all(30),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30))),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height / 10),
            Container(
                width: MediaQuery.of(context).size.width / 5,
                height: MediaQuery.of(context).size.height / 15,
                decoration: BoxDecoration(
                    color: activeForDarkMode ? Colors.white : Colors.black,
                    borderRadius: BorderRadius.circular(30)),
                child: TextButton(
                    onPressed: () {
                      handleTap();
                      postLanguages();
                    },
                    child: Text(
                      "Çevir",
                      style: TextStyle(
                          color:
                              activeForDarkMode ? Colors.black : Colors.white),
                    ))),
            SizedBox(height: MediaQuery.of(context).size.height / 9),
            Text(
              active
                  ? "Çeviri"
                  : "${translatedText.split(":").last.replaceAll('}', "").replaceAll('"', "")}",
              style: TextStyle(
                  color: activeForDarkMode ? Colors.white : Colors.black),
            )
          ]),
        ),
      ),
    );
  }
}
