import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(SmileApp());
}

// 앱 전체 테마
// 버튼 스타일을 여기 한 곳에 모아둠 → 화면마다 styleFrom 반복 안 해도 됨
class SmileApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final seedColor = const Color(0xFF6C63FF);

    return MaterialApp(
      title: 'Smile',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: seedColor),
        scaffoldBackgroundColor: const Color(0xFFF6F5FF),
        appBarTheme: AppBarTheme(
          backgroundColor: seedColor,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: seedColor,
            padding: const EdgeInsets.symmetric(vertical: 18),
            textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            elevation: 2,
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      home: FirstPage(),
    );
  }
}

// 첫 화면 (스플래시)
// 이미지 12장을 프레임처럼 넘겨서 애니메이션 효과, 끝나면 SecondPage로 이동
class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  int _currentFrame = 0;
  late Timer _timer;

  final List<String> imageFrames = List.generate(
    12,
        (index) => 'assets/images/${index + 1}.smile.png',
  );

  @override
  void initState() {
    super.initState();

    // precacheImage로 이미지 미리 로드 → 프레임 넘어갈 때 깜빡임 방지
    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (var path in imageFrames) {
        precacheImage(AssetImage(path), context);
      }
    });

    // 200ms 간격으로 프레임 전환 시작
    _timer = Timer.periodic(Duration(milliseconds: 200), (timer) {
      setState(() {
        if (_currentFrame < imageFrames.length - 1) {
          _currentFrame++;
        } else {
          _timer.cancel(); // 1~12 다 돌고 멈춤
          // 마지막 프레임 도달 → 1초 대기 후 SecondPage로 이동
          Timer(Duration(seconds: 1), () {
            _goToSecondPage();
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _goToSecondPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SecondPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 원래 배경 이미지(clouds_trees.png)가 pubspec에 등록 안 돼서 실행 시 에러 위험 있었음
          // 같은 색 톤의 그라데이션으로 교체. 실제 이미지 파일 있으면 다시 이미지로 교체 가능
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFC9C0FF), Color(0xFFEFE8FF)],
              ),
            ),
          ),

          // 프레임 애니메이션 이미지 (스마일 캐릭터)
          Positioned(
            top: 340,
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset(
                imageFrames[_currentFrame],
                width: 150,
              ),
            ),
          ),

          // 타이틀 이미지, 프레임 이미지 위쪽에 배치
          Positioned(
            top: 280,
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset(
                'assets/images/smile_transparent.png',
                width: 150,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 학년(연령대) 선택 페이지
// 선택 후 Etiquette Tips / Life Tips 버튼이 아래에 나타남
class SecondPage extends StatefulWidget {
  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  int? selectedStage; // 선택한 Stage (초기값: 없음)

  final List<String> buttonLabels = [
    "Kindergarten (5-6 years)",
    "1st Grade (6-7 years)",
    "2nd Grade (7-8 years)",
    "3rd Grade (8-9 years)",
    "4th Grade (9-10 years)",
    "5th-6th Grade (10-12 years)",
  ];

  // 학년별 아이콘. 텍스트만 있던 버튼에 시각적 구분 추가
  final List<IconData> stageIcons = [
    Icons.child_care,
    Icons.looks_one,
    Icons.looks_two,
    Icons.looks_3,
    Icons.looks_4,
    Icons.school,
  ];

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      body: Column(
        children: [
          // 상단 타이틀 바
          Container(
            color: primary,
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 50, 16, 20),
            child: const Center(
              child: Text(
                "Choose Your Age Group",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          // 학년 버튼 목록, 선택된 버튼은 색 반전으로 표시
          Expanded(
            child: Container(
              color: const Color(0xFFEFE8FF),
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 12),
                itemCount: buttonLabels.length,
                itemBuilder: (context, index) {
                  final selected = selectedStage == index + 1;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ElevatedButton.icon(
                      icon: Icon(stageIcons[index]),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selected ? primary : Colors.white,
                        foregroundColor: selected ? Colors.white : primary,
                        padding: const EdgeInsets.symmetric(vertical: 22),
                        textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        elevation: selected ? 4 : 1,
                      ),
                      onPressed: () {
                        setState(() {
                          selectedStage = index + 1;
                        });
                      },
                      label: Text(buttonLabels[index]),
                    ),
                  );
                },
              ),
            ),
          ),

          // 학년 선택 전엔 안 보이다가, 선택하면 아래 두 버튼 노출
          if (selectedStage != null)
            Container(
              color: const Color(0xFFEFE8FF),
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
              child: Column(
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.handshake),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EtiquettePage(stage: selectedStage!),
                        ),
                      );
                    },
                    label: const Text("Etiquette Tips"),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.lightbulb),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LifeTipsPage(stage: selectedStage!),
                        ),
                      );
                    },
                    label: const Text("Life Tips"),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// 예절 팁 페이지
// 학년별 딕셔너리에서 stage에 맞는 목록만 꺼내서 카드로 나열
class EtiquettePage extends StatelessWidget {
  final int stage;

  EtiquettePage({required this.stage});

  final Map<int, List<String>> etiquetteTips = {
    1: ["Say 'Please' and 'Thank You'", "Wait your turn", "Share toys", "Greet with eye contact", "Use 'Excuse me' politely"],
    2: ["Lower voice in public", "Comfort friends", "Knock before entering", "Chew with mouth closed", "Respect personal space"],
    3: ["Say 'Thank you' when helped", "Don't interrupt", "Apologize sincerely", "Take turns talking", "Respect others' belongings"],
    4: ["Listen when spoken to", "Don't make fun of mistakes", "Public behavior matters", "Respect different opinions", "Offer help when needed"],
    5: ["Show appreciation", "Discuss calmly", "Put phone away during meals", "Respect personal boundaries", "Handle conflicts maturely"],
    6: ["Apologize first when needed", "Recognize when to help", "Use polite language", "Respect personal & shared spaces", "Offer support in tough times"],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Etiquette Tips")),
      backgroundColor: const Color(0xFFF6F5FF),
      body: etiquetteTips.containsKey(stage)
          ? ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: etiquetteTips[stage]?.length ?? 0,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: ListTile(
              leading: const Icon(Icons.handshake, color: Color(0xFF6C63FF)),
              title: Text(
                etiquetteTips[stage]![index],
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          );
        },
      )
          : const Center(
        child: Text(
          "No tips available for this stage.",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

// 생활 팁 페이지
// 구조는 예절 팁 페이지와 동일, 내용만 다름
class LifeTipsPage extends StatelessWidget {
  final int stage;

  LifeTipsPage({required this.stage});

  final Map<int, List<String>> lifeTips = {
    1: ["Packing your backpack", "Tidy up toys", "Wash hands properly", "Brush teeth correctly", "Drink enough water"],
    2: ["Getting dressed properly", "Learn to tie shoes", "Plan snack times", "Keep books organized", "Write your name neatly"],
    3: ["Make a simple sandwich", "Stretch before exercise", "Learn to dust and clean surfaces", "Keep homework space tidy", "Follow a reading schedule"],
    4: ["Help with small chores", "Wash dishes properly", "Fold clothes neatly", "Learn basic budgeting", "Exercise for fun"],
    5: ["Prepare breakfast alone", "Sort laundry", "Manage weekly spending", "Deep clean your room", "Plan study sessions"],
    6: ["Cook basic meals", "Understand how to budget", "Help family with tasks", "Keep track of school tasks", "Practice social responsibility"],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Life Tips")),
      backgroundColor: const Color(0xFFF6F5FF),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: lifeTips[stage]?.length ?? 0,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: ListTile(
              leading: const Icon(Icons.lightbulb, color: Color(0xFF6C63FF)),
              title: Text(
                lifeTips[stage]![index],
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          );
        },
      ),
    );
  }
}
