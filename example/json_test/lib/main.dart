import 'dart:convert';
import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:json_test/model/test_response.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JSON Test',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
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
  void initState() {
    super.initState();
    _jsonParsingTest();
  }

  TestResponse testResponse = TestResponse();
  void _jsonParsingTest() async {
    final rootJson = await rootBundle.loadString('assets/json/test.json');
    testResponse = TestResponse.fromJson(jsonDecode(rootJson));
    dev.log(testResponse.toString());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('JSON Test'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Email: ${testResponse.email}"),
              Text("Name: ${testResponse.name}"),
              Text("Age: ${testResponse.age}"),
              Text("Salary: ${testResponse.salary}"),
              Text("Is Active: ${testResponse.isActive}"),
              Text("Is Verified: ${testResponse.isVerified}"),
              Text("Profile Image URL: ${testResponse.profileImageUrl}"),
              Text("City: ${testResponse.business?.address?.city}"),
              ListView.builder(
                itemCount: testResponse.tags?.length ?? 0,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) =>
                    Text("Tag $index: ${testResponse.tags?[index].toString()}"),
              ),

              ListView.builder(
                itemCount: testResponse.permissions?.length ?? 0,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => Text(
                  "Permission $index: ${testResponse.permissions?[index]?.toString()}",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
