// Mosquito class
import 'dart:math';

import 'package:flame/components.dart';
import 'package:dengue_epidemic_simulation/models/city_grid.dart';
import 'package:dengue_epidemic_simulation/models/dengue_epidemic_simulation.dart';
import 'package:dengue_epidemic_simulation/models/entity.dart';
import 'package:dengue_epidemic_simulation/models/mosquito_egg.dart';
import 'package:dengue_epidemic_simulation/models/person.dart';

abstract class Mosquito extends Entity with AllDirectionMove {
  Mosquito({
    required CityGrid cityGrid,
    required Vector2 position,
  }) : super(
          cityGrid,
          '🦟',
          position: position,
          size: Vector2.all(10),
        );

  static Mosquito newBorn({
    required CityGrid cityGrid,
    required Vector2 position,
  }) =>
      Random().nextBool()
          ? FemaleMosquito(cityGrid: cityGrid, position: position)
          : MaleMosquito(cityGrid: cityGrid, position: position);

  @override
  void update(dt) {
    super.update(dt);

    move();
  }
}

class FemaleMosquito extends Mosquito
    with HasGameReference<DengueEpidemicSimulation> {
  FemaleMosquito({
    required super.cityGrid,
    required super.position,
  });

  @override
  void update(dt) {
    var hasMoved = false;

    // Check for nearby persons to potentially infect
    final persons = cityGrid.getNearbyEntities(position).whereType<Person>();
    for (var person in persons) {
      person.getInfected();
    }

    // Check for nearby male mosquitoes to lay eggs
    if (cityGrid.hasNearbyEntity<MaleMosquito>(position)) layEggAndMove();

    if (!hasMoved) move();
  }

  bool layEggAndMove() {
    final newPosition = randomPositionToMove;

    if (newPosition == null) return false;

    final egg = MosquitoEgg(cityGrid: cityGrid, position: position);
    cityGrid
      ..updateEntityPosition(this, newPosition)
      ..updateEntityPosition(egg, position);
    game.add(egg);
    return true;
  }
}

class MaleMosquito extends Mosquito {
  MaleMosquito({
    required super.cityGrid,
    required super.position,
  });
}
