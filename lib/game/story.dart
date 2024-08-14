class StoryChapter {
  final String text;
  final String image;

  StoryChapter(this.text, this.image);
}

abstract class Story {
  static final chapters = [
    StoryChapter(
      'The old emperor is dead and the civil war has already started. It\'s time for the old necromancer to once again roll the dice of fate!',
      'assets/story/Cole_Thomas_The_Course_of_Empire_Destruction_1836.jpg',
    ),
  ];
}
