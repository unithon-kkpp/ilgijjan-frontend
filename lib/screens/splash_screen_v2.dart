import 'package:flutter/material.dart';
import 'welcome_screen.dart';

class SplashScreenV2 extends StatefulWidget {
  const SplashScreenV2({super.key});

  @override
  State<SplashScreenV2> createState() => _SplashScreenV2State();
}

class _SplashScreenV2State extends State<SplashScreenV2>
    with TickerProviderStateMixin {
  late AnimationController _moveController;
  late AnimationController _heartbeatController;
  late Animation<double> _moveAnimation;
  late Animation<double> _heartbeatAnimation;

  @override
  void initState() {
    super.initState();

    // 위아래 움직임 애니메이션
    _moveController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _moveAnimation = Tween<double>(
      begin: -30,
      end: 30,
    ).animate(CurvedAnimation(
      parent: _moveController,
      curve: Curves.easeInOut,
    ));

    // 하트비트 애니메이션
    _heartbeatController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _heartbeatAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _heartbeatController,
      curve: Curves.elasticOut,
    ));

    // 애니메이션 시작
    _moveController.repeat(reverse: true);
    _heartbeatController.repeat(reverse: true);

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const WelcomeScreen(),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _moveController.dispose();
    _heartbeatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF86BBFF),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xFF86BBFF),
        child: SafeArea(
          child: Center(
            child: AnimatedBuilder(
              animation: Listenable.merge([_moveController, _heartbeatController]),
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _moveAnimation.value),
                  child: Transform.scale(
                    scale: _heartbeatAnimation.value,
                    child: Image.asset(
                      'assets/logo.png',
                      width: 200,
                      height: 200,
                      fit: BoxFit.contain,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
