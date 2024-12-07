
# Grid2D

## Example usage

```
// Usage example:
void main() {
  // Create from multi-line string
  final gridString = '''
ABC
DEF
GHI
''';
  var grid = Grid2D.fromString(gridString);
  
  // Create from list of strings
  var grid2 = Grid2D.fromStrings(['ABC', 'DEF', 'GHI']);
  
  // Create empty grid
  var grid3 = Grid2D(3, 3, fill: '.');
  
  // Basic operations
  print(grid.getAt(0, 0));  // prints 'A'
  grid.setAt(0, 0, 'X');
  
  // Using points
  var point = Point(1, 1);
  print(grid.getAtPoint(point));  // prints 'E'
  
  // Find string
  var results = grid.findString('DEF');
  for (var (start, dir) in results) {
    print('Found at ${start} going ${dir}');
  }
  
  // Get neighbors
  var neighbors = grid.getNeighbors(Point(1, 1));
  print('Neighbors of (1,1): $neighbors');
  
  // Print grid
  print('\nGrid:');
  grid.print();

  var grid = Grid2D(5, 5);
  var currentPos = Point(2, 2);
  
  // Using the extension method
  var nextPos = currentPos.move(Direction.right);
  print('Moved from $currentPos to $nextPos');
  
  // Using the operator
  var diagPos = currentPos + Direction.downRight;
  print('Moved diagonally to $diagPos');
  
  // Using the Grid2D method (with bounds checking)
  var newPos = grid.moveFrom(currentPos, Direction.right);
  if (newPos != null) {
    print('Safely moved to $newPos');
  }
  
  // You can chain movements
  var finalPos = currentPos
    .move(Direction.right)
    .move(Direction.down);
  print('Moved twice to $finalPos');
}
```