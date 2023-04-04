import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:clean_architecture/features/number_trivia/presentation/bloc/bloc.dart';

class TriviaControls extends StatefulWidget {
  const TriviaControls({super.key});

  @override
  State<TriviaControls> createState() => TriviaControlsState();
}

class TriviaControlsState extends State<TriviaControls> {
  final controller = TextEditingController();
  String inputStr = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: controller,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            label: Text('Trivia Number'),
            hintText: 'eg: 7',
          ),
          keyboardType: TextInputType.number,
          onChanged: (value) => inputStr = value,
          onSubmitted: (_) => addConcrete(),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: FilledButton(
                onPressed: addConcrete,
                child: const Text('Search'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: FilledButton.tonal(
                onPressed: addRandom,
                child: const Text('Get Random'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void addConcrete() {
    // Clear number field
    controller.clear();

    BlocProvider.of<NumberTriviaBloc>(context, listen: false)
        .add(GetTriviaForConcreteNumber(inputStr));
  }

  void addRandom() {
    // Clear number field
    controller.clear();

    BlocProvider.of<NumberTriviaBloc>(context, listen: false)
        .add(GetTriviaForRandomNumber());
  }
}
