import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template/src/bloc/game_play/game_play_cubit.dart';
import 'package:template/src/di/dependencies.dart';
import 'package:template/src/screens/game_clients/bloc/game_client_cubit.dart';
import '../screens/game_clients/game_client_screen.dart';
import '../screens/game_play/game_play.dart';
import '../screens/splash/splash_screen.dart';
import 'route_keys.dart';

class AppRoutes {
  static Route? onGenerateRoutes(RouteSettings settings) {
    String routeSettings = settings.name ?? '';
    switch (settings.name) {
      case RouteKey.splash:
        return _materialRoute(routeSettings, const SplashScreen());
      case RouteKey.gamePlay:
        final args = settings.arguments as Map<String, dynamic>;
        return _materialRoute(
          routeSettings,
          BlocProvider(
            create: (_) => getIt.get<GamePlayCubit>(),
            child: GamePlayScreen(
              room: args['room'],
              player: args['player'],
            ),
          ),
        );
      case RouteKey.gameClient:
        return _materialRoute(
          routeSettings,
          BlocProvider(
            create: (_) => getIt.get<GameClientCubit>(),
            child: const GameClientScreen(),
          ),
        );
      default:
        return null;
    }
  }

  static List<Route> onGenerateInitialRoute() {
    return [_materialRoute(RouteKey.splash, const SplashScreen())];
  }

  static Route<dynamic> _materialRoute(String routeSettings, Widget view) {
    return PageRouteBuilder(
      settings: RouteSettings(name: routeSettings),
      pageBuilder: (_, __, ___) => view,
      opaque: false,
      // transitionsBuilder: (context, animation, secondaryAnimation, child) {
      //   const begin = 0.0;
      //   const end = 1.0;
      //   const curve = Curves.ease;
      //   var tween =
      //       Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      //   return ScaleTransition(
      //     scale: animation.drive(tween),
      //     child: child,
      //   );
      // },
    );
  }
}
