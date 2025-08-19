import 'package:flutter/material.dart';
import 'mood_selection_screen.dart';

class WeatherSelectionScreen extends StatefulWidget {
  final String? imageUrl; // 이전 화면에서 업로드된 이미지 URL
  final String? text; // 텍스트 기반 일기 내용
  final String userName; // 사용자 이름
  final String selectedCharacter; // 선택된 캐릭터 ID
  
  const WeatherSelectionScreen({super.key, this.imageUrl, this.text, required this.userName, required this.selectedCharacter});

  @override
  State<WeatherSelectionScreen> createState() => _WeatherSelectionScreenState();
}

class _WeatherSelectionScreenState extends State<WeatherSelectionScreen> {
  String? _selectedWeather;

  // 날씨 옵션들
  final List<Map<String, dynamic>> _weatherOptions = [
    {'id': 'SUNNY'},
    {'id': 'CLOUDY'},
    {'id': 'RAIN'},
    {'id': 'SNOW'},
  ];

  void _selectWeather(String weatherId) {
    setState(() {
      _selectedWeather = weatherId;
    });
  }

  String _getWeatherImage(String weatherId) {
    switch (weatherId) {
      case 'SUNNY':
        return 'assets/sunny.png';
      case 'CLOUDY':
        return 'assets/cloudy.png';
      case 'RAIN':
        return 'assets/rainy.png';
      case 'SNOW':
        return 'assets/snowy.png';
      default:
        return 'assets/sunny.png';
    }
  }

  Color _getWeatherBackgroundColor(String weatherId) {
    switch (weatherId) {
      case 'SUNNY':
        return const Color(0x44C1FF91); // 밝은 노란색 (맑음)
      case 'CLOUDY':
        return const Color(0xFFF8F1DB); // 밝은 하늘색 (흐림)
      case 'RAIN':
        return const Color(0xFFE8E8E8); // 밝은 회색 (비)
      case 'SNOW':
        return const Color(0xFFD6EDFA); // 밝은 흰색 (눈)
      default:
        return const Color(0xFFFFF8DC);
    }
  }

  void _nextStep() {
    if (_selectedWeather != null) {
      // Navigate to mood selection screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MoodSelectionScreen(
            imageUrl: widget.imageUrl,
            text: widget.text,
            weather: _selectedWeather,
            userName: widget.userName,
            selectedCharacter: widget.selectedCharacter,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('날씨를 선택해주세요.'),
          backgroundColor: Colors.orange,
        ),
      );
    }
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
                        color: Colors.grey.shade300,
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
                      '오늘 날씨는 어땠어?',
                      style: TextStyle(
                        fontFamily: 'Katuri',
                        fontSize: 27,
                        color: Colors.black87,
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Weather Options Grid
                    Container(
                      height: 400,
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                          childAspectRatio: 1.0,
                        ),
                        itemCount: _weatherOptions.length,
                        itemBuilder: (context, index) {
                          final weather = _weatherOptions[index];
                          final isSelected = _selectedWeather == weather['id'];
                          
                          return GestureDetector(
                            onTap: () => _selectWeather(weather['id']),
                            child: Container(
                              decoration: BoxDecoration(
                                color: _getWeatherBackgroundColor(weather['id']),
                                borderRadius: BorderRadius.circular(16),
                                border: isSelected
                                    ? Border.all(
                                        color: const Color(0xFF87CEEB),
                                        width: 3,
                                      )
                                    : null,
                              ),
                              child: Center(
                                child: Image.asset(
                                  _getWeatherImage(weather['id']),
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                                        
                    // Next Button - moved here to be right below the weather selection grid
                    Center(
                      child: SizedBox(
                        width: 170,
                        child: ElevatedButton(
                          onPressed: _selectedWeather != null ? _nextStep : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _selectedWeather != null 
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
