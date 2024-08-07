import 'dart:async';

import 'package:flagam/game/battle.dart';
import 'package:flutter/material.dart';

class UnitCardView extends StatelessWidget {
  final UnitCard unit;
  final bool small;

  const UnitCardView(this.unit, {this.small = false, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
          width: small ? 66 : 99,
          padding: const EdgeInsets.all(9),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(height: small ? 66 : 99, unit.image),
              Text(unit.name, softWrap: false),
            ],
          )),
    );
  }
}

class PlayerWithCardsView extends StatefulWidget {
  final BattlePlayer player;
  final TextDirection textDirection;

  const PlayerWithCardsView({super.key, required this.player, required this.textDirection});

  @override
  State<PlayerWithCardsView> createState() => _PlayerWithCardsViewState();
}

class _PlayerWithCardsViewState extends State<PlayerWithCardsView> {
  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: widget.textDirection,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...widget.player.attackingUnits.map(
              (unit) => InkWell(
                onTap: widget.textDirection == TextDirection.rtl
                    ? () => setState(() {
                          widget.player.attackingUnits.remove(unit);
                        })
                    : null,
                child: Hero(tag: unit, child: UnitCardView(unit)),
              ),
            )
          ],
        ),
        Hero(
          tag: widget.player,
          child: PlayerCardView(player: widget.player),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...widget.player.unitsInHand.where((u) => !widget.player.attackingUnits.contains(u)).map(
                  (unit) => InkWell(
                    onTap: widget.textDirection == TextDirection.rtl
                        ? () => setState(() {
                              widget.player.attackingUnits.add(unit);
                            })
                        : null,
                    child: UnitCardView(unit, small: true),
                  ),
                )
          ],
        ),
      ],
    );
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
          builder: (context, constraints) => GestureDetector(
            onTap: () => onDoubleTap(context),
            behavior: HitTestBehavior.translucent,
            child: Container(
              margin: EdgeInsets.all(constraints.biggest.height * 0.1),
              padding: EdgeInsets.all(constraints.biggest.height * 0.1),
              color: Colors.green,
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  PlayerWithCardsView(player: battle.player, textDirection: TextDirection.rtl),
                  PlayerWithCardsView(player: battle.enemy, textDirection: TextDirection.ltr),
                ],
              ),
            ),
          ),
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
    for (final au in battle.attacker.attackingUnits) {
      Timer(const Duration(seconds: 1), Navigator.of(context).pop);
      await Navigator.of(context).push(
        PageRouteBuilder(
            opaque: false,
            barrierDismissible: true,
            pageBuilder: (BuildContext context, _, __) {
              return Material(
                color: Colors.transparent,
                child: Container(
                  color: Colors.red.withOpacity(0.3),
                  alignment: Alignment.center,
                  child: Row(
                    textDirection: battle.defender == battle.enemy ? TextDirection.ltr : TextDirection.rtl,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Hero(tag: au, child: UnitCardView(au)),
                      const Text('⚔', style: TextStyle(fontSize: 32)),
                      Hero(
                        tag: battle.defender,
                        child: PlayerCardView(player: battle.defender),
                      ),
                    ],
                  ),
                ),
              );
            }),
      );
      battle.defender.hp -= au.damage;
    }
    setState(() {
      battle.endRound();
    });
    if (battle.defender.hp <= 0) {
      Navigator.of(context).pop(battle);
    } else {}
  }
}
