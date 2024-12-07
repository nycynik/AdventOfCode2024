import '../utils/grid2D.dart';
import '../utils/index.dart';
import '../utils/point.dart';
import '../utils/robot.dart';

class Day06 extends GenericDay {
  Day06() : super(6);

  @override
  Grid2D parseInput() {
    return Grid2D.fromString(input.asString);
  }

  @override
  int solvePart1() {
    final grid = parseInput();

    // Create custom cell types (optional)
    final customCellTypes = [
      const CellType('.', 'Empty space', CellBehavior.clear),
      const CellType('#', 'Obstical', CellBehavior.blocking),
      const CellType('^', 'Start', CellBehavior.start),
    ];

    // Create a robot
    final robot = Robot(
      facing: Direction.up,
      grid: grid,
      cellTypes: customCellTypes,
    );

    // // Print the grid
    // print(grid.toStringWithCoordinates());

    runRunRobot(grid, robot, blockAdded: true);
    //print(robot.getPathMap(withCoordinates: true)); uncomment this

    return robot.visitedPositions.length;
  }

  @override
  int solvePart2() {
    final grid = parseInput();

    // Create custom cell types (optional)
    final customCellTypes = [
      const CellType('.', 'Empty space', CellBehavior.clear),
      const CellType('#', 'Obstical', CellBehavior.blocking),
      const CellType('^', 'Start', CellBehavior.start),
    ];

    // Create a robot
    final robot = Robot(
      facing: Direction.up,
      grid: grid,
      cellTypes: customCellTypes,
    );

    // // Print the grid
    // print(grid.toStringWithCoordinates());

    var loopChances = runRunRobot(grid, robot);
    //print(robot.getPathMap(withCoordinates: true));

    return loopChances;
  }

  // returns when the loop is found, if no loop found, returns count of all
  // potential loops up to that point.
  int runRunRobot(Grid2D grid, Robot robot, {bool blockAdded = false}) {
    var loopChances = 0;

    var nextPosition = robot.lookAhead();
    while (nextPosition != '!') {
      switch (nextPosition) {
        case '#':
          // check if we are surrounded by bad moves
          bool isBlocked(Point position) =>
              grid.getAt(position.row, position.col) == '#';
          if (grid.getNeighbors(robot.position).every(isBlocked)) {
            return 0;
          }

          robot.turnRight();

          // check here if we are in a loop
          if (robot.isAheadVisited() &&
              robot.visitHistory.contains(
                PositionState(robot.getAheadPosition(), robot.facing),
              )) {
            // then we are in a loop
            //print(robot.getPathMap(withCoordinates: true));
            return loopChances + 1;
          }

        case '^' || '.':
          // since robot can move forward, we are going to put a block there
          // and then simulate what would happen, then after that returns, keep
          // going

          // simulate the blocked move, add a block to the map,
          // and run the robot from that spot.
          if (!blockAdded) {
            final newGrid = Grid2D.fromString(grid.toString());
            final nextSpot = robot.getAheadPosition();
            newGrid.setAt(nextSpot.row, nextSpot.col, '#');
            final newRobot = Robot.from(robot, newGrid: newGrid);
            loopChances += runRunRobot(newGrid, newRobot, blockAdded: true);
          }

          // and keep going on the first path.
          if (!robot.moveForward()) {
            print('Can not move for some reason');
          }
        default:
          print('found something wierd! $nextPosition');
          break;
      }
      nextPosition = robot.lookAhead();
    }

    return loopChances;
  }
}
