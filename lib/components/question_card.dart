import 'package:flutter/material.dart';

class QuestionCard extends StatelessWidget {
  const QuestionCard({
    Key? key,
    required this.question,
  }) : super(key: key);

  final Map<String, dynamic> question;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(width: 1.0, color: Colors.grey),
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        ),
        child: Material(
          elevation: 2.0,
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  question["sender"],
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
                  question["question"],
                  textAlign: TextAlign.left,
                  maxLines: 3,
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
