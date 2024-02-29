import 'dart:io';

import 'package:asuka/asuka.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';



class InitPage extends StatefulWidget {
  const InitPage({super.key});

  @override
  State<InitPage> createState() => _InitPageState();
} 

class _InitPageState extends State<InitPage> {

  @override
  void initState() {
    _init();
    super.initState();
  }

  _init() {
    Modular.to.navigate('/tab/popular/');
  }

  @override
  Widget build(BuildContext context) {
    return const RouterOutlet();
  }
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key, required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: const Text("BiliNeo")),
      body: Center(
        child: SizedBox(
          height: 200,
          child: Flex(
            direction: Axis.vertical,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: size.width * 0.6,
                child: LinearProgressIndicator(
                  value: value,
                  backgroundColor: Colors.black12,
                  minHeight: 10,
                ),
              ),
              const Text("初始化中"),
            ],
          ),
        ),
      ),
    );
  }
}
