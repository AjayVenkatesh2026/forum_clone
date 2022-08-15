import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:forum_clone/components/question_card.dart';
import 'package:uuid/uuid.dart';

import 'forum_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static String id = "home_screen";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  String question = "";
  final questionController = TextEditingController();
  List<QueryDocumentSnapshot<Map<String, dynamic>>> questionsList = [];
  late Future<QuerySnapshot<Map<String, dynamic>>> questionsFuture =
      _firestore.collection("questions").get();

  @override
  void initState() {
    super.initState();
  }

  void getUser() {
    final user = _auth.currentUser;
    if (user != null) {
      print("${HomeScreen.id}: $user.email");
    } else {
      print("${HomeScreen.id}: user not created!");
    }
  }

  void reload() {
    setState(() {
      questionsFuture = _firestore.collection("questions").get();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(
            onPressed: () {
              reload();
            },
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: () {
              _auth.signOut();
              Navigator.popAndPushNamed(context, LoginScreen.id);
            },
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: questionController,
                        minLines: 1,
                        maxLines: 8,
                        autofocus: true,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          labelText: "New Question",
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 12.0),
                        ),
                        onChanged: (String newValue) {
                          question = newValue;
                        },
                      ),
                      const SizedBox(
                        height: 24.0,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: ElevatedButton(
                          onPressed: () async {
                            try {
                              String id = const Uuid().v1();
                              await _firestore
                                  .collection("questions")
                                  .doc(id)
                                  .set({
                                "id": id,
                                "question": question,
                                "sender": _auth.currentUser?.email,
                                "answers": [],
                              });
                              print("${HomeScreen.id}: New document added!");
                              reload();
                            } catch (e) {
                              print(e);
                            } finally {
                              questionController.clear();
                              Navigator.pop(context);
                            }
                          },
                          child: const Text("Add new question"),
                        ),
                      ),
                    ],
                  ),
                );
              });
        },
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: questionsFuture,
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            List<Widget> children = [];
            if (snapshot.connectionState != ConnectionState.done) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: const [Center(child: CircularProgressIndicator())],
              );
            }
            if (snapshot.hasData) {
              final questions = snapshot.data?.docs;
              if (questions != null) {
                for (var question in questions) {
                  final questionWidget = QuestionItem(
                    question: question.data(),
                    onTapped: () async {
                      final resultData = await Navigator.pushNamed(
                          context, ForumScreen.id,
                          arguments: question.data());
                      if (resultData != null && resultData == true) {
                        reload();
                      }
                    },
                  );
                  children.add(questionWidget);
                }
                return ListView(
                  children: children,
                );
              }
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: const [Center(child: Text("Nothing to show."))],
            );
          },
        ),
      ),
    );
  }
}

class QuestionItem extends StatelessWidget {
  const QuestionItem({Key? key, required this.question, required this.onTapped})
      : super(key: key);

  final Map<String, dynamic> question;
  final Function onTapped;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTapped();
      },
      child: QuestionCard(question: question),
    );
  }
}
