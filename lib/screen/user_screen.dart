import 'dart:ui';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:just_bottom_sheet/drag_zone_position.dart';
import 'package:just_bottom_sheet/just_bottom_sheet.dart';
import 'package:bottom_sheet_scroll_wrapper/bottom_sheet_scroll_wrapper.dart';
import 'package:just_bottom_sheet/just_bottom_sheet_configuration.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  FirebaseDatabase _realtime = FirebaseDatabase.instance;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _genderController = TextEditingController();
  TextEditingController _heightController = TextEditingController();
  TextEditingController _weightController = TextEditingController();
  final scrollController = ScrollController();

  String? _selectedGoal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("사용자 페이지"),
      ),
      body: Column(
        children: [
          GestureDetector(
            onTap: () {
              _showUserSettingsDialog(context);
            },
            child: Container(
              margin: const EdgeInsets.all(10),
              width: double.infinity,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Text(
                  "사용자 설정",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              _showGoalSettingDialog(context);
            },
            child: Container(
              margin: const EdgeInsets.all(10),
              width: double.infinity,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Text(
                  "목표 설정",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              _showJustBottomSheet(context);
            },
            child: Container(
              margin: const EdgeInsets.all(10),
              width: double.infinity,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                  child: Icon(
                Icons.add,
                color: Colors.white,
                size: 40,
              )),
            ),
          ),
        ],
      ),
    );
  }

  void _showUserSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("사용자 설정"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: "이름"),
                ),
                TextField(
                  controller: _ageController,
                  decoration: const InputDecoration(labelText: "나이"),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(3),
                  ],
                ),
                DropdownButtonFormField<String?>(
                  decoration: const InputDecoration(
                    labelText: '성별',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelStyle:
                        TextStyle(fontSize: 15, color: Color(0xffcfcfcf)),
                  ),
                  onChanged: (String? newValue) {
                    print(newValue);
                  },
                  items: [null, 'M', 'F']
                      .map<DropdownMenuItem<String?>>((String? i) {
                    return DropdownMenuItem<String?>(
                      value: i,
                      child: Text({'M': '남성', 'F': '여성'}[i] ?? '비공개'),
                    );
                  }).toList(),
                ),
                TextField(
                  controller: _heightController,
                  decoration: const InputDecoration(labelText: "키"),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(3),
                  ],
                ),
                TextField(
                  controller: _weightController,
                  decoration: const InputDecoration(labelText: "몸무게"),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(3),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("저장"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("닫기"),
            ),
          ],
        );
      },
    );
  }

  void _showGoalSettingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("목표 설정"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: const InputDecoration(labelText: "목표"),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  onChanged: (value) async {
                    DateTime now = DateTime.now();
                    String date = DateFormat("yyyyMMdd").format(now);
                    await _realtime
                        .ref()
                        .child("steps")
                        .child(date)
                        .child("memberGoal")
                        .set({
                      "goal": int.parse(value),
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("저장"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("닫기"),
            ),
          ],
        );
      },
    );
  }

  void _showJustBottomSheet(BuildContext context) {
    showJustBottomSheet(
      context: context,
      dragZoneConfiguration: JustBottomSheetDragZoneConfiguration(
        dragZonePosition: DragZonePosition.outside,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Container(
            height: 4,
            width: 50,
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.grey[300]
                : Colors.white,
          ),
        ),
      ),
      configuration: JustBottomSheetPageConfiguration(
        height: MediaQuery.of(context).size.height,
        builder: (context) {
          var item = ["칼로리", "단일 최고기록", "일주일 최고기록"];
          return ListView.separated(
            padding: EdgeInsets.zero,
            controller: scrollController,
            itemBuilder: (context, index) {
              return Material(
                color: Colors.transparent,
                child: ListTile(
                  title: Text(
                    item[index],
                    style: const TextStyle(fontSize: 20),
                  ),
                  onTap: () {
                    // 여기에 클릭 시 수행할 작업 추가
                    print('Clicked on item $index: ${item[index]}');
                  },
                ),
              );
            },
            itemCount: item.length,
            separatorBuilder: (BuildContext context, int index) {
              return const Divider(thickness: 1);
            },
          );
        },
        scrollController: scrollController,
        closeOnScroll: true,
        cornerRadius: 16,
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: UserScreen(),
  ));
}
