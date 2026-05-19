import 'package:bloc/bloc.dart';
import 'package:flashcard_quiz_app/quizModel/flashcard_model.dart';
import 'package:flashcard_quiz_app/quizService/hive_Service.dart';
import 'package:meta/meta.dart';

part 'quiz_dart_state.dart';

class QuizDartCubit extends Cubit<QuizDartState> {
  QuizDartCubit() : super(QuizDartInitial());
  void getFlashcards() {
    final data = HiveService.getFlashcards();

    if (data.isEmpty) {
      emit(FlashcardEmpty());
    } else {
      emit(
        FlashcardLoaded(
          flashcardList: data,
          currentIndex: 0,
          isAnswerVisible: false,
        ),
      );
    }
  }
  Future<void> addFlashcard(FlashcardModel card) async {
    await HiveService.addFlashcard(card);
    getFlashcards();
  }

  Future<void> deleteFlashcard(int index) async {
    await HiveService.deleteFlashcard(index);

    final data = HiveService.getFlashcards();

    if (data.isEmpty) {
      emit(FlashcardEmpty());
    } else {
      int newIndex = index;
      if (newIndex >= data.length) {
        newIndex = data.length - 1;
      }

      emit(
        FlashcardLoaded(
          flashcardList: data,
          currentIndex: newIndex,
          isAnswerVisible: false,
        ),
      );
    }
  }

  Future<void> updateFlashcard(
      int index, FlashcardModel updatedCard) async {
    await HiveService.updateFlashcard(index, updatedCard);

    final data = HiveService.getFlashcards();

    emit(
      FlashcardLoaded(
        flashcardList: data,
        currentIndex: index,
        isAnswerVisible: false,
      ),
    );
  }
  void nextFlashcard() {
    if (state is FlashcardLoaded) {
      final currentState = state as FlashcardLoaded;

      if (currentState.currentIndex <
          currentState.flashcardList.length - 1) {
        emit(
          FlashcardLoaded(
            flashcardList: currentState.flashcardList,
            currentIndex: currentState.currentIndex + 1,
            isAnswerVisible: false,
          ),
        );
      }
    }
  }

  void previousFlashcard() {
    if (state is FlashcardLoaded) {
      final currentState = state as FlashcardLoaded;

      if (currentState.currentIndex > 0) {
        emit(
          FlashcardLoaded(
            flashcardList: currentState.flashcardList,
            currentIndex: currentState.currentIndex - 1,
            isAnswerVisible: false,
          ),
        );
      }
    }
  }

  void toggleAnswer() {
    if (state is FlashcardLoaded) {
      final currentState = state as FlashcardLoaded;

      emit(
        FlashcardLoaded(
          flashcardList: currentState.flashcardList,
          currentIndex: currentState.currentIndex,
          isAnswerVisible: !currentState.isAnswerVisible,
        ),
      );
    }
  }
}