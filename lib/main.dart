import 'package:clean_architecture/features/number_trivia/presentation/pages/number_trivia_page.dart';
import 'package:flutter/material.dart';

import 'package:clean_architecture/injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Number Trivia',
      home: const NumberTriviaPage(),
      theme: ThemeData.light(useMaterial3: true).copyWith(),
    );
  }
}
