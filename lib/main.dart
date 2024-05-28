import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pedometer_app/screen/analysis_screen.dart';
import 'package:pedometer_app/screen/pedometer_screen.dart';
import 'package:pedometer_app/screen/user_screen.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var _currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "만보기",
      home: Scaffold(
        body: _currentIndex == 0 ? AnalysisScreen() : _currentIndex == 1 ? PedometerPage() : _currentIndex == 2 ? UserScreen() : Placeholder(), // PedometerPage 또는 UserScreen 또는 다른 홈 화면 위젯으로 변경하세요.
        bottomNavigationBar: Container(
          height: 80, // 바텀 바의 높이를 조정합니다.
          child: SalomonBottomBar(
            currentIndex: _currentIndex,
            onTap: (i) => setState(() => _currentIndex = i),
            items: [
              /// Likes
              _buildSalomonBottomBarItem(
                icon: const Icon(Icons.analytics),
                title: const Text("기록", style: TextStyle(fontSize: 15)),
                selectedColor: Colors.green,
              ),
              /// Home
              _buildSalomonBottomBarItem(
                icon: const Icon(Icons.home),
                title: const Text("만보기", style: TextStyle(fontSize: 15)),
                selectedColor: Colors.red,
              ),
              /// Search
              _buildSalomonBottomBarItem(
                icon: const Icon(Icons.person_outline),
                title: const Text("내 정보", style: TextStyle(fontSize: 15)),
                selectedColor: Colors.orange,
              ),
            ],
          ),
        ),
      ),
    );
  }

  SalomonBottomBarItem _buildSalomonBottomBarItem({
    required Icon icon,
    required Text title,
    required Color selectedColor,
  }) {
    return SalomonBottomBarItem(
      icon: SizedBox(
        width: 60, // 아이콘의 가로 크기를 조절합니다.
        height: 60, // 아이콘의 세로 크기를 조절합니다.
        child: icon,
      ),
      title: title,
      selectedColor: selectedColor,
    );
  }
}
