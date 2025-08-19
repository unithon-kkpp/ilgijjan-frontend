import 'package:flutter/material.dart';
import 'character_select_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_nameController.text.trim().isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => CharacterSelectScreen(
            userName: _nameController.text.trim(),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('이름을 입력해주세요.'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // 화면 아무 곳이나 터치하면 키보드 닫기
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.translucent,
      child: Scaffold(
        backgroundColor: const Color(0xFFFFFDF8), // 배경색 (이미지 배경색 느낌)
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 40),
              const Spacer(flex: 2),
              const Text(
                '만나서 반가워,\n너의 이름은 뭐야?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Katuri',
                  fontSize: 26,
                  color: Color(0xFF424242),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 110),
                child: TextField(
                  controller: _nameController,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Katuri',
                    fontSize: 26,
                    color: Colors.black87,
                    height: 1.2,
                  ),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 20),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          const BorderSide(color: Color.fromARGB(255, 242, 242, 242), width: 0.5), // 얇은 회색 테두리
                    ),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: SizedBox(
                  width: 140,
                  child: ElevatedButton(
                    onPressed: _nameController.text.trim().isNotEmpty ? _nextStep : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _nameController.text.trim().isNotEmpty 
                          ? const Color(0xFF91CCFF) 
                          : const Color(0xFFEEEEEE),
                      foregroundColor: Colors.white,
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
              const Spacer(flex: 3),
            ],
          ),
        ),
      )
    );
  }
}
