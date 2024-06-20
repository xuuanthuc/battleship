part of 'game_play_cubit.dart';

enum GameAction {
  prepare,
  shuffle,
  ready,
  play,
  checkHit,
  checkSunk,
  shoot,
  continueTurn,
  nextTurn,
  pause,
  end
}

enum ReadyStatus {
  init,
  preparing,
  prepared,
  ready,
}

@immutable
class GamePlayState extends Equatable {
  final ReadyStatus status;
  final GameAction action;
  final RoomData room;
  final Player? player;
  final bool? iamHost;
  final bool skipIntro;

  const GamePlayState({
    required this.status,
    required this.action,
    required this.room,
    required this.player,
    required this.iamHost,
    required this.skipIntro,
  });

  GamePlayState.empty()
      : this(
          action: GameAction.prepare,
          status: ReadyStatus.init,
          room: RoomData(),
          player: null,
          iamHost: false,
          skipIntro: false,
        );

  GamePlayState copyWith({
    ReadyStatus? status,
    GameAction? action,
    RoomData? room,
    Player? player,
    bool? iamHost,
    bool? skipIntro,
  }) {
    return GamePlayState(
      status: status ?? this.status,
      action: action ?? this.action,
      room: room ?? this.room,
      player: player ?? this.player,
      iamHost: iamHost ?? this.iamHost,
      skipIntro: skipIntro ?? this.skipIntro,
    );
  }

  @override
  List<Object?> get props => [
        status,
        action,
        room,
        player,
        iamHost,
        skipIntro,
      ];
}
