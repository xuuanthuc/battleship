import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:template/src/screens/game_clients/bloc/game_client_cubit.dart';
import 'package:template/src/screens/widgets/bounce_button.dart';
import 'package:template/src/style/app_colors.dart';
import 'package:template/src/style/app_images.dart';
import 'package:template/src/utilities/game_data.dart';
import 'package:template/src/utilities/toast.dart';
import '../widgets/primary_button.dart';
import '../widgets/secondary_button.dart';

class RoomScreen extends StatefulWidget {
  const RoomScreen({super.key});

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 4),
    vsync: this,
  )..repeat(reverse: true);
  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: const Offset(-0.02, 0),
    end: const Offset(0.02, 0),
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.linear,
  ));

  @override
  void initState() {
    super.initState();
    GameData.instance.setOccupiedSkin(BattleshipSkin.A);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameClientCubit, GameClientState>(
      builder: (context, state) {
        final currentPlayer = state.player;
        final hostPlayer = state.room?.ownerPlayer;
        final iamHost = currentPlayer != null &&
            hostPlayer != null &&
            currentPlayer.id == hostPlayer.id;

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                SecondaryButton.icon(
                  onPressed: () {
                    if (iamHost) {
                      context.read<GameClientCubit>().deleteRoom();
                    } else {
                      context.read<GameClientCubit>().outRoom();
                    }
                  },
                  icon: AppImages.arrowBack,
                ),
              ],
            ),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SlideTransition(
                            position: _offsetAnimation,
                            child: Transform.scale(
                              scale: iamHost ? 1 : 0.75,
                              child: Stack(
                                children: [
                                  Container(
                                    constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.sizeOf(context).width *
                                                  0.4 -
                                              15,
                                      maxHeight:
                                          MediaQuery.sizeOf(context).height *
                                              0.4,
                                    ),
                                    margin: EdgeInsets.all(20.w),
                                    child: Image.asset(state
                                            .room?.ownerPlayer?.skin
                                            ?.preview() ??
                                        ""),
                                  ),
                                  Text(
                                    iamHost ? "You" : "Host",
                                    style: TextStyle(
                                      fontFamily: "Mitr",
                                      fontWeight: FontWeight.w700,
                                      fontSize: 40.sp,
                                      letterSpacing: 2,
                                      foreground: Paint()
                                        ..style = PaintingStyle.stroke
                                        ..strokeWidth = 3.w
                                        ..color = Colors.black,
                                    ),
                                  ),
                                  Text(
                                    iamHost ? "You" : "Host",
                                    style: TextStyle(
                                      fontFamily: "Mitr",
                                      letterSpacing: 2,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 40.sp,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 30.w),
                          Visibility(
                            visible: state.room?.guestPlayer != null,
                            child: SlideTransition(
                              position: _offsetAnimation,
                              child: Transform.scale(
                                scale: iamHost ? 0.75 : 1,
                                child: Stack(
                                  children: [
                                    Container(
                                      constraints: BoxConstraints(
                                        maxWidth:
                                            MediaQuery.sizeOf(context).width *
                                                    0.4 -
                                                15,
                                        maxHeight:
                                            MediaQuery.sizeOf(context).height *
                                                0.4,
                                      ),
                                      margin: const EdgeInsets.all(20),
                                      child: Image.asset(state
                                              .room?.guestPlayer?.skin
                                              ?.preview() ??
                                          ""),
                                    ),
                                    Text(
                                      iamHost ? "Guest" : "You",
                                      style: TextStyle(
                                        fontFamily: "Mitr",
                                        fontWeight: FontWeight.w700,
                                        fontSize: 40.sp,
                                        letterSpacing: 2,
                                        foreground: Paint()
                                          ..style = PaintingStyle.stroke
                                          ..strokeWidth = 3.w
                                          ..color = Colors.black,
                                      ),
                                    ),
                                    Text(
                                      iamHost ? "Guest" : "You",
                                      style: TextStyle(
                                        fontFamily: "Mitr",
                                        letterSpacing: 2,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 40.sp,
                                        color: Colors.white,
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
                  ),
                  SizedBox(height: 10.h),
                  Center(
                    child: SizedBox(
                      height: 150.h,
                      child: ListView.separated(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        separatorBuilder: (_, __) => SizedBox(width: 30.w),
                        itemBuilder: (context, index) {
                          return BounceButton(
                            onPressed: () {
                              context.read<GameClientCubit>().setSkin(
                                    BattleshipSkin.values[index],
                                    iamHost,
                                  );
                            },
                            child: Container(
                              height: 150.h,
                              width: 150.h,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(
                                    width: 5.h,
                                    color: Colors.white,
                                  ),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.white30,
                                      offset: Offset(0, 4),
                                      blurRadius: 5,
                                      spreadRadius: 1,
                                    )
                                  ]),
                              child: AnimatedContainer(
                                duration: const Duration(seconds: 1),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 10.h,
                                    color: state.skin ==
                                            BattleshipSkin.values[index]
                                        ? AppColors.primaryDark
                                        : AppColors.primary,
                                  ),
                                  borderRadius: BorderRadius.circular(100),
                                  gradient:
                                      BattleshipSkin.values[index].background(),
                                ),
                                child: Image.asset(
                                  BattleshipSkin.values[index].preview(),
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: BattleshipSkin.values.length,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                BounceButton(
                  onPressed: () async {
                    if ((state.room?.code ?? "").isEmpty) return;
                    await Clipboard.setData(
                        ClipboardData(text: state.room!.code!));
                    if (context.mounted) {
                      appToast(message: "Copied to clipboard!");
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        width: 3.w,
                        color: Colors.black,
                      ),
                      color: AppColors.grayDark,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.gray,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: 50.w, vertical: 15.h),
                      child: Row(
                        children: [
                          Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              Text(
                                state.room?.code ?? '',
                                style: TextStyle(
                                  fontFamily: "Mitr",
                                  fontWeight: FontWeight.w700,
                                  fontSize: 24.sp,
                                  letterSpacing: 2,
                                  foreground: Paint()
                                    ..style = PaintingStyle.stroke
                                    ..strokeWidth = 3.w
                                    ..color = Colors.black,
                                ),
                              ),
                              Text(
                                state.room?.code ?? '',
                                style: TextStyle(
                                  fontFamily: "Mitr",
                                  letterSpacing: 2,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 24.sp,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 20.w),
                          SizedBox(
                            height: 30.h,
                            child: Image.asset(
                              AppImages.copy,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                if (!iamHost) const Spacer(),
                SizedBox(width: 30.w),
                PrimaryButton.primary(
                  onPressed: () async {
                    final room = state.room;
                    final player = state.player;
                    if (room == null || player == null) return;
                    await Future.delayed(const Duration(milliseconds: 300));
                    if (iamHost) {
                      if (room.guestPlayer?.ready == true) {
                        if (context.mounted) {
                          context.read<GameClientCubit>().start();
                        }
                      }
                    } else {
                      context.read<GameClientCubit>().guestReady();
                    }
                  },
                  text: iamHost
                      ? "START"
                      : state.room?.guestPlayer?.ready == true
                          ? "CANCEL"
                          : "READY",
                  fontSize: 30.sp,
                  background: state.room?.guestPlayer?.ready == true
                      ? iamHost
                          ? AppColors.primary
                          : AppColors.gray
                      : iamHost
                          ? AppColors.gray
                          : AppColors.primary,
                  underground: state.room?.guestPlayer?.ready == true
                      ? iamHost
                          ? AppColors.primaryDark
                          : AppColors.grayDark
                      : iamHost
                          ? AppColors.grayDark
                          : AppColors.primaryDark,
                  padding: EdgeInsets.symmetric(
                    vertical: 25.h,
                    horizontal: 50.w,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
