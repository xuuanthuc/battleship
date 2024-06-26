import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:template/src/style/app_colors.dart';
import 'package:template/src/style/app_images.dart';
import 'package:template/src/utilities/game_data.dart';
import '../../routes/navigation_service.dart';
import '../../routes/route_keys.dart';
import '../../style/app_audio.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  goToHome() async {
    await FlameAudio.audioCache.loadAll([
      AppAudio.shoot,
      AppAudio.background,
      AppAudio.defeat,
      AppAudio.gamePlay,
      AppAudio.victory,
      AppAudio.sunk,
      AppAudio.waterSplash,
    ]);
    await Future.delayed(const Duration(seconds: 1));
    GameData.instance.setBlockSize(MediaQuery.sizeOf(context));
    navService.pushReplacementNamed(RouteKey.gameClient);
  }

  @override
  void didChangeDependencies() {
    goToHome();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade200,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundBlue
        ),
        child: Center(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.sizeOf(context).width * 0.5
            ),
            child: Image.asset(
              AppImages.logo,
            ),
          ),
        ),
      ),
    );
  }
}
