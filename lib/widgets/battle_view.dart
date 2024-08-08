import 'dart:async';

import 'package:flagam/game/battle.dart';
import 'package:flutter/material.dart';

class UnitCardView extends StatelessWidget {
  final UnitCard unit;
  final bool small;
  final Animation<double>? animation;

  const UnitCardView(this.unit, {this.small = false, super.key, this.animation});

  @override
  Widget build(BuildContext context) {
    final card = Card(
      child: Container(
          padding: const EdgeInsets.all(9),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(height: small ? 66 : 99, unit.image),
              Text(unit.name, softWrap: false),
            ],
          )),
    );
    if (animation != null) {
      return SizeTransition(sizeFactor: animation!, child: card);
    }
    return card;
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
  final GlobalKey<AnimatedListState> _listKeyHand = GlobalKey<AnimatedListState>();
  final GlobalKey<AnimatedListState> _listKeyAttk = GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: widget.textDirection,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 99,
          child: AnimatedList(
            key: _listKeyAttk,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index, Animation<double> animation) {
              final unit = widget.player.attackingUnits[index];
              return InkWell(
                onTap: widget.textDirection == TextDirection.rtl
                    ? () {
                        _listKeyAttk.currentState!.removeItem(index,
                            (BuildContext context, Animation<double> animation) {
                          return UnitCardView(unit, animation: animation);
                        });
                        widget.player.attackingUnits.remove(unit);
                        _listKeyHand.currentState!.insertItem(0);
                      }
                    : null,
                child: Hero(tag: unit, child: UnitCardView(unit, animation: animation)),
              );
            },
          ),
        ),
        Hero(
          tag: widget.player,
          child: PlayerCardView(player: widget.player),
        ),
        SizedBox(
          width: 99,
          child: AnimatedList(
            key: _listKeyHand,
            shrinkWrap: true,
            initialItemCount: widget.player.unitsInHand.length,
            itemBuilder: (BuildContext context, int index, Animation<double> animation) {
              final unit = widget.player.unitsInHand[index];
              return InkWell(
                onTap: widget.textDirection == TextDirection.rtl
                    ? () {
                        _listKeyHand.currentState!.removeItem(index,
                            (BuildContext context, Animation<double> animation) {
                          return UnitCardView(unit, animation: animation);
                        });
                        widget.player.attackingUnits.add(unit);
                        _listKeyAttk.currentState!.insertItem(0);
                      }
                    : null,
                child: Hero(tag: unit, child: UnitCardView(unit, animation: animation)),
              );
            },
          ),
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
                mainAxisAlignment: MainAxisAlignment.spaceAround,
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
      Timer(const Duration(seconds: 1), () {
        if (context.mounted) Navigator.of(context).pop;
      });
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
      if (context.mounted) Navigator.of(context).pop(battle);
    } else {}
  }
}
