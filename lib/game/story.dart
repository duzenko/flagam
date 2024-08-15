import 'package:flagam/generated/l10n.dart';

class StoryChapter {
  final String text;
  final String image;

  StoryChapter(this.text, this.image);
}

abstract class Story {
  static get chapters => [
        StoryChapter(
          S.current.chapter1,
          'assets/story/Cole_Thomas_The_Course_of_Empire_Destruction_1836.jpg',
        ),
      ];
}
