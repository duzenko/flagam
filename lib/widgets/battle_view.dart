import 'dart:async';

import 'package:align_positioned/align_positioned.dart';
import 'package:collection/collection.dart';
import 'package:flagam/game/battle.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

late BoxConstraints battleViewConstraints;

class UnitCardView extends StatelessWidget {
  final UnitCard unit;
  final bool small;
  final Animation<double>? animation;

  const UnitCardView(this.unit, {this.small = false, super.key, this.animation});

  @override
  Widget build(BuildContext context) {
    Iterable<Widget> columnContent() sync* {
      yield Expanded(child: Image.asset(unit.image));
      if (unit.player.activeUnits.contains(unit)) {
        yield Badge(
          label: Text(
              '${unit.player.battle.attacker == unit.player ? '⚔' : '⛨'}${unit.player.activeUnits.indexOf(unit) + 1}'),
          child: Container(),
        );
      }
    }

    final card = Card(
      child: Container(
          width: battleViewConstraints.maxHeight / 7,
          height: battleViewConstraints.maxHeight / 5 - 9,
          padding: const EdgeInsets.all(9),
          child: Column(
            children: columnContent().toList(),
          )),
    );
    return card;
  }
}

class PlayerCardView extends StatelessWidget {
  const PlayerCardView({
    super.key,
    required this.player,
  });

  final BattlePlayer player;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
          padding: const EdgeInsets.all(9),
          width: 111,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.network(height: 111, player.image),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(player.name),
                  Text('♥${player.hp}'),
                ],
              ),
            ],
          )),
    );
  }
}

class BattleView extends StatefulWidget {
  const BattleView({
    super.key,
  });

  @override
  State<BattleView> createState() => _BattleViewState();
}

class _BattleViewState extends State<BattleView> {
  late final battle = Battle(() => setState(() {}));

  @override
  void dispose() {
    battle.onChangeNotifier = () {};
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            return GestureDetector(
              onTap: () => onDoubleTap(context),
              behavior: HitTestBehavior.translucent,
              child: Container(
                margin: EdgeInsets.all(constraints.biggest.height * 0.1),
                color: Colors.green,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    battleViewConstraints = constraints;
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned.fill(child: Image.asset('assets/arena/Woodshed_I.webp', fit: BoxFit.cover)),
                        ...playerWidgets(battle.player),
                        ...playerWidgets(battle.enemy),
                        if (battle.stage?.attackingUnit != null) const Text('⚔', style: TextStyle(fontSize: 32)),
                        if (_infoUnit != null) UnitInfoView(_infoUnit!),
                      ],
                    );
                  },
                ),
              ),
            );
          },
        ),
        const BackButton(color: Colors.amber),
        Positioned(
            bottom: 5,
            left: 9,
            right: 9,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (kDebugMode) ElevatedButton(onPressed: () => winClick(context), child: const Text('Win Quick')),
                Text(
                  battle.attacker == battle.player ? 'Player attacks' : 'Enemy attacks',
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              ],
            )),
      ],
    );
  }

  void winClick(BuildContext context) {
    battle.enemy.hp = 0;
    Navigator.of(context).pop(battle);
  }

  var _lastClick = DateTime.now();
  bool inputDisabled = false;
  UnitCard? _infoUnit;

  Future<void> onDoubleTap(BuildContext context) async {
    if (inputDisabled || DateTime.now().difference(_lastClick).inMilliseconds > 300) {
      _lastClick = DateTime.now();
      return;
    }
    inputDisabled = true;
    await battle.playTurn();
    inputDisabled = false;
    if (battle.defender.hp <= 0) {
      if (context.mounted) Navigator.of(context).pop(battle);
    } else {
      //
    }
  }

  final widgetKeys = <Object, Key>{};

  Iterable<Widget> playerWidgets(BattlePlayer player) sync* {
    widgetKeys[player] ??= Key(player.name);
    final isMe = battle.player == player;
    final cx = (isMe ? -1 : 1) * battleViewConstraints.maxWidth / 5;
    unitMapper(Iterable<UnitCard> list) {
      var list2 = list;
      if (battle.stage != null) {
        list2 = list.sorted((a, b) => a == battle.stage!.lastAttacker
            ? 1
            : b == battle.stage!.lastAttacker
                ? -1
                : 0);
      }
      return list2.map((unit) {
        final index = list.toList().indexOf(unit);
        widgetKeys[unit] ??= Key(unit.hashCode.toString());
        final ucx = cx + ((isMe ^ (list == player.activeUnits)) ? -1 : 1) * battleViewConstraints.maxHeight / 6;
        bool isFighting = false;
        if (battle.stage?.attackingUnit != null) {
          isFighting = battle.stage!.attackingUnit == unit;
          if (!isFighting && unit.player == battle.defender) {
            final index = battle.attacker.activeUnits.indexOf(battle.stage!.attackingUnit!);
            if (player.activeUnits.length > index) isFighting = player.activeUnits[index] == unit;
          }
        }
        return AnimatedAlignPositioned(
          key: widgetKeys[unit],
          dx: isFighting ? 0 : ucx,
          dy: isFighting ? 0 : (index - list.length / 2 + 0.5) * battleViewConstraints.maxHeight / 5,
          alignment: Alignment.center,
          moveByChildWidth: isFighting ? (isMe ? -1 : 1) * 0.7 : 0,
          duration: const Duration(milliseconds: 444),
          child: InkWell(
            onTap: player == battle.enemy ? null : () => battle.toggleUnitActive(unit),
            onSecondaryTapDown: (_) => showUnitInfo(unit),
            onSecondaryTapUp: (_) => showUnitInfo(),
            onSecondaryTapCancel: () => showUnitInfo(),
            child: UnitCardView(unit),
          ),
        );
      });
    }

    yield* unitMapper(player.unitsInHand.where((unit) => !player.activeUnits.contains(unit)));
    bool isDefending = battle.stage?.attackingUnit != null && player == battle.defender;
    if (isDefending) {
      isDefending = !battle.isAttackerBlocked(battle.stage!.attackingUnit!);
    }
    yield AnimatedAlignPositioned(
      key: widgetKeys[player],
      alignment: Alignment.center,
      dx: isDefending ? 0 : cx,
      moveByChildWidth: isDefending ? (isMe ? -1 : 1) * 0.7 : 0,
      // moveByChildWidth: -0.5,
      child: PlayerCardView(player: player),
    );
    yield* unitMapper(player.activeUnits);
  }

  showUnitInfo([UnitCard? unit]) {
    setState(() {
      _infoUnit = unit;
    });
  }
}

class UnitInfoView extends StatelessWidget {
  final UnitCard unit;

  const UnitInfoView(this.unit, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(9),
        child: IntrinsicWidth(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(unit.image, width: 222),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 9),
                child: Text(
                  unit.name,
                  softWrap: false,
                  style: Theme.of(context).textTheme.headlineLarge,
                  // style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                ),
              ),
              Row(
                // mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    '⚔ ${unit.attack}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    '⛨ ${unit.defence}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
