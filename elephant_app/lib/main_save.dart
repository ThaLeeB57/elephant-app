import 'package:flutter/material.dart';

List<String> question = [
  "What's your favorite color?",
  "What's your favorite animal?",
  "What's your favorite food?"
];

List<List<String>> response = [
  ["Red", "Blue", "Green"],
  ["Dog", "Cat", "Bird"],
  ["Pizza", "Hamburger", "Sushi"]
];

List<String> responseUser = [];

// void main() {
//   runApp(const MyApp());
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QUIZ APP',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int nbQuestion = 0;

  void setResponse(question, response) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Quiz App")),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.only(top: 20),
        child: Builder(
          builder: (context) {
            if (nbQuestion < question.length) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(question[nbQuestion]),
                  ...response[nbQuestion]
                      .map((e) => ElevatedButton(
                            onPressed: () {
                              responseUser.add(e);
                              setState(() {
                                nbQuestion++;
                              });
                            },
                            child: Text(e),
                          ))
                      .toList()
                ],
              );
            } else {
              return Column(
                children: [
                  Text("Your answers"),
                  ...Characters.empty.map((e) => Text(e)).toList(),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          nbQuestion = 0;
                          responseUser = [];
                        });
                      },
                      child: Text("Reset"),
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white))
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
