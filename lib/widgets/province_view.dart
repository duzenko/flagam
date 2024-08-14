import 'dart:async';

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
    Timer.run(() => showStoryPopup());
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
                    Image.asset('assets/arena/52246834659_2628252ee8_b.jpg'),
                    Positioned(
                      left: 0,
                      right: 0,
                      child: Card(
                        color: Colors.black12,
                        child: Padding(
                          padding: const EdgeInsets.all(9),
                          child: Text(
                            'This is the ruins where you\'ve been hiding from the world',
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
    Battle? battle = await Navigator.of(context).push(PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        pageBuilder: (BuildContext context, _, __) {
          return const Material(
            color: Colors.transparent,
            child: BattleView(),
          );
        }));
    if (battle != null && battle.enemy.hp <= 0) {
      setState(() {
        provinceObject.owner = World.player;
      });
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${provinceObject.mapName} is now yours!'), /**/
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 512,
      height: 512,
      color: Colors.green,
      child: Stack(
        children: widget.province.objects
            .map(
              (ProvinceObject provinceObject) => Positioned(
                left: provinceObject.x.toDouble(),
                top: provinceObject.y.toDouble(),
                child: FilledButton(
                  onPressed: () => clickObject(context, provinceObject),
                  style: FilledButton.styleFrom(
                      backgroundColor: provinceObject.owner?.color ?? Colors.grey,
                      padding: EdgeInsets.all(provinceObject.size / 3)),
                  child: Column(
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
    );
  }

  showStoryPopup() {
    showDialog(
        context: context,
        builder: (ctx) => const Dialog(
              backgroundColor: Colors.transparent,
              child: StoryChapterView(),
              // child: StoryChapterView(),
            ));
  }
}

class StoryChapterView extends StatelessWidget {
  const StoryChapterView({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: Navigator.of(context).pop,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(33),
        // clipBehavior: Clip.antiAlias,
        child: SizedBox(
          // padding: EdgeInsets.all(9),
          width: 666,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Image.asset(Story.chapters.first.image),
              Card(
                color: Colors.black12,
                child: Padding(
                  padding: const EdgeInsets.all(9),
                  child: Text(
                    Story.chapters.first.text,
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
