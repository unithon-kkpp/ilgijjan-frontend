import 'package:flutter/material.dart';
import 'loading_screen.dart';

class MoodSelectionScreen extends StatefulWidget {
  final String? imageUrl; // 이전 화면에서 업로드된 이미지 URL
  final String? text; // 텍스트 기반 일기 내용
  final String? weather; // 이전 화면에서 선택된 날씨
  final String userName; // 사용자 이름
  final String selectedCharacter; // 선택된 캐릭터 ID
  
  const MoodSelectionScreen({super.key, this.imageUrl, this.text, this.weather, required this.userName, required this.selectedCharacter});

  @override
  State<MoodSelectionScreen> createState() => _MoodSelectionScreenState();
}

class _MoodSelectionScreenState extends State<MoodSelectionScreen> {
  String? _selectedMood;

  // 기분 옵션들 (9개)
  final List<Map<String, dynamic>> _moodOptions = [
    {'id': 'happy'},
    {'id': 'excited'},
    {'id': 'sad'},
    {'id': 'angry'},
    {'id': 'calm'},
    {'id': 'tired'},
    {'id': 'anxious'},
    {'id': 'grateful'},
    {'id': 'inspired'},
  ];

  void _selectMood(String moodId) {
    setState(() {
      _selectedMood = moodId;
    });
  }

  void _nextStep() {
    if (_selectedMood != null) {
      // Create diary data
      final diaryData = _createDiaryData();
      
      // Navigate to loading screen with all data
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoadingScreen(
            diaryData: diaryData,
            userName: widget.userName,
            selectedCharacter: widget.selectedCharacter,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('기분을 선택해주세요.'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  Map<String, dynamic> _createDiaryData() {
    // Convert mood ID to mood number (1-9)
    final moodNumber = _getMoodNumber(_selectedMood!);
    
    // Create diary data according to the specified JSON format
    final diaryData = {
      "photoUrl": widget.imageUrl, // 이미지 URL (null일 수 있음)
      "text": widget.text, // 텍스트 기반 일기 내용 (null일 수 있음)
      "weather": widget.weather, // 날씨 정보
      "mood": moodNumber, // 기분 번호 (1-9)
    };
    
    return diaryData;
  }

  int _getMoodNumber(String moodId) {
    // 기분 ID를 번호로 매핑 (1-9)
    final moodMapping = {
      'happy': 1,
      'excited': 2,
      'sad': 3,
      'angry': 4,
      'calm': 5,
      'tired': 6,
      'anxious': 7,
      'grateful': 8,
      'inspired': 9,
    };
    
    return moodMapping[moodId] ?? 1; // 기본값 1
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
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
                        color: const Color(0xFF87CEEB),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Main Content Area
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),
                    
                    // Question
                    const Text(
                      '기분이 어때?',
                      style: TextStyle(
                        fontFamily: 'Katuri',
                        fontSize: 27,
                        color: Colors.black87,
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // 3x3 Grid - 9 Emotions
                    Container(
                      height: 360,
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                          childAspectRatio: 1.0,
                        ),
                        itemCount: 9,
                        itemBuilder: (context, index) {
                          final mood = _moodOptions[index];
                          final isSelected = _selectedMood == mood['id'];
                          
                          return GestureDetector(
                            onTap: () => _selectMood(mood['id']),
                            child: Container(
                              child: Center(
                                child: Opacity(
                                  opacity: _selectedMood == null || isSelected ? 1.0 : 0.4,
                                  child: Image.asset(
                                    'assets/emotion${index + 1}.png',
                                    width: 70,
                                    height: 70,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Next Button - moved here to be right below the mood selection grid
                    Center(
                      child: SizedBox(
                        width: 170,
                        child: ElevatedButton(
                          onPressed: _selectedMood != null ? _nextStep : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _selectedMood != null 
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
            ),
          ],
        ),
      ),
    );
  }
}
