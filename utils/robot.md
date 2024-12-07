# Robot

A virtual robot class that can move around a Grid2D.

## Example usage

```
// Example usage:
void main() {
  // Create a sample grid
  final gridString = '''
...#.
.#...
.....
G....
#.#..
''';
  
  final grid = Grid2D.fromString(gridString);
  
  // Create custom cell types (optional)
  final customCellTypes = [
    CellType('.', 'Empty space', CellBehavior.clear),
    CellType('#', 'Wall', CellBehavior.blocking),
    CellType('G', 'Goal', CellBehavior.goal),
    CellType('*', 'Special', CellBehavior.clear),
  ];
  
  // Create a robot
  final robot = Robot(
    position: Point(0, 0),
    facing: Direction.right,
    grid: grid,
    cellTypes: customCellTypes,
  );
  
  // Move the robot
  print(robot);  // Initial position
  
  robot.moveForward();
  print(robot);  // Moved one space right
  
  robot.turnRight();
  print(robot);  // Now facing down
  
  // Try to move into a wall
  final moved = robot.moveForward();
  print('Move successful: $moved');  // false if wall blocked movement
  
  // Execute a sequence of commands
  void executeCommands(Robot robot, String commands) {
    for (final command in commands.split('')) {
      switch (command) {
        case 'F': robot.moveForward();
        case 'L': robot.turnLeft();
        case 'R': robot.turnRight();
        default: print('Unknown command: $command');
      }
    }
  }
  
  executeCommands(robot, 'FFLRF');
  print('Final position: $robot');
  print('Reached goal: ${robot.isAtGoal()}');
}
```

### Display the grid

You can just get hte grid as a string, or there is a dedicated print mechanism. 

```
// Usage with options:
print(grid.toStringWithCoordinates(
  showTens: true,
  padding: ' ',
  showRowNumbers: true,
));
```