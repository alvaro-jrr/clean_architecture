import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:clean_architecture/injection_container.dart';
import 'package:clean_architecture/features/number_trivia/presentation/bloc/bloc.dart';
import 'package:clean_architecture/features/number_trivia/presentation/widgets/widgets.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Number Trivia'),
        backgroundColor: Colors.deepPurple.shade100,
      ),
      body: BlocProvider(
        create: (_) => sl<NumberTriviaBloc>(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: _Body(),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Top half
        _Content(),
        const SizedBox(height: 24),

        // Bottom half
        const TriviaControls(),
      ],
    );
  }
}

class _Content extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SizedBox(
      height: size.height * 0.3,
      child: BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
        builder: (context, state) {
          if (state is Loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is Error) {
            return MessageDisplay(message: state.message);
          }

          if (state is Loaded) {
            return TriviaDisplay(state.trivia);
          }

          return const MessageDisplay(
            message: 'There\'s no trivia yet. Search one!',
          );
        },
      ),
    );
  }
}
