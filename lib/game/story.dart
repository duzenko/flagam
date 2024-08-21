import 'package:flagam/generated/l10n.dart';

class StoryChapter {
  final String text;
  final String image;
  bool _done = false;

  StoryChapter(this.text, this.image);
}

abstract class Story {
  static get prologue => StoryChapter(
        S.current.prologue,
        'assets/story/Cole_Thomas_The_Course_of_Empire_Destruction_1836.jpg',
      );

  static List<StoryChapter> chapters = [
    StoryChapter(
      S.current.chapter1,
      'assets/story/7b7e6cd7d5f3e26520a3ee34caff1b9ad66c9e0c_2000x2000.webp',
    ),
    StoryChapter(
      S.current.chapter2,
      'assets/story/2da6022a29616d8715f6b9c484cb9b1de0b4b412_2000x2000.webp',
    ),
    epilogue,
  ];

  static get epilogue => StoryChapter(
        S.current.epilogue,
        'assets/story/Slaves-to-Darkness.jpg',
      );

  static StoryChapter get current => chapters.firstWhere((s) => !s._done);

  static void progress() {
    current._done = true;
    switch (chapters.where((s) => s._done).length) {
      case 1:
    }
  }
}
