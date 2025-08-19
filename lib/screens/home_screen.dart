import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'diary_creation_screen.dart';
import 'diary_completion_screen.dart';
import 'others_song_screen.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class HomeScreen extends StatefulWidget {
  final String userName; // 사용자 이름
  final String selectedCharacter; // 선택된 캐릭터 ID
  
  const HomeScreen({super.key, required this.userName, required this.selectedCharacter});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with RouteAware {
  String selectedYear = DateTime.now().year.toString();
  String selectedMonth = DateTime.now().month.toString().padLeft(2, '0');
  List<Map<String, dynamic>> _diaryList = [];
  bool _isLoading = false;

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
  void initState() {
    super.initState();
    _loadDiaries();
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // RouteObserver에 현재 페이지 구독
    routeObserver.subscribe(this, ModalRoute.of(context)! as PageRoute);
  }

  @override
  void dispose() {
    // RouteObserver 구독 해제
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    // 다른 화면에서 돌아왔을 때 새로고침
    _loadDiaries();
  }

  // @override
  // void didPush() {
  //   // 화면이 새로 푸시되었을 때
  // }

  // @override
  // void didPop() {
  //   // 화면이 팝되었을 때
  // }

  Future<void> _loadDiaries() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse('https://ilgijjan.store/api/diaries?year=$selectedYear&month=$selectedMonth'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _diaryList = List<Map<String, dynamic>>.from(data['diaryList'] ?? []);
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load diaries: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _diaryList = [];
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('일기 목록을 불러오는데 실패했습니다: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _onYearChanged(String? newYear) {
    if (newYear != null && newYear != selectedYear) {
      setState(() {
        selectedYear = newYear;
      });
      _loadDiaries();
    }
  }

  void _onMonthChanged(String? newMonth) {
    if (newMonth != null && newMonth != selectedMonth) {
      setState(() {
        selectedMonth = newMonth;
      });
      _loadDiaries();
    }
  }

  void _showYearPicker() {
    final currentYear = DateTime.now().year;
    final years = List.generate(5, (index) => (currentYear - 2 + index).toString());
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('년도 선택'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: years.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(years[index]),
                  onTap: () {
                    _onYearChanged(years[index]);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _showMonthPicker() {
    final months = List.generate(12, (index) => (index + 1).toString().padLeft(2, '0'));
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('월 선택'),
          content: SizedBox(
            width: double.maxFinite,
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 2.5,
              ),
              itemCount: months.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    _onMonthChanged(months[index]);
                    Navigator.pop(context);
                  },
                  child: Center(
                    child: Text(
                      '${months[index]}월',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // SafeArea for top content only
          SafeArea(
            bottom: false, // 하단 SafeArea 비활성화
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: Column(
                children: [
                  // Main Section with Character and Song Creation
                  const SizedBox(height: 30),

                  Container(
                    width: double.infinity,
                    height: 150,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F4FF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // Left cloud (cloud1)
                        Positioned(
                          top: 10,
                          left: 10,
                          child: Image.asset(
                            'assets/cloud1.png',
                            width: 70,
                            height: 50,
                            fit: BoxFit.contain,
                          ),
                        ),
                        
                        // Right cloud (cloud2)
                        Positioned(
                          top: 40,
                          right: 5,
                          child: Image.asset(
                            'assets/cloud2.png',
                            width: 65,
                            height: 45,
                            fit: BoxFit.contain,
                          ),
                        ),
                        
                        // Skyblue Character Image at bottom
                        Positioned(
                          bottom: 40,
                          left: 20,
                          child: Image.asset(
                            _getCharacterImage(),
                            width: 150,
                            height: 150,
                            fit: BoxFit.contain,
                          ),
                        ),
                        
                        // Speech Bubble
                        Positioned(
                          bottom: 60,
                          right: 40,
                          child: Stack(
                            children: [
                              // Background speech bubble image
                              Image.asset(
                                'assets/speech_bubble.png',
                                width: 170,
                                height: 85,
                                fit: BoxFit.contain,
                              ),
                              // Text overlay
                              Positioned(
                                top: 20,
                                right: 43,
                                child: Text(
                                  '${widget.userName}, 안녕!\n오늘은 어땠어?',
                                  style: TextStyle(
                                    fontFamily: 'Katuri',
                                    fontSize: 15,
                                    color: Colors.black87,
                                    height: 1.2,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        // Song Creation Button at the very bottom
                        Positioned(
                          bottom: 10,
                          left: 20,
                          right: 20,
                          child: GestureDetector(
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DiaryCreationScreen(
                                    userName: widget.userName,
                                    selectedCharacter: widget.selectedCharacter,
                                  ),
                                ),
                              );
                              _loadDiaries(); // 돌아오면 바로 새로고침
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF7EC3FF), // Lighter blue
                                    Color.fromARGB(255, 189, 224, 255), // Slightly darker blue
                                    Color(0xFF7EC3FF),
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.music_note,
                                    color: Colors.black,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 6),
                                  const Text(
                                    '노래 만들기',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Katuri',
                                      fontSize: 23,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 10),
                  
                  // Others Song Button
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OthersSongScreen(
                            userName: widget.userName,
                            selectedCharacter: widget.selectedCharacter,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      height: 80,
                      child: Stack(
                        children: [
                          // Background image
                          Image.asset(
                            'assets/others_song.png',
                            fit: BoxFit.contain,
                          ),
                          // Text overlay
                          Positioned(
                            top: 10,
                            left: 25,
                            child: Text(
                              '다른 친구들\n노래도 들어볼까?',
                              style: const TextStyle(
                                fontFamily: 'Katuri',
                                fontSize: 17,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          // Arrow icon
                          Positioned(
                            top: 15,
                            right: 8,
                            child: const Icon(
                              Icons.chevron_right,
                              size: 38,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 10),
                  
                  // Filter Dropdowns
                  Row(
                    children: [
                      // Year Dropdown
                      GestureDetector(
                        onTap: () => _showYearPicker(),
                        child: Container(
                          width: 90,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: const Color(0xFF87CEEB), width: 2.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                selectedYear,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                              const Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.black,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(width: 12),
                      
                      // Month Dropdown
                      GestureDetector(
                        onTap: () => _showMonthPicker(),
                        child: Container(
                          width: 85,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: const Color(0xFF87CEEB), width: 2.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${selectedMonth}월',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                              const Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.black,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  // const SizedBox(height: 15),
                ],
              ),
            ),
          ),
          
          // Diary Entries List - SafeArea 외부까지 확장
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF87CEEB)),
                      ),
                    )
                  : _diaryList.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          itemCount: _diaryList.length,
                          padding: const EdgeInsets.only(bottom: 20), // 하단 여백 추가
                          itemBuilder: (context, index) {
                            final diary = _diaryList[index];
                            return _buildDiaryEntryItem(diary);
                          },
                        ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.note_add,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            '이번 달에는 일기가 없어요',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '첫 번째 일기를 작성해보세요!',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
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

  String _getWeatherText(String weather) {
    switch (weather) {
      case 'SUNNY':
        return '쨍쨍했어요';
      case 'CLOUDY':
        return '흐렸어요';
      case 'RAIN':
        return '비가 내렸어요';
      case 'SNOW':
        return '눈이 내렸어요';
      default:
        return '쨍쨍했어요';
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



  Widget _buildDiaryEntryItem(Map<String, dynamic> diary) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DiaryCompletionScreen(
              diaryId: diary['id'] ?? 0,
              showConfetti: false, // 홈 화면에서 넘어갈 때는 컨페티 표시 안함
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Generated Image
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: diary['imageUrl'] != null
                    ? Image.network(
                        diary['imageUrl'],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey.shade200,
                            child: const Center(
                              child: Icon(
                                Icons.image_not_supported,
                                color: Colors.grey,
                                size: 30,
                              ),
                            ),
                          );
                        },
                      )
                    : Container(
                        color: Colors.grey.shade200,
                        child: const Center(
                          child: Icon(
                            Icons.image_not_supported,
                            color: Colors.grey,
                            size: 30,
                          ),
                        ),
                      ),
              ),
            ),
            
            const SizedBox(width: 16),
            
            // Date and Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    diary['date'] ?? '날짜 없음',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Image.asset(
                        _getWeatherImage(diary['weather'] ?? 'SUNNY'),
                        width: 20,
                        height: 20,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _getWeatherText(diary['weather'] ?? 'SUNNY'),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Image.asset(
                        _getMoodImage(diary['mood'] ?? 1),
                        width: 20,
                        height: 20,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          diary['introLines'] ?? '내용 없음',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
