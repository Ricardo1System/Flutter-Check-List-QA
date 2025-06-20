

import 'package:flutter/material.dart';

class DoubleForm extends StatelessWidget {
  const DoubleForm(
      {super.key,
      required this.fistLabel,
      required this.firstController,
      required this.secondLabel,
      required this.secondController,
      required this.buttonLabel,
      required this.onTap});

  final String fistLabel;
  final TextEditingController firstController;
  final String secondLabel;
  final TextEditingController secondController;
  final String buttonLabel;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    TextField(
                      controller: firstController,
                      decoration: InputDecoration(labelText: fistLabel),
                    ),
                    TextField(
                      controller: secondController,
                      decoration: InputDecoration(labelText: secondLabel),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () => onTap(),
                      child: Text(buttonLabel),
                    ),
                  ],
                ),
              ),
      ],
    );
  }
}