// Mosquito class
import 'package:flame/components.dart';
import 'package:dengue_epidemic_simulation/models/city_grid.dart';
import 'package:dengue_epidemic_simulation/models/entity.dart';
import 'package:dengue_epidemic_simulation/models/mosquito.dart';

class MosquitoEgg extends Entity with HasGameReference {
  int currentCicle = 0;
  MosquitoEgg({
    required CityGrid cityGrid,
    required Vector2 position,
  }) : super(
          cityGrid,
          '🥚',
          position: position,
          size: Vector2.all(10),
          priority: 10,
        );

  static const _ciclesToHatch = 3;
  @override
  void update(double dt) {
    super.update(dt);
    currentCicle++;
    if (currentCicle == _ciclesToHatch) _hatch();
  }

  void _hatch() {
    cityGrid.clearPosition(position);
    final newBorn = Mosquito.newBorn(cityGrid: cityGrid, position: position);
    game.add(newBorn);
    cityGrid.updateEntityPosition(newBorn, position);
  }
}
