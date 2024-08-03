import 'package:flagam/province.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
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
      body: Center(
        child: Container(
          width: 512,
          height: 512,
          color: Colors.green,
          child: Stack(
            children: province.objects
                .map(
                  (ProvinceObject provinceObject) => Positioned(
                    left: provinceObject.x.toDouble(),
                    top: provinceObject.y.toDouble(),
                    // width: provinceObject.size,
                    // height: provinceObject.size,
                    child: FilledButton(
                      onPressed: () {},
                      style: FilledButton.styleFrom(
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
        ),
      ),
    );
  }
}
