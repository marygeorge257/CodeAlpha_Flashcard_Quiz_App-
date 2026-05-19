import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../quizCubit/quiz_dart_cubit.dart';
import '../quizModel/flashcard_model.dart';

class QuizHomePage extends StatelessWidget {
  const QuizHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAE6F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFEAE6F8),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Study Flow",
          style: TextStyle(
            color: Colors.deepPurple,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocBuilder<QuizDartCubit, QuizDartState>(
        builder: (context, state) {
          if (state is FlashcardEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "No Flashcards Yet\nPress + to add one",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton.icon(
                    onPressed: () {
                      _showAddDialog(context);
                    },
                    icon: const Icon(Icons.add),
                    label: const Text("Add Flashcard"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 15,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is FlashcardLoaded) {
            final card = state.flashcardList[state.currentIndex];

            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 30),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(color: Colors.black, blurRadius: 10),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          card.question,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),

                        if (state.isAnswerVisible)
                          Text(
                            card.answer,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),

                        const SizedBox(height: 20),

                        ElevatedButton.icon(
                          onPressed: () {
                            context.read<QuizDartCubit>().toggleAnswer();
                          },
                          icon: const Icon(Icons.remove_red_eye),
                          label: Text(
                            state.isAnswerVisible
                                ? "Hide Answer"
                                : "Show Answer",
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 50),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          context.read<QuizDartCubit>().previousFlashcard();
                        },
                        icon: const Icon(Icons.arrow_back),
                        label: const Text("Previous"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.deepPurple,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          context.read<QuizDartCubit>().nextFlashcard();
                        },
                        icon: const Icon(Icons.arrow_forward),
                        label: const Text("Next"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.deepPurple,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.add_circle,
                          color: Colors.deepPurple,
                          size: 30,
                        ),
                        onPressed: () {
                          _showAddDialog(context);
                        },
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.deepPurple,
                          size: 30,
                        ),
                        onPressed: () {
                          _showEditDialog(context, card, state.currentIndex);
                        },
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                          size: 30,
                        ),
                        onPressed: () {
                          context.read<QuizDartCubit>().deleteFlashcard(
                            state.currentIndex,
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    final questionController = TextEditingController();
    final answerController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Add Flashcard"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: questionController,
              decoration: const InputDecoration(labelText: "Question"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: answerController,
              decoration: const InputDecoration(labelText: "Answer"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (questionController.text.isNotEmpty &&
                  answerController.text.isNotEmpty) {
                context.read<QuizDartCubit>().addFlashcard(
                  FlashcardModel(
                    question: questionController.text,
                    answer: answerController.text,
                  ),
                );
              }
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, FlashcardModel card, int index) {
    final questionController = TextEditingController(text: card.question);
    final answerController = TextEditingController(text: card.answer);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Flashcard"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: questionController,
              decoration: const InputDecoration(labelText: "Question"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: answerController,
              decoration: const InputDecoration(labelText: "Answer"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<QuizDartCubit>().updateFlashcard(
                index,
                FlashcardModel(
                  question: questionController.text,
                  answer: answerController.text,
                ),
              );
              Navigator.pop(context);
            },
            child: const Text("Update"),
          ),
        ],
      ),
    );
  }
}
