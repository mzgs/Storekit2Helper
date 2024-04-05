import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:storekit2helper/storekit2helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _storekit2Plugin = Storekit2Helper();

  @override
  void initState() {
    super.initState();
    testPlugin();
  }

  Future<void> testPlugin() async {
    // get products
    var products = await Storekit2Helper.fetchProducts(
        ["app_weekly", "app_yearly", "app_lifetime"]);

    for (var p in products) {
      print(p.productId +
          " - " +
          p.periodUnit +
          " " +
          p.periodValue.toString() +
          " " +
          p.type);
    }

    // check user has active subscription
    var hasActiveSubscription = await Storekit2Helper.hasActiveSubscription();

    // Buy product by product id
    Storekit2Helper.buyProduct("app_weekly",
        (success, transaction, errorMessage) {
      print(success);
      print(errorMessage);
      print(transaction);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running on: '),
        ),
      ),
    );
  }
}
