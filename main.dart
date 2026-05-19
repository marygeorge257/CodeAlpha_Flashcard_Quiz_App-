import 'package:flashcard_quiz_app/quizCubit/quiz_dart_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'quizViews/homePage.dart';
import 'quizService/hive_Service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return    BlocProvider(
        create: (_) => QuizDartCubit()..getFlashcards(),
        child:MaterialApp(
          debugShowCheckedModeBanner: false,
          home: QuizHomePage(),
        )
    );
  }
}