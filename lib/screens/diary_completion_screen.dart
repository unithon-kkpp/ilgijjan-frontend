import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:confetti/confetti.dart';

class DiaryCompletionScreen extends StatefulWidget {
  final int diaryId;
  final bool showConfetti; // 컨페티 표시 여부
  
  const DiaryCompletionScreen({
    super.key, 
    required this.diaryId,
    this.showConfetti = true, // 기본값은 true (로딩 화면에서 넘어올 때)
  });

  @override
  State<DiaryCompletionScreen> createState() => _DiaryCompletionScreenState();
}

class _DiaryCompletionScreenState extends State<DiaryCompletionScreen>
    with SingleTickerProviderStateMixin {
  Map<String, dynamic>? _diaryData;
  bool _isLoading = true;
  bool _isPlaying = false;
  double _playbackProgress = 0.0;
  bool _isImageFlipped = false;
  bool _showTextModal = false;
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;
  late ConfettiController _confettiController;
  final AudioPlayer _audioPlayer = AudioPlayer();
  Duration _totalDuration = Duration.zero;
  Duration _currentPosition = Duration.zero;

  @override
  void initState() {
    super.initState();

    _flipController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _flipAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _flipController,
      curve: Curves.easeInOut,
    ));

    // 컨페티 컨트롤러 초기화
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));

    // 오디오 플레이어 리스너
    _audioPlayer.onDurationChanged.listen((duration) {
      setState(() => _totalDuration = duration);
    });

    _audioPlayer.onPositionChanged.listen((position) {
      setState(() {
        _currentPosition = position;
        _playbackProgress = _totalDuration.inMilliseconds > 0
            ? position.inMilliseconds / _totalDuration.inMilliseconds
            : 0.0;
      });
    });

    _audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        _isPlaying = false;
        _playbackProgress = 0.0;
      });
    });

    _fetchDiaryData();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _flipController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  Future<void> _fetchDiaryData() async {
    try {
      final response = await http.get(
        Uri.parse('https://ilgijjan.store/api/diaries/${widget.diaryId}'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _diaryData = data;
          _isLoading = false;
        });
        
        // showConfetti가 true일 때만 컨페티 효과 시작
        if (widget.showConfetti) {
          _confettiController.play();
        }
      } else {
        throw Exception('Failed to fetch diary data: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('일기 데이터를 불러오는데 실패했습니다: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _getWeatherImage(String weather) {
    switch (weather) {
      case 'SUNNY':
        return 'assets/sunny_drawing.png';
      case 'CLOUDY':
        return 'assets/cloudy_drawing.png';
      case 'RAIN':
        return 'assets/rainy_drawing.png';
      case 'SNOW':
        return 'assets/snowy_drawing.png';
      default:
        return 'assets/sunny_drawing.png';
    }
  }

  String _getMoodImage(int mood) {
    switch (mood) {
      case 1:
        return 'assets/emotion1.png';
      case 2:
        return 'assets/emotion2.png';
      case 3:
        return 'assets/emotion3.png';
      case 4:
        return 'assets/emotion4.png';
      case 5:
        return 'assets/emotion5.png';
      case 6:
        return 'assets/emotion6.png';
      case 7:
        return 'assets/emotion7.png';
      case 8:
        return 'assets/emotion8.png';
      case 9:
        return 'assets/emotion9.png';
      default:
        return 'assets/emotion1.png';
    }
  }

  void _togglePlayPause() async {
    if (_diaryData?['musicUrl'] == null) return;

    if (_isPlaying) {
      await _audioPlayer.pause();
      setState(() => _isPlaying = false);
    } else {
      // 만약 처음 재생이라면 URL 세팅
      if (_currentPosition == Duration.zero) {
        await _audioPlayer.play(UrlSource(_diaryData!['musicUrl']));
      } else {
        await _audioPlayer.resume();
      }
      setState(() => _isPlaying = true);
    }
  }

  void _flipImage() {
    if (_diaryData!['lyrics'] != null) {
      setState(() {
        _isImageFlipped = !_isImageFlipped;
      });
      
      if (_isImageFlipped) {
        _flipController.forward();
      } else {
        _flipController.reverse();
      }
    }
  }

  void _showTextModalDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        final screenHeight = MediaQuery.of(context).size.height;
        final String? text = _diaryData?['text'];
        final String? photoUrl = _diaryData?['photoUrl'];

        return GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            color: Colors.transparent,
            child: GestureDetector(
              onTap: () {}, // 내부 터치 시 닫히지 않도록
              child: Container(
                width: double.infinity,
                height: screenHeight * 0.7,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    // Title with date
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
                      child: Text(
                        _diaryData!['date'] ?? '',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    // 본문: text 또는 photoUrl 표시
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: text != null && text.isNotEmpty
                            ? SingleChildScrollView(
                                child: Text(
                                  text,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,
                                    height: 1.6,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              )
                            : (photoUrl != null && photoUrl.isNotEmpty)
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      photoUrl,
                                      fit: BoxFit.contain,
                                      errorBuilder: (context, error, stackTrace) {
                                        return const Center(
                                          child: Text(
                                            '사진을 불러올 수 없습니다.',
                                            style: TextStyle(color: Colors.grey),
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                : const Center(
                                    child: Text(
                                      '내용이 없습니다.',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLyricsView() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF0F8FF),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '가사',
              style: TextStyle(
                fontFamily: 'Katuri',
                fontSize: 18,
                color: Color(0xFF87CEEB),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  _diaryData!['lyrics'] ?? '가사가 없습니다.',
                  style: const TextStyle(
                    fontFamily: 'Katuri',
                    fontSize: 16,
                    color: Colors.black87,
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '터치하여 이미지로 돌아가기',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                // fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFF8F9FA),
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF87CEEB)),
          ),
        ),
      );
    }

    if (_diaryData == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              const Text(
                '일기 데이터를 불러올 수 없습니다',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _fetchDiaryData,
                child: const Text('다시 시도'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background_knoll.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                // Header with date, weather, and mood
                Container(
                  margin: const EdgeInsets.only(top: 50.0, left: 30.0, right: 30.0),
                  child: Row(
                    children: [
                      // Date
                      Expanded(
                        child: Text(
                          _diaryData!['date'] ?? '2025년 8월 1일',
                          style: const TextStyle(
                            fontSize: 18,
                            // fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      // Weather icon
                      Image.asset(
                        _getWeatherImage(_diaryData!['weather'] ?? 'SUNNY'),
                        width: 30,
                        height: 30,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(width: 16),
                      // Mood icon
                      Image.asset(
                        _getMoodImage(_diaryData!['mood'] ?? 1),
                        width: 30,
                        height: 30,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // Generated image area
                Center(
                  child: Container(
                    width: 330,
                    height: 330,
                    margin: const EdgeInsets.symmetric(horizontal: 24.0),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: _diaryData!['imageUrl'] != null
                    ? GestureDetector(
                        onTap: _diaryData!['lyrics'] != null ? _flipImage : null,
                        child: AnimatedBuilder(
                          animation: _flipAnimation,
                          builder: (context, child) {
                            final flipValue = _flipAnimation.value;
                            final isFlipped = flipValue > 0.5;
                            
                            return Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.identity()
                                ..setEntry(3, 2, 0.001)
                                ..rotateY(flipValue * 3.14159),
                              child: isFlipped
                                  ? Transform(
                                      alignment: Alignment.center,
                                      transform: Matrix4.identity()..rotateY(3.14159),
                                      child: _buildLyricsView(),
                                    )
                                                                    : ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        _diaryData!['imageUrl'],
                                        // fit: BoxFit.contain,
                                        fit: BoxFit.fitHeight,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Container(
                                            color: Colors.grey.shade200,
                                            child: const Center(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.image_not_supported,
                                                    size: 64,
                                                    color: Colors.grey,
                                                  ),
                                                  SizedBox(height: 16),
                                                  Text(
                                                    '생성된 이미지를 불러올 수 없습니다',
                                                    style: TextStyle(color: Colors.grey),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                              );
                          },
                        ),
                      )
                    : Container(
                        width: 330,
                        height: 330,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Center(
                          child: Text(
                            '이미지가 없습니다',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                  ),

                const SizedBox(height: 16),

                // Book icon only
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 30.0),
                    child: GestureDetector(
                      onTap: _showTextModalDialog,
                      child: Image.asset(
                        'assets/book.png',
                        width: 40,
                        height: 40,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),

                // Music player controls
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      // Progress bar
                      Slider(
                        value: _currentPosition.inSeconds.toDouble(),
                        min: 0.0,
                        max: _totalDuration.inSeconds > 0 
                            ? _totalDuration.inSeconds.toDouble() 
                            : 100.0, // 기본값 100초
                        activeColor: const Color(0xFF4CB14C),
                        inactiveColor: Colors.grey.shade300,
                        onChanged: (value) async {
                          if (_totalDuration.inSeconds > 0) {
                            final position = Duration(seconds: value.toInt());
                            await _audioPlayer.seek(position);
                          }
                        },
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Play button
                      GestureDetector(
                        onTap: _togglePlayPause,
                        child: Icon(
                          _isPlaying ? Icons.pause : Icons.play_arrow,
                          size: 100,
                          color: Color(0xFF4CB14C),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            ),
          ),
          
          // 컨페티 효과 (최상단에 표시)
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: pi / 2, // 아래쪽으로 떨어짐
              maxBlastForce: 5,
              minBlastForce: 2,
              emissionFrequency: 0.05,
              numberOfParticles: 13,
              gravity: 0.1,
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple,
                Colors.red,
                Colors.yellow,
                Colors.teal,
              ],
            ),
          ),
        ],
      ),
    );
  }
}

