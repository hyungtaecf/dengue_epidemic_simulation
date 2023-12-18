// Base class for all entities
import 'package:flame/components.dart';
import 'package:dengue_epidemic_simulation/models/city_grid.dart';

abstract class Entity extends PositionComponent {
  CityGrid cityGrid;

  Entity(
    this.cityGrid,
    this.label, {
    super.position,
    super.size,
    super.priority = 100,
  });

  String label;
}

mixin AllDirectionMove on Entity {
  Vector2? get randomPositionToMove {
    final movePositions = ([
      for (int i = -1; i <= 1; i++)
        for (int j = -1; j <= 1; j++) Vector2(position.x + i, position.y + j),
    ]..remove(Vector2(position.x, position.y)))
      ..removeWhere((pos) {
        final isOutOfBoundaries = pos.x < 0 ||
            pos.x >= cityGrid.size ||
            pos.y < 0 ||
            pos.y >= cityGrid.size;
        if (isOutOfBoundaries) return true;
        final isNotEmpty = cityGrid.getContentAtPosition(pos) != null;
        if (isNotEmpty) return true;
        return false;
      });

    return (movePositions..shuffle()).firstOrNull;
  }

  bool move() {
    final newPosition = randomPositionToMove;

    // Don't move if there's no place to go
    if (newPosition == null) return false;

    cityGrid.updateEntityPosition(this, newPosition);
    position = newPosition;
    return true;
  }
}
