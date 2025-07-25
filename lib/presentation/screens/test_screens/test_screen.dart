import 'package:check_list_qa/domain/entities/project.dart';
import 'package:flutter/material.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key, required this.project});
  final Project project;

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.project.name),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.amber[200],
              border: Border.all(
                color: Colors.amber,
                width: 2.0
              )
            ),
            padding: const EdgeInsets.all(12.0),
            child: const Text(
                "Esta prueba es en general de todo el proyecto, sí estas de acuerdo en continuar, has click al botón de play"),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: Colors.green,
        onPressed: () {},
        child: Icon(
          Icons.play_arrow_rounded,
          color: Colors.green[200],
          size: 50,
        ),
      ),
    );
  }
}