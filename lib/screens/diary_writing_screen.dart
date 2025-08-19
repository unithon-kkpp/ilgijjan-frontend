import 'package:flutter/material.dart';
import 'weather_selection_screen.dart';

class DiaryWritingScreen extends StatefulWidget {
  final String userName; // 사용자 이름
  final String selectedCharacter; // 선택된 캐릭터 ID
  
  const DiaryWritingScreen({super.key, required this.userName, required this.selectedCharacter});

  @override
  State<DiaryWritingScreen> createState() => _DiaryWritingScreenState();
}

class _DiaryWritingScreenState extends State<DiaryWritingScreen> {
  final TextEditingController _diaryController = TextEditingController();

  @override
  void dispose() {
    _diaryController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_diaryController.text.trim().isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => WeatherSelectionScreen(
            imageUrl: null, // 텍스트 기반 일기이므로 이미지 URL은 null
            text: _diaryController.text.trim(), // 띄어쓰기 제거해서 들어가나?
            userName: widget.userName,
            selectedCharacter: widget.selectedCharacter,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('일기를 입력해주세요.'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () {
          // 키보드 외부 영역 터치 시 키보드 숨기기
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: SingleChildScrollView(
          child: Column(
            children: [
              // Progress Indicator
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 8,
                        decoration: BoxDecoration(
                          color: const Color(0xFF87CEEB),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Main Content Area
              Container(
                height: MediaQuery.of(context).size.height - 200, // 키보드 고려한 높이
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),

                    // Question Text
                    const Text(
                      '오늘 하루 어땠어?',
                      style: TextStyle(
                        fontFamily: 'Katuri',
                        fontSize: 27,
                        color: Colors.black87,
                      ),
                    ),
                    
                    const SizedBox(height: 10),
                    
                    // Diary Input Field
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE6F3FF), // Very light blue
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xFF87CEEB).withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: TextField(
                          controller: _diaryController,
                          maxLines: null,
                          expands: true,
                          textAlignVertical: TextAlignVertical.top,
                          textInputAction: TextInputAction.newline, // 줄바꿈 버튼으로 변경
                          decoration: const InputDecoration(
                            hintText: '여기에 일기를 입력해주세요.',
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(20),
                          ),
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                            height: 1.5,
                          ),
                          onChanged: (value) {
                            setState(() {
                              // 텍스트 변경 시 UI 업데이트
                            });
                          },
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Next Button - moved here to be right below the text area
                    Center(
                      child: SizedBox(
                        width: 170,
                        child: ElevatedButton(
                          onPressed: _diaryController.text.trim().isNotEmpty ? _nextStep : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _diaryController.text.trim().isNotEmpty 
                                ? const Color(0xFF91CCFF) 
                                : const Color(0xFFEEEEEE),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            '다음',
                            style: TextStyle(
                              fontFamily: 'Katuri',
                              fontSize: 24,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        ),
      ),
    );
  }
}
