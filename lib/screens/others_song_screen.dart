import 'package:flutter/material.dart';

class OthersSongScreen extends StatelessWidget {
  final String userName;
  final String selectedCharacter;

  const OthersSongScreen({
    super.key,
    required this.userName,
    required this.selectedCharacter,
  });

  @override
  Widget build(BuildContext context) {
    final characterImage = {
      'dodo': 'assets/dodo.png',
      'raerae': 'assets/raerae.png',
      'meme': 'assets/meme.png',
    }[selectedCharacter] ?? 'assets/dodo.png';

    final songs = [
      {'image': 'assets/others1.jpg', 'title': '가나다라마바사', 'author': '팔이', 'date': '2025.07.02'},
      {'image': 'assets/others2.jpg', 'title': '강낭콩 키우기', 'author': '팔팔', 'date': '2025.07.26'},
      {'image': 'assets/others3.jpg', 'title': '은은한 꽃 향기', 'author': '콩콩', 'date': '2025.07.16'},
      {'image': 'assets/others4.jpg', 'title': '강아지 귀여워', 'author': '콩이', 'date': '2025.07.24'},
      {'image': 'assets/others5.jpg', 'title': '햇살 가득 웃음', 'author': '미소', 'date': '2025.07.20'},
      {'image': 'assets/others6.jpeg', 'title': '토끼 가족 소풍', 'author': '똘이', 'date': '2025.07.30'},
    ];

    return Scaffold(
      body: Stack(
        children: [
          /// 전체 하늘색 배경
          Container(color: const Color(0xFFEAF4FF)),

          /// SafeArea 바깥 위쪽 영역까지 아이보리 배경
          Positioned(
            top: -10,
            left: 0,
            right: 0,
            height: 200 + MediaQuery.of(context).padding.top, // SafeArea padding 포함
            child: Container(color: const Color(0xFFFFFDF8)),
          ),

          /// SafeArea 안 UI
          SafeArea(
            child: Column(
              children: [
                // 캐릭터 영역 (아이보리 위에 표시됨)
                SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        bottom: -10,
                        left: 20,
                        child: Image.asset(
                          characterImage,
                          width: 150,
                          height: 150,
                          fit: BoxFit.contain,
                        ),
                      ),
                      Positioned(
                        bottom: 50,
                        left: 130,
                        child: Stack(
                          children: [
                            Image.asset(
                              'assets/speech_bubble.png',
                              width: 270,
                              height: 135,
                              fit: BoxFit.contain,
                            ),
                            const Positioned(
                              top: 28,
                              right: 55,
                              child: Text(
                                '다른 친구들의\n노래도 들어볼까?',
                                style: TextStyle(
                                  fontFamily: 'Katuri',
                                  fontSize: 25,
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

                // 곡 리스트
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: GridView.builder(
                      itemCount: songs.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1 / 1.3,
                      ),
                      itemBuilder: (context, index) {
                        final song = songs[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AspectRatio(
                              aspectRatio: 1,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  song['image']!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              song['title']!,
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${song['author']} · ${song['date']}',
                              style: const TextStyle(fontSize: 11, color: Colors.grey),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
