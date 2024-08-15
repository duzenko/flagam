import 'package:flagam/game/province.dart';
import 'package:flagam/generated/l10n.dart';
import 'package:flagam/widgets/province_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Game',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const MyHomePage(),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      locale: kDebugMode ? const Locale('ru') : null,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final province = World.provinces.first;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        // color: Colors.red,
        alignment: Alignment.center,
        child: ProvinceView(province: province),
      ),
    );
  }
}
