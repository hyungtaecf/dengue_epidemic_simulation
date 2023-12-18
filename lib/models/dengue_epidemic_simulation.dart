import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:dengue_epidemic_simulation/models/agent.dart';
import 'package:dengue_epidemic_simulation/models/city_grid.dart';
import 'package:dengue_epidemic_simulation/models/mosquito.dart';
import 'package:dengue_epidemic_simulation/models/person.dart';

class DengueEpidemicSimulation extends FlameGame {
  late final CityGrid cityGrid;
  final int gridSize = 20; // Example grid size
  final double cellSize = 20; // Size of each cell in the grid
  double updateTimer = 0.0;
  final double updateInterval = 1; // Update every 1 second

  @override
  Future<void> onLoad() async {
    super.onLoad();
    cityGrid = CityGrid(gridSize);

    // Initialize and add entities to the game
    addInitialEntities();
  }

  void addInitialEntities() {
    const femaleCount = 20;
    const maleCount = 20;
    const personCount = 20;
    const agentCount = 10;

    final emptyPositions = cityGrid.emptyPositions;
    for (var i = 0; i < femaleCount; i++) {
      final position = (emptyPositions.toList()..shuffle()).firstOrNull;
      if (position == null) break;
      add(FemaleMosquito(cityGrid: cityGrid, position: position));
      emptyPositions.remove(position);
    }
    for (var i = 0; i < maleCount; i++) {
      final position = (emptyPositions.toList()..shuffle()).firstOrNull;
      if (position == null) break;
      add(MaleMosquito(cityGrid: cityGrid, position: position));
      emptyPositions.remove(position);
    }
    for (var i = 0; i < personCount; i++) {
      final position = (emptyPositions.toList()..shuffle()).firstOrNull;
      if (position == null) break;
      add(Person(cityGrid: cityGrid, position: position));
      emptyPositions.remove(position);
    }
    for (var i = 0; i < agentCount; i++) {
      final position = (emptyPositions.toList()..shuffle()).firstOrNull;
      if (position == null) break;
      add(Agent(cityGrid, position));
      emptyPositions.remove(position);
    }
  }

  @override
  void update(double dt) {
    // Accumulate elapsed time
    updateTimer += dt;

    // Check if 1 second has passed
    if (updateTimer >= updateInterval) {
      // Reset timer
      updateTimer = 0.0;

      // Update all components
      super.update(dt);
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    drawGrid(canvas);
  }

  void drawGrid(Canvas canvas) {
    final paint = Paint();
    for (int x = 0; x < gridSize; x++) {
      for (int y = 0; y < gridSize; y++) {
        // Draw grid cell
        Rect rect =
            Rect.fromLTWH(x * cellSize, y * cellSize, cellSize, cellSize);
        paint.color = Colors.brown[50]!; // Color for empty cells
        canvas.drawRect(rect, paint);

        // Draw entities based on their type
        var entity =
            cityGrid.getContentAtPosition(Vector2(x.toDouble(), y.toDouble()));
        if (entity == null) {
          canvas.drawRect(rect, paint);
        } else {
          if (entity is Mosquito) {
            paint.color = (entity is FemaleMosquito
                ? Colors.pink[100]
                : Colors.lightBlue[100])!;
            // canvas.drawRect(rect, paint);
            canvas.drawCircle(
                Offset(
                    x * cellSize + cellSize / 2, y * cellSize + cellSize / 2),
                cellSize / 2,
                paint);
          }
          TextPaint(
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ).render(
            canvas,
            entity.label,
            Vector2(cellSize * x + cellSize / 2, cellSize * y + cellSize / 2),
            anchor: Anchor.center,
          );
        }
      }
    }
  }
}
