import 'package:hive/hive.dart';

part 'flashcard_model.g.dart';

@HiveType(typeId: 0)
class FlashcardModel extends HiveObject {

  @HiveField(0)
  String question;

  @HiveField(1)
  String answer;

  FlashcardModel({
    required this.question,
    required this.answer,
  });
}