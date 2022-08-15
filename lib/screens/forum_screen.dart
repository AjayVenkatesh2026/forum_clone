import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:forum_clone/components/forum_question.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class ForumScreen extends StatefulWidget {
  const ForumScreen({Key? key}) : super(key: key);
  static String id = "forum_screen";

  @override
  State<ForumScreen> createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {
  String answer = "";
  final answerController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  Map<String, dynamic> args = {};
  bool isReloading = false;
  bool hasReloaded = false;

  void showBottomSheet() {
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
                  controller: answerController,
                  minLines: 1,
                  maxLines: 8,
                  autofocus: true,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    labelText: "Answer",
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  ),
                  onChanged: (String newValue) {
                    answer = newValue;
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
                        String? email = _auth.currentUser?.email;
                        final docRef =
                            _firestore.collection("questions").doc(args["id"]);
                        await docRef.update({
                          "answers": FieldValue.arrayUnion([
                            {
                              "answer": answer,
                              "email": email,
                            }
                          ])
                        });
                        print("${ForumScreen.id}: answer posted");
                      } catch (e) {
                        print(e);
                      } finally {
                        Navigator.pop(context);
                        reload();
                      }
                    },
                    child: const Text("Post Answer"),
                  ),
                ),
              ],
            ),
          );
        });
  }

  void reload() async {
    setState(() {
      isReloading = true;
    });
    final newArgs =
        await _firestore.collection("questions").doc(args["id"]).get();
    setState(() {
      isReloading = false;
      hasReloaded = true;
    });
    setState(() {
      args = newArgs.data() as Map<String, dynamic>;
    });
    print(args["answers"]);
  }

  List<Widget> answerWidgets() {
    List<Widget> widgets = [];

    for (var answer in args["answers"]) {
      final answerWidget = Material(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 16.0, top: 16.0, right: 0.0, bottom: 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    answer["email"],
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontSize: 12.0,
                      color: Colors.lightBlueAccent,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    answer["answer"],
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  const Divider(
                    height: 2.0,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
      ;
      widgets.add(answerWidget);
    }

    return widgets;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Forum"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context, hasReloaded),
        ),
      ),
      body: SafeArea(
        child: ModalProgressHUD(
          inAsyncCall: isReloading,
          child: LayoutBuilder(
            builder:
                (BuildContext context, BoxConstraints viewportConstraints) {
              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: viewportConstraints.maxHeight,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ForumQuestion(
                        questionText: args["question"],
                        email: args["sender"],
                        onPress: showBottomSheet,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0, top: 8.0),
                        child: Text(
                          "${args["answers"].length} Answers",
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                              fontSize: 24.0, color: Colors.lightBlueAccent),
                        ),
                      ),
                      Column(
                        children: [
                          ...answerWidgets(),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
