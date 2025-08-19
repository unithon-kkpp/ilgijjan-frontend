import 'package:flutter/material.dart';
import 'home_screen.dart';

class CharacterSelectScreen extends StatefulWidget {
  final String userName; // WelcomeScreen에서 전달받은 사용자 이름
  
  const CharacterSelectScreen({super.key, required this.userName});

  @override
  State<CharacterSelectScreen> createState() => _CharacterSelectScreenState();
}

class _CharacterSelectScreenState extends State<CharacterSelectScreen> {
  String? _selectedCharacter;

  // 캐릭터 옵션들
  final List<Map<String, dynamic>> _characterOptions = [
    // {
    //   'id': 'raerae',
    //   'name': '최고의 작곡가 로우',
    //   'image': 'assets/raerae_select.png',
    //   'textColor': const Color(0xFF2E7D32),
    // },
    {
      'id': 'dodo',
      'name': '섬세한 뮤지션 하이',
      'image': 'assets/dodo_select.png',
      'textColor': const Color(0xFF1565C0),
    },
    {
      'id': 'raerae',
      'name': '최고의 작곡가 로우',
      'image': 'assets/raerae_select.png',
      'textColor': const Color(0xFF2E7D32),
    },
    {
      'id': 'meme',
      'name': '자유로운 영혼 퍼프',
      'image': 'assets/meme_select.png',
      'textColor': const Color(0xFF7B1FA2),
    },
  ];

  void _selectCharacter(String characterId) {
    setState(() {
      _selectedCharacter = characterId;
    });
  }

  double _getTopPosition(int index) {
    switch (index) {
      case 0: // raerae (첫 번째)
        return 90.0;
      case 1: // dodo (두 번째)
        return 20.0;
      case 2: // meme (세 번째)
        return 330.0;
      default:
        return index * 70.0;
    }
  }

  Map<String, double> _getNamePosition(int index) {
    switch (index) {
      case 0: // raerae (첫 번째)
        return {'dx': 110.0, 'dy': 130.0}; // 왼쪽으로 80px, 위로 20px
      case 1: // dodo (두 번째)
        return {'dx': 40.0, 'dy': 50.0}; // 왼쪽으로 70px, 위로 15px
      case 2: // meme (세 번째)
        return {'dx': 20.0, 'dy': 40.0}; // 왼쪽으로 75px, 위로 25px
      default:
        return {'dx': 0.0, 'dy': 0.0};
    }
  }

  void _nextStep() {
    if (_selectedCharacter != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            userName: widget.userName,
            selectedCharacter: _selectedCharacter!,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('캐릭터를 선택해주세요.'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF8), // 밝은 미색 배경
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),
            
            // 제목
            const Text(
              '너와 함께할\n친구를 골라줘!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Katuri',
                fontSize: 30,
                color: Color(0xFF424242),
                height: 1.3,
              ),
            ),
            
            const SizedBox(height: 10),
            
            // 캐릭터 선택 옵션들
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0), // 좌우 여백 증가
                child: Stack(
                  children: _characterOptions.asMap().entries.map((entry) {
                    final index = entry.key;
                    final character = entry.value;
                    final isSelected = _selectedCharacter == character['id'];
                    
                    return Positioned(
                      top: _getTopPosition(index), // 개별 위치 설정
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Opacity(
                          opacity: _selectedCharacter == null || isSelected ? 1.0 : 0.4,
                          child: Stack(
                            children: [
                              // 이미지
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.75, // 화면 너비의 75%로 제한
                                child: GestureDetector(
                                  onTap: () => _selectCharacter(character['id']),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.asset(
                                      character['image'],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                                                          // 이름 (이미지 위에 겹쳐서 표시)
                            Positioned(
                              left: _getNamePosition(index)['dx']!,
                              top: _getNamePosition(index)['dy']!,
                              child: GestureDetector(
                                onTap: () => _selectCharacter(character['id']),
                                child: Text(
                                  character['name'],
                                  style: TextStyle(
                                    fontFamily: 'Katuri',
                                    fontSize: 20,
                                    color: character['textColor'],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            
            const SizedBox(height: 40),
            
            // 다음 버튼
            Center(
              child: SizedBox(
                width: 140,
                child: ElevatedButton(
                  onPressed: _selectedCharacter != null ? _nextStep : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedCharacter != null 
                        ? const Color(0xFF91CCFF) 
                        : const Color(0xFFF3F3F3),
                    foregroundColor: _selectedCharacter != null 
                        ? Colors.white 
                        : const Color(0xFF9E9E9E),
                    padding: const EdgeInsets.symmetric(vertical: 7),
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
            
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
