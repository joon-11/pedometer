import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  Widget build(BuildContext context) {
    FirebaseDatabase _realtime = FirebaseDatabase.instance;
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('내 정보'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '내 페이지 컨텐츠',
                style: TextStyle(fontSize: 24),
              ),
              ElevatedButton(
                onPressed: () async {
                  await _realtime.ref().child("test").set({
                    "testId": 123,
                  });
                },
                child: Text('내 페이지 버튼'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
