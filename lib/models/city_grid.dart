// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flame/components.dart';

import 'package:dengue_epidemic_simulation/models/entity.dart';
import 'package:dengue_epidemic_simulation/models/mosquito.dart';
import 'package:dengue_epidemic_simulation/models/mosquito_egg.dart';

/// CityGrid class to manage the simulation grid
class CityGrid {
  final int size;
  late List<List<Entity?>> _grid;

  CityGrid(this.size) {
    // Initialize the grid with empty spaces
    _grid = List.generate(size, (_) => List.generate(size, (_) => null));
  }

  int getEntityCount<T extends Entity>() {
    var count = 0;
    for (var i = 0; i < size; i++) {
      for (var j = 0; j < size; j++) {
        final value = _grid[i][j];
        if (value is T) count++;
      }
    }
    return count;
  }

  Set<Vector2> get emptyPositions {
    final result = <Vector2>{};
    for (var i = 0; i < _grid.length; i++)
      for (var j = 0; j < _grid.length; j++) {
        final content = _grid[i][j];
        if (content == null) result.add(Vector2(i.toDouble(), j.toDouble()));
      }
    return result;
  }

  /// Validates and adjusts the position to keep it within grid boundaries
  void validatePosition(Vector2 position) {
    position.x = position.x.clamp(0.0, size.toDouble() - 1.0);
    position.y = position.y.clamp(0.0, size.toDouble() - 1.0);
  }

  List<Entity> getNearbyEntities(Vector2 position) {
    final result = <Entity>[];
    int posX = position.x.toInt();
    int posY = position.y.toInt();

    for (int i = -1; i <= 1; i++) {
      for (int j = -1; j <= 1; j++) {
        int checkX = posX + i;
        int checkY = posY + j;

        // Skip itself
        if (checkX == posX && checkY == posY) continue;

        // Check boundaries
        if (checkX < 0 || checkX >= size || checkY < 0 || checkY >= size) {
          continue;
        }

        final value = _grid[checkX][checkY];
        if (value != null) result.add(value);
      }
    }
    return result;
  }

  /// Check for nearby entities of a specific type
  bool hasNearbyEntity<T>(Vector2 position) =>
      getNearbyEntities(position).any((e) => e is T);

  /// Method to update the grid representation of an entity
  void updateEntityPosition(Entity entity, Vector2 newPosition) {
    int newX = newPosition.x.toInt();
    int newY = newPosition.y.toInt();

    for (var i = 0; i < size; i++) {
      for (var j = 0; j < size; j++) {
        final value = _grid[i][j];
        if (value == entity) _grid[i][j] = null;
      }
    }

    // Set new position
    if (newX >= 0 && newX < size && newY >= 0 && newY < size) {
      _grid[newX][newY] = entity;
    }
  }

  /// Method to get content at a specific position
  Entity? getContentAtPosition(Vector2 position) {
    int x = position.x.toInt();
    int y = position.y.toInt();
    final isValidPosition = x >= 0 && x < size && y >= 0 && y < size;
    if (!isValidPosition) throw InvalidPositionException();
    return _grid[x][y];
  }

  /// Method to clear content at a specific position
  void clearPosition(Vector2 position) {
    int x = position.x.toInt();
    int y = position.y.toInt();
    if (x >= 0 && x < size && y >= 0 && y < size) {
      final content = _grid[x][y];
      if (content is Mosquito || content is MosquitoEgg) {
        content!.removeFromParent();
      }
      _grid[x][y] = null;
    }
  }
}

class InvalidPositionException implements Exception {}
