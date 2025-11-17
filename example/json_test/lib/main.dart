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

  TestResponse? response;
  Data? testData;
  void _jsonParsingTest() async {
    final rootJson = await rootBundle.loadString('assets/json/test.json');
    response = TestResponse.fromJson(jsonDecode(rootJson));
    testData = response?.data;
    dev.log(jsonEncode(testData));
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
              Text("Email: ${testData?.email ?? 'N/A'}"),
              Text("Name: ${testData?.name ?? 'N/A'}"),
              Text("Age: ${testData?.age ?? 'N/A'}"),
              Text("Salary: ${testData?.salary ?? 'N/A'}"),
              Text("Is Active: ${testData?.isActive ?? 'N/A'}"),
              Text("Is Verified: ${testData?.isVerified ?? 'N/A'}"),
              Text("Profile Image URL: ${testData?.profileImageUrl ?? 'N/A'}"),
              Text("City: ${testData?.business?.address?.city ?? 'N/A'}"),
              ListView.builder(
                itemCount: testData?.tags?.length ?? 0,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => Text(
                  "Tag $index: ${testData?.tags?[index].toString() ?? 'N/A'}",
                ),
              ),

              ListView.builder(
                itemCount: testData?.permissions?.length ?? 0,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => Text(
                  "Permission $index: ${testData?.permissions?[index]?.toString() ?? 'N/A'}",
                ),
              ),
              ListView.builder(
                itemCount: testData?.qrCodes?.length ?? 0,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => Text(
                  "Permission $index: ${testData?.qrCodes?[index].toString() ?? 'N/A'}",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
