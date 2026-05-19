part of 'quiz_dart_cubit.dart';

@immutable
sealed class QuizDartState {}

final class QuizDartInitial extends QuizDartState {

}
final class FlashcardEmpty extends QuizDartState{

}
final class FlashcardLoaded extends QuizDartState{
  final List<FlashcardModel> flashcardList;
  final int currentIndex;
  final bool isAnswerVisible;
  FlashcardLoaded({required this.flashcardList,
    required this.currentIndex,
    required this.isAnswerVisible});
}
