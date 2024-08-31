import 'dart:async';

import 'package:align_positioned/align_positioned.dart';
import 'package:flagam/game/battle.dart';
import 'package:flagam/game/province.dart';
import 'package:flagam/game/story.dart';
import 'package:flagam/widgets/battle_view.dart';
import 'package:flutter/material.dart';

class ProvinceView extends StatefulWidget {
  final Province province;

  const ProvinceView({super.key, required this.province});

  @override
  State<ProvinceView> createState() => _ProvinceViewState();
}

class _ProvinceViewState extends State<ProvinceView> {
  @override
  initState() {
    super.initState();
    Timer.run(() => showStoryPopup().then((_) => tapQuestBtn()));
    // Timer.run(() => clickObject(context, widget.province.objects.last));
  }

  clickObject(BuildContext context, ProvinceObject provinceObject) {
    // showBattleDialog(context, provinceObject);
    if (provinceObject.owner != World.player) {
      showBattleDialog(context, provinceObject);
      // showDialog(
      //   context: context,
      //   builder: (ctx) => AlertDialog(
      //     content: Text('You own this ${provinceObject.mapName}'),
      //     actions: [
      //       TextButton(
      //         onPressed: () => Navigator.of(context).pop(),
      //         child: const Text('Good'),
      //       ),
      //     ],
      //   ),
      // );
      return;
    }
    showDialog(
        context: context,
        builder: (ctx) => Dialog(
              backgroundColor: Colors.transparent,
              child: SizedBox(
                height: 333,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Image.asset(provinceObject.popupImage),
                    Positioned(
                      left: 0,
                      right: 0,
                      child: Card(
                        color: Colors.black12,
                        child: Padding(
                          padding: const EdgeInsets.all(9),
                          child: Text(
                            provinceObject.popupText,
                            softWrap: true,
                            style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // child: StoryChapterView(),
            ));
    // showDialog(
    //   context: context,
    //   builder: (ctx) => AlertDialog(
    //     content: Text('Attack ${provinceObject.mapName}?'),
    //     actions: [
    //       TextButton(
    //         onPressed: () {
    //           Navigator.of(context).pop();
    //           showBattleDialog(context, provinceObject);
    //         },
    //         child: const Text('To Glory!'),
    //       ),
    //       TextButton(
    //         onPressed: () => Navigator.of(context).pop(),
    //         child: const Text('Later'),
    //       ),
    //     ],
    //   ),
    // );
  }

  Future<void> showBattleDialog(BuildContext context, ProvinceObject provinceObject) async {
    Battle? battle = await showDialog(
        context: context,
        builder: (ctx) => Dialog(
              backgroundColor: Colors.transparent,
              child: BattleView(provinceObject),
            ));
    if (battle != null && battle.enemy.hp <= 0) {
      setState(() {
        provinceObject.owner = World.player;
        World.player.army = [Skeleton(), Zombie(), Skeleton()];
      });
      Story.progress();
      if (context.mounted) {
        showDialog(
            context: context,
            builder: (ctx) => Dialog(
                  backgroundColor: Colors.transparent,
                  child: StoryChapterView(Story.current),
                ));
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //   content: Text('${provinceObject.mapName} is now yours!'), /**/
        // ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(),
        Container(
          width: 512,
          height: 512,
          color: Colors.green,
          child: Stack(
            alignment: Alignment.center,
            children: widget.province.objects
                .map(
                  (ProvinceObject provinceObject) => AlignPositioned(
                    alignment: Alignment.center,
                    dx: provinceObject.x.toDouble() - 256,
                    dy: provinceObject.y.toDouble() - 256,
                    child: FilledButton(
                      onPressed: () => clickObject(context, provinceObject),
                      style: FilledButton.styleFrom(
                          backgroundColor: provinceObject.owner?.color ?? Colors.grey,
                          padding: EdgeInsets.all(provinceObject.size / 3)),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.ac_unit_rounded,
                            size: provinceObject.size / 3,
                          ),
                          Text(
                            provinceObject.mapName,
                            softWrap: false,
                            style: TextStyle(fontSize: provinceObject.size / 5),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        IconButton(
          onPressed: tapQuestBtn,
          color: Colors.yellow,
          tooltip: 'Quest Info',
          icon: const Icon(Icons.assignment_late_outlined),
          padding: const EdgeInsets.all(33),
        ),
      ],
    );
  }

  showStoryPopup() {
    return showDialog(
        context: context,
        builder: (ctx) => Dialog(
              backgroundColor: Colors.transparent,
              child: StoryChapterView(Story.prologue),
            ));
  }

  void tapQuestBtn() {
    showDialog(
        context: context,
        builder: (ctx) => Dialog(
              backgroundColor: Colors.transparent,
              child: StoryChapterView(Story.current),
              // child: StoryChapterView(),
            ));
  }
}

class StoryChapterView extends StatelessWidget {
  final StoryChapter chapter;

  const StoryChapterView(this.chapter, {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: Navigator.of(context).pop,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(33),
        child: SizedBox(
          width: 666,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Image.asset(chapter.image),
              Card(
                margin: const EdgeInsets.all(16),
                color: Colors.black12,
                child: Padding(
                  padding: const EdgeInsets.all(9),
                  child: Text(
                    chapter.text,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
