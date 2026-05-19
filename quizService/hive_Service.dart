import 'package:flutter/material.dart';
import 'package:flashcard_quiz_app/quizModel/flashcard_model.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveService{
  static const String boxName="flashcards_box";
  static Future <void>init() async{
    await Hive.initFlutter();
    Hive.registerAdapter(FlashcardModelAdapter());
    await Hive.openBox<FlashcardModel>(boxName);
  }
  static Box<FlashcardModel> getBox(){
    return Hive.box<FlashcardModel>(boxName);
  }
  static List<FlashcardModel>getFlashcards(){
    final box=getBox();
    return box.values.toList();
  }
  static Future<void> addFlashcard(FlashcardModel card) async{
    final box=getBox();
    box.add(card);
  }
  static Future <void> deleteFlashcard(int index)async{
    final box = getBox();
    box.deleteAt(index);
  }
  static Future <void> updateFlashcard(int index, FlashcardModel updatedcard){
    final box=getBox();
    return box.put(index, updatedcard);
  }
}