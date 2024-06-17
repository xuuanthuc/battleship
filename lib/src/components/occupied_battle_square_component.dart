import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';
import 'package:template/src/utilities/game_data.dart';
import 'package:template/src/models/battle.dart';
import 'package:template/src/models/empty_block.dart';
import '../bloc/game_play/game_play_cubit.dart';

class OccupiedBattleSquareComponent extends SpriteComponent
    with
        FlameBlocReader<GamePlayCubit, GamePlayState>,
        FlameBlocListenable<GamePlayCubit, GamePlayState>, HasVisibility {
  final OccupiedBattleSquare square;
  final int index;
  final Vector2 initialPosition;
  final double initialAngle;

  OccupiedBattleSquareComponent({
    ComponentKey? key,
    required this.square,
    required this.index,
    required this.initialPosition,
    required this.initialAngle,
  }) : super(key: key);

  List<PositionComponent> collisions = [];
  List<EmptyBlock> overlappingEmptyBlocks = [];

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load(square.block.sprite);
    anchor = Anchor.center;
    angle = initialAngle;
    priority = 3;
    isVisible = false;
    size = Vector2(GameData.instance.blockSize * square.block.size,
        GameData.instance.blockSize);
    Future.delayed(const Duration(seconds: 1)).then((_) {
      handlePosition(findClosestVector(bloc.state.emptySquares, initialPosition));
    });
    return super.onLoad();
  }


  Vector2 findClosestVector(List<EmptyBattleSquare> vectors, Vector2 target) {
    Vector2 closestVector = vectors.first.block.vector2!;
    double minDistance = double.infinity;

    for (EmptyBattleSquare vector in vectors) {
      double distance = (vector.block.vector2! - target).length;
      if (distance < minDistance) {
        minDistance = distance;
        closestVector = vector.block.vector2!;
      }
    }
    return closestVector;
  }

  Vector2 adjustPositionToStayWithinBounds(
      Vector2 position, Rect boundary, Vector2 size) {
    double halfWidth = (angle == radians(90) ? size.y : size.x) / 2;
    double halfHeight = (angle == radians(90) ? size.x : size.y) / 2;

    // Calculate new position ensuring the entire component stays within the boundary
    double newX = position.x;
    double newY = position.y;

    if (square.block.size % 2 == 0) {
      if (angle == radians(90)) {
        newY += GameData.instance.blockSize / 2;
      } else {
        newX += GameData.instance.blockSize / 2;
      }
    }

    // Ensure the component doesn't go beyond the left or right boundaries
    if (newX - halfWidth < boundary.left) {
      newX = boundary.left + halfWidth;
    } else if (newX + halfWidth > boundary.right) {
      newX = boundary.right - halfWidth;
    }

    // Ensure the component doesn't go beyond the top or bottom boundaries
    if (newY - halfHeight < boundary.top) {
      newY = boundary.top + halfHeight;
    } else if (newY + halfHeight > boundary.bottom) {
      newY = boundary.bottom - halfHeight;
    }
    return Vector2(newX, newY);
  }

  void handlePosition(Vector2 targetPosition) {
    position = adjustPositionToStayWithinBounds(
      targetPosition,
      GameData.instance.getEmptyBlocksBoundary(),
      size,
    );
  }

  @override
  void onNewState(GamePlayState state) {
    print('check state');
    if(square.overlappingPositions.isEmpty){
      isVisible = true;
    }
    super.onNewState(state);
  }
}