import 'package:test/test.dart';

import 'grid2D.dart';
import 'point.dart';
import 'robot.dart';

void testRobot() {
  test('Robot should not move through walls', () {
    final grid = Grid2D.fromString('''
.#.
...
...
''');

    final robot = Robot(
      position: Point(0, 0),
      facing: Direction.right,
      grid: grid,
    );

    expect(robot.moveForward(), false);
    expect(robot.position, equals(Point(0, 0)));
  });

  test('Robot should follow command sequence', () {
    final grid = Grid2D.fromString('''
....
....
....
G...
''');

    final robot = Robot(
      position: Point(0, 0),
      facing: Direction.right,
      grid: grid,
    );

    // Move to goal
    // ignore: cascade_invocations
    robot
      ..moveForward()
      ..turnRight()
      ..moveForward()
      // ignore: avoid_single_cascade_in_expression_statements
      ..moveForward()
      // ignore: avoid_single_cascade_in_expression_statements
      ..moveForward();

    expect(robot.isAtGoal(), true);
  });
}
