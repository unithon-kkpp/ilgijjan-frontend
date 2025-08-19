import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'diary_completion_screen.dart';

class LoadingScreen extends StatefulWidget {
  final Map<String, dynamic> diaryData; // 다이어리 데이터
  final String userName; // 사용자 이름
  final String selectedCharacter; // 선택된 캐릭터 ID
  
  const LoadingScreen({
    super.key, 
    required this.diaryData,
    required this.userName,
    required this.selectedCharacter,
  });

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _bounceAnimation;
  String _currentSpeechText = ''; // 현재 표시되는 말풍선 텍스트

  @override
  void initState() {
    super.initState();
    
    // 바운스 애니메이션 설정
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _bounceAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    // 애니메이션 시작
    _animationController.repeat(reverse: true);
    
    // 초기 말풍선 텍스트 설정
    _currentSpeechText = _getSpeechBubbleText();
    
    // 즉시 POST 요청 실행
    _executePostRequest();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

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

  // POST 요청 실행
  Future<void> _executePostRequest() async {
    try {
      // Send diary data to server
      final response = await _postDiary(widget.diaryData);
      
      if (response != null && response.containsKey('diaryId')) {
        // Success - navigate to diary completion screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DiaryCompletionScreen(
              diaryId: response['diaryId'],
              showConfetti: true, // 로딩 완료 후 컨페티 표시
            ),
          ),
        );
      } else {
        throw Exception('Invalid response format: missing diaryId');
      }
        } catch (e) {
      // Error handling - show error message and navigate back
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('일기 저장 실패: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
      
      // 에러 발생 시 이전 화면으로 돌아가기
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          Navigator.pop(context);
        }
      });
    }
  }

    // 말풍선 텍스트 반환
  String _getSpeechBubbleText() {
    final weather = widget.diaryData['weather'];
    final mood = widget.diaryData['mood'];
    
    // weather와 mood 중 임의로 하나 선택
    final randomChoice = DateTime.now().millisecond % 2; // 0: weather, 1: mood
    
    // weather에 따른 기본 멘트
    if (weather != null && (randomChoice == 0 || mood == null)) {
      switch (weather) {
        case 'SUNNY':
          final sunnyMessages = [
            '오늘은 햇님이 웃네!',
            '오늘은 산책하기 딱이야!',
          ];
          return sunnyMessages[DateTime.now().millisecond % 2];
        case 'CLOUDY':
          final cloudyMessages = [
            '하늘이 살짝 졸려 보여',
            '햇님이 쉬는 날인가 봐',
          ];
          return cloudyMessages[DateTime.now().millisecond % 2];
        case 'RAIN':
          final rainMessages = [
            '빗소리에 귀 기울여 봐',
            '바닥이 반짝반짝해졌어',
          ];
          return rainMessages[DateTime.now().millisecond % 2];
        case 'SNOW':
          final snowMessages = [
            '세상이 하얗게 변했어!',
            '같이 눈사람 만들래?',
          ];
          return snowMessages[DateTime.now().millisecond % 2];
        default:
          break;
      }
    }
    
    // mood에 따른 기본 멘트
    if (mood != null && (randomChoice == 1 || weather == null)) {
      switch (mood) {
        case 1:
          final happyMessages = [
            '오늘은 행복 만땅이다!',
            '야호~ 너무 신난다!',
          ];
          return happyMessages[DateTime.now().millisecond % 2];
        case 2:
          final happyMessages = [
            '나도 깜짝 놀랐어!',
            '정말? 눈이 동그래졌어!',
          ];
          return happyMessages[DateTime.now().millisecond % 2];
        case 3:
          final happyMessages = [
            '내가 달래줄게, 토닥토닥',
            '울고 싶을 땐 울어도 돼',
          ];
          return happyMessages[DateTime.now().millisecond % 2];
        case 4:
          final sadMessages = [
            '맛있는 하루였겠다!',
            '입안이 행복해졌겠다~',
          ];
          return sadMessages[DateTime.now().millisecond % 2];
        case 5:
          final happyMessages = [
            '후.. 잠깐 숨 고르자!',
            '내가 옆에서 응원해줄게!',
          ];
          return happyMessages[DateTime.now().millisecond % 2];
        case 6:
          final calmMessages = [
            '눈에서 하트가 뿅뿅',
            '사랑이 가득한 하루네~',
          ];
          return calmMessages[DateTime.now().millisecond % 2];
        case 7:
          final happyMessages = [
            '너 진짜 짱이다!',
            '오늘 너 정말 멋져!',
          ];
          return happyMessages[DateTime.now().millisecond % 2];
        case 8:
          final happyMessages = [
            '히히 웃음이 절로 나와',
            '나도 덩달아 웃게 돼',
          ];
          return happyMessages[DateTime.now().millisecond % 2];
        case 9:
          final inspiredMessages = [
            '괜찮아, 그럴 수 있지!',
            '민망해하지 않아도 돼!',
          ];
          return inspiredMessages[DateTime.now().millisecond % 2];
        default:
          break;
      }
    }
    
    // 기본 멘트
    return '야호~ 너무 신난다!\n같이 놀아볼까?';
  }

  // POST 요청 처리
  Future<Map<String, dynamic>?> _postDiary(Map<String, dynamic> diaryData) async {
    try {
      // Send POST request to server
      final response = await http.post(
        Uri.parse('https://ilgijjan.store/api/diaries'),
        // Uri.parse('https://ilgijjan.store/api/diaries/test'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(diaryData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = json.decode(response.body);
        return responseData;
      } else {
        throw Exception('Diary creation failed with status: ${response.statusCode}, response: ${response.body}');
      }
    } catch (e) {
      throw Exception('Diary creation error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          // 화면 터치 시 새로운 멘트로 변경
          setState(() {
            _currentSpeechText = _getSpeechBubbleText();
          });
        },
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/loading_background.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20), // 상단 여백 줄임
              
              // 캐릭터와 말풍선
              Expanded(
                flex: 4, // flex 값을 늘려서 더 많은 공간 확보
                child: Stack(
                  children: [
                    // 캐릭터 (raerae, meme일 때)
                    if (widget.selectedCharacter == 'raerae' || widget.selectedCharacter == 'meme')
                      Positioned(
                        left: 20,
                        top: 200, // top 값을 줄여서 위쪽으로 이동
                        child: AnimatedBuilder(
                          animation: _bounceAnimation,
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(0, _bounceAnimation.value * 10),
                              child: Image.asset(
                                _getCharacterImage(),
                                width: 180,
                                height: 180,
                                fit: BoxFit.contain,
                              ),
                            );
                          },
                        ),
                      ),
                    
                    // 캐릭터 (dodo일 때)
                    if (widget.selectedCharacter == 'dodo')
                      Positioned(
                        left: -30,
                        top: 160,
                        child: AnimatedBuilder(
                          animation: _bounceAnimation,
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(0, _bounceAnimation.value * 10),
                              child: Image.asset(
                                _getCharacterImage(),
                                width: 240,
                                height: 240,
                                fit: BoxFit.contain,
                              ),
                            );
                          },
                        ),
                      ),
                    
                    // 말풍선 (오른쪽)
                    Positioned(
                      right: -10,
                      top: 140, // top 값을 줄여서 위쪽으로 이동
                      child: Stack(
                        children: [
                          // 말풍선 배경
                          Image.asset(
                            'assets/speech_bubble.png',
                            width: 270,
                            height: 135,
                            fit: BoxFit.contain,
                          ),
                          // 텍스트
                          Positioned(
                            left: 55,
                            bottom: 63,
                            child: Text(
                              _currentSpeechText,
                              style: const TextStyle(
                                fontFamily: 'Katuri',
                                fontSize: 16,
                                color: Colors.black87,
                                height: 1.3,
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
              
              // 하단 메시지
              Expanded(
                flex: 2, // flex 값을 줄여서 하단 영역 축소
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        '조금만 기다려줘,',
                        style: TextStyle(
                          fontFamily: 'Katuri',
                          fontSize: 16,
                          color: Color(0x77000000),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const Text(
                        '멋진 노래가 곧 완성될 거야',
                        style: TextStyle(
                          fontFamily: 'Katuri',
                          fontSize: 16,
                          color: Color(0x77000000),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20), // 여백도 줄임
                      
                      // 로딩 인디케이터
                      const SizedBox(
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF87CEEB)),
                          strokeWidth: 4,
                        ),
                      ),
                      

                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 40),
            ],
          ),
        ),
        ),
      ),
    );
  }
}
