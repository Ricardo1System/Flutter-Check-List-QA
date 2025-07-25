

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProjectTestScreen extends ConsumerStatefulWidget {
  const ProjectTestScreen({super.key});

  @override
  ConsumerState<ProjectTestScreen> createState() => _ProjectTestScreenState();
}

class _ProjectTestScreenState extends ConsumerState<ProjectTestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
    );
  }
}