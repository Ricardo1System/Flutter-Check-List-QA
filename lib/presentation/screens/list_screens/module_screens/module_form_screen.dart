import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dataProvider = Provider<String>((ref) => 'Hola desde Riverpod');

class ModuleFormScreen extends ConsumerStatefulWidget {
  const ModuleFormScreen({super.key});

  @override
  ConsumerState<ModuleFormScreen> createState() => _PageNamePageState();
}

class _PageNamePageState extends ConsumerState<ModuleFormScreen> {
  @override
  void initState() {
    super.initState();
    // Puedes acceder a ref aquí también si lo necesitas
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(dataProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('PageName'),
      ),
      body: Center(
        child: Text(data),
      ),
    );
  }
}