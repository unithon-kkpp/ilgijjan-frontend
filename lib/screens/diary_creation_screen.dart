import 'package:flutter/material.dart';
import 'photo_capture_screen.dart';
import 'diary_writing_screen.dart';

class DiaryCreationScreen extends StatefulWidget {
  final String userName; // 사용자 이름
  final String selectedCharacter; // 선택된 캐릭터 ID
  
  const DiaryCreationScreen({super.key, required this.userName, required this.selectedCharacter});

  @override
  State<DiaryCreationScreen> createState() => _DiaryCreationScreenState();
}

class _DiaryCreationScreenState extends State<DiaryCreationScreen> {
  // 선택된 캐릭터에 따른 이미지 반환
  String _getCharacterImage() {
    switch (widget.selectedCharacter) {
      case 'dodo':
        return 'assets/dodo.png';
      case 'raerae':
        return 'assets/raerae.png';
      case 'meme':
        return 'assets/meme.png';
      default:
        return 'assets/dodo.png'; // 기본값
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background_knoll.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top section with character and speech bubble
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(0),
                  child: Stack(
                    children: [
                      // Character (Treble Clef) - positioned absolutely
                      Positioned(
                        left: 10,
                        bottom: 10,
                        child: Image.asset(
                          _getCharacterImage(),
                          width: 170,
                          height: 170,
                          fit: BoxFit.contain,
                        ),
                      ),
                                  
                      // Speech Bubble - positioned absolutely
                      Positioned(
                        right: 20,
                        bottom: 100,
                        child: Stack(
                          children: [
                            // Background speech bubble image
                            Image.asset(
                              'assets/speech_bubble.png',
                              width: 230,
                              height: 115,
                              fit: BoxFit.contain,
                            ),
                            // Text overlay
                            Positioned(
                              right: 55,
                              bottom: 45,
                              child: const Text(
                                '오늘의 일기,\n어떻게 시작할까?',
                                style: TextStyle(
                                  fontFamily: 'Katuri',
                                  fontSize: 18,
                                  color: Colors.black87,
                                  height: 1.2,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Bottom section with action buttons
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // const SizedBox(height: 20),
                      
                      // Take Photo Button
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PhotoCaptureScreen(
                                userName: widget.userName,
                                selectedCharacter: widget.selectedCharacter,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          margin: const EdgeInsets.only(bottom: 25),
                          decoration: BoxDecoration(
                            color: const Color(0xFFA9ECFD), // Light blue
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF71BDFF),
                                spreadRadius: 0,
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              // Magnifier image
                              Container(
                                width: 60,
                                height: 60,
                                child: ClipRRect(
                                  child: Image.asset(
                                    'assets/magnifier.png',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                                                            
                              // Text content
                              Expanded(
                                child: Column(
                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      '사진 찍기',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Katuri',
                                        fontSize: 35,
                                      ),
                                    ),
                                    const Text(
                                      '일기를 카메라로 찍어보자!',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 17,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      // Write New Button
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DiaryWritingScreen(
                                userName: widget.userName,
                                selectedCharacter: widget.selectedCharacter,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFFBD8), // Light yellow
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFD5B486),
                                spreadRadius: 0,
                                blurRadius: 12,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              // Pencil image
                              Container(
                                width: 60,
                                height: 60,
                                child: ClipRRect(
                                  child: Image.asset(
                                    'assets/pencil.png',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                                                            
                              // Text content
                              Expanded(
                                child: Column(
                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      '새로 쓰기',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Katuri',
                                        fontSize: 35,
                                      ),
                                    ),
                                    const Text(
                                      '함께 새로운 일기를 쓰자!',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 17,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


