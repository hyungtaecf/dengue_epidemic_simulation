// Person class
import 'package:flame/components.dart';
import 'package:dengue_epidemic_simulation/models/city_grid.dart';
import 'package:dengue_epidemic_simulation/models/entity.dart';

class Person extends Entity with AllDirectionMove {
  bool isInfected = false;

  Person({
    required CityGrid cityGrid,
    required Vector2 position,
  }) : super(cityGrid, '🙂', position: position, size: Vector2.all(10));

  void getInfected() {
    isInfected = true;
    label = '🤢';
  }

  @override
  void update(double dt) {
    super.update(dt);

    move();
  }
}
