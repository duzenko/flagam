import 'dart:async';

import 'package:flagam/game/battle.dart';
import 'package:flagam/game/province.dart';
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
    Timer.run(() => clickObject(context, widget.province.objects.last));
  }

  clickObject(BuildContext context, ProvinceObject provinceObject) {
    showBattleDialog(context, provinceObject);
    return;
    if (provinceObject.owner == World.player) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          content: Text('You own this ${provinceObject.mapName}'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Good'),
            ),
          ],
        ),
      );
      return;
    }
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        content: Text('Attack ${provinceObject.mapName}?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              showBattleDialog(context, provinceObject);
            },
            child: const Text('To Glory!'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Later'),
          ),
        ],
      ),
    );
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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${provinceObject.mapName} is now yours!'), /**/
      ));
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
}
