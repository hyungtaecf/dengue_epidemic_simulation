import 'package:flame/components.dart';
import 'package:dengue_epidemic_simulation/models/city_grid.dart';
import 'package:dengue_epidemic_simulation/models/entity.dart';
import 'package:dengue_epidemic_simulation/models/mosquito.dart';
import 'package:dengue_epidemic_simulation/models/mosquito_egg.dart';
import 'package:dengue_epidemic_simulation/models/person.dart';

class Agent extends Entity {
  Agent(CityGrid cityGrid, Vector2 position)
      : super(cityGrid, '🕵️‍♀️', position: position, size: Vector2.all(10));

  void move(Vector2 nextPosition) {
    cityGrid.updateEntityPosition(this, nextPosition);
    position = nextPosition;
  }

  @override
  void update(double dt) {
    super.update(dt);
    var nextPosition = position.clone();
    nextPosition.x++;
    if (nextPosition.x == cityGrid.size) {
      nextPosition.y++;
      if (nextPosition.y == cityGrid.size) {
        nextPosition = Vector2.zero();
      } else {
        nextPosition.x = 0.0;
      }
    }
    // Check for and eliminate mosquitoes or eggs at the current position
    var nextPosContent = cityGrid.getContentAtPosition(nextPosition);
    if (nextPosContent is Person || nextPosContent is Agent) return;
    if (nextPosContent is Mosquito || nextPosContent is MosquitoEgg) {
      // Eliminate the mosquito or egg
      cityGrid.clearPosition(nextPosition);
    }
    move(nextPosition);
  }
}
