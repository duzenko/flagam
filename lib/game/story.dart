import 'package:flagam/generated/l10n.dart';

class StoryChapter {
  final String text;
  final String image;

  StoryChapter(this.text, this.image);
}

abstract class Story {
  static get prologue => StoryChapter(
        S.current.prologue,
        'assets/story/Cole_Thomas_The_Course_of_Empire_Destruction_1836.jpg',
      );

  static get chapters => [
        StoryChapter(
          S.current.chapter1,
          'assets/story/7b7e6cd7d5f3e26520a3ee34caff1b9ad66c9e0c_2000x2000.webp',
        ),
      ];

  static get epilogue => StoryChapter(
        S.current.epilogue,
        'assets/story/Slaves-to-Darkness.jpg',
      );
}
