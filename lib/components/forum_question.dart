import 'package:flutter/material.dart';

class ForumQuestion extends StatelessWidget {
  const ForumQuestion({Key? key, this.questionText, this.email, this.onPress})
      : super(key: key);

  final String? questionText, email;
  final Function? onPress;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(
                left: 16.0, top: 16.0, right: 16.0, bottom: 0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  email!,
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
                  questionText!,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                  ),
                ),
                TextButton(
                  style: ButtonStyle(
                    padding:
                        MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero),
                  ),
                  onPressed: () {
                    onPress!();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Text("Answer"),
                      Icon(Icons.reply),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            height: 2.0,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}
