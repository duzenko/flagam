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
            children: [
              Image.network(height: small ? 66 : 99, unit.image),
              Text(unit.name, softWrap: false),
            ],
          )),
    );
  }
}

class PlayerWithCardsView extends StatefulWidget {
  final BattlePlayer player;

  const PlayerWithCardsView({super.key, required this.player});

  @override
  State<PlayerWithCardsView> createState() => _PlayerWithCardsViewState();
}

class _PlayerWithCardsViewState extends State<PlayerWithCardsView> {
  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: widget.player == Battle.player
          ? TextDirection.rtl
          : TextDirection.ltr,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...widget.player.attackingUnits.map(
              (unit) => InkWell(
                onTap: widget.player == Battle.player
                    ? () => setState(() {
                          widget.player.attackingUnits.remove(unit);
                        })
                    : null,
                child: UnitCardView(unit),
              ),
            )
          ],
        ),
        Card(
          child: Container(
              padding: const EdgeInsets.all(9),
              width: 111,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.network(height: 111, widget.player.image),
                  Text(widget.player.name),
                ],
              )),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...widget.player.unitsInHand
                .where((u) => !widget.player.attackingUnits.contains(u))
                .map(
                  (unit) => InkWell(
                    onTap: widget.player == Battle.player
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

class BattleView extends StatelessWidget {
  const BattleView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            margin: const EdgeInsets.all(99),
            padding: const EdgeInsets.all(99),
            color: Colors.yellow,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                PlayerWithCardsView(player: Battle.player),
                PlayerWithCardsView(player: Battle.enemy),
              ],
            ),
          ),
        ),
        const BackButton(color: Colors.amber),
        Positioned(
            bottom: 0,
            child: ElevatedButton(
                onPressed: () => winClick(context),
                child: const Text('Win Quick'))),
        Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Text(
              'Player attacks',
              style: TextStyle(color: Colors.white, fontSize: 20),
              textAlign: TextAlign.center,
            )),
      ],
    );
  }

  void winClick(BuildContext context) {
    Navigator.of(context).pop(1);
  }
}
