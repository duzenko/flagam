import 'dart:async';

import 'package:align_positioned/align_positioned.dart';
import 'package:collection/collection.dart';
import 'package:flagam/game/battle.dart';
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
      yield Expanded(child: Image.asset(unit.image, fit: BoxFit.fill));
      yield Text(
        unit.name,
        softWrap: false,
        style: TextStyle(
          background: Paint()
            ..color = Colors.deepPurple
            ..strokeWidth = 20
            ..strokeJoin = StrokeJoin.round
            ..strokeCap = StrokeCap.round
            ..style = PaintingStyle.stroke,
          color: Colors.white,
        ),
      );
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
              Text('${player.name} ${player.hp}'),
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
  final battle = Battle();

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
                        ...playerWidgets(battle.player),
                        ...playerWidgets(battle.enemy),
                        if (_attackingUnit != null) const Text('⚔', style: TextStyle(fontSize: 32)),
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
            bottom: 0,
            left: 0,
            right: 0,
            child: Text(
              battle.attacker == battle.player ? 'Player attacks' : 'Enemy attacks',
              style: const TextStyle(color: Colors.white, fontSize: 20),
              textAlign: TextAlign.center,
            )),
        Positioned(
            bottom: 0, child: ElevatedButton(onPressed: () => winClick(context), child: const Text('Win Quick'))),
      ],
    );
  }

  void winClick(BuildContext context) {
    Navigator.of(context).pop(1);
  }

  var _lastClick = DateTime.now();

  Future<void> onDoubleTap(BuildContext context) async {
    if (DateTime.now().difference(_lastClick).inMilliseconds > 300) {
      _lastClick = DateTime.now();
      return;
    }
    for (final unit in battle.attacker.activeUnits) {
      setState(() {
        _attackingUnit = unit;
        _lastAttacker = unit;
      });
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        if (!battle.isAttackerBlocked(unit)) battle.defender.hp -= unit.damage;
        _attackingUnit = null;
      });
      if (battle.defender.hp < -0) break;
      await Future.delayed(const Duration(seconds: 1));
    }
    setState(() {
      battle.endRound();
    });
    if (battle.defender.hp <= 0) {
      if (context.mounted) Navigator.of(context).pop(battle);
    } else {
      //
    }
  }

  final widgetKeys = <Object, Key>{};

  UnitCard? _attackingUnit, _lastAttacker;

  Iterable<Widget> playerWidgets(BattlePlayer player) sync* {
    widgetKeys[player] ??= Key(player.name);
    final isMe = battle.player == player;
    final cx = (isMe ? -1 : 1) * battleViewConstraints.maxWidth / 5;
    unitMapper(Iterable<UnitCard> list) {
      return list
          .sorted((a, b) => a == _lastAttacker
              ? 1
              : b == _lastAttacker
                  ? -1
                  : 0)
          .map((unit) {
        final index = list.toList().indexOf(unit);
        widgetKeys[unit] ??= Key(unit.hashCode.toString());
        final ucx = cx + ((isMe ^ (list == player.activeUnits)) ? -1 : 1) * battleViewConstraints.maxHeight / 6;
        bool isFighting = false;
        if (_attackingUnit != null) {
          isFighting = _attackingUnit == unit;
          if (!isFighting && unit.player == battle.defender) {
            final index = battle.attacker.activeUnits.indexOf(_attackingUnit!);
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
              onTap: player == battle.enemy
                  ? null
                  : () => setState(() {
                        if ((list == player.activeUnits)) {
                          player.activeUnits.remove(unit);
                        } else {
                          player.activeUnits.add(unit);
                          if (player == battle.defender &&
                              player.activeUnits.length > battle.attacker.activeUnits.length) {
                            Future.delayed(const Duration(milliseconds: 99)).then((_) => setState(() {
                                  player.activeUnits.remove(unit);
                                }));
                          }
                        }
                      }),
              child: UnitCardView(unit)),
        );
      });
    }

    yield* unitMapper(player.unitsInHand.where((unit) => !player.activeUnits.contains(unit)));
    bool isDefending = _attackingUnit != null && player == battle.defender;
    if (isDefending) {
      isDefending = !battle.isAttackerBlocked(_attackingUnit!);
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
}
