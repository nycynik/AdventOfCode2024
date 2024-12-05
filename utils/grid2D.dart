import 'point.dart';

/*
 * Grid2D
 * 
 * A basic 2D grid class.
 * 
 * // Usage example:
 *
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
  grid.printGrid();
}
 */
// Define direction enum for searching
enum Direction {
  up(-1, 0),
  down(1, 0),
  left(0, -1),
  right(0, 1),
  upRight(-1, 1),
  upLeft(-1, -1),
  downRight(1, 1),
  downLeft(1, -1);

  final int rowDelta;
  final int colDelta;
  const Direction(this.rowDelta, this.colDelta);

  bool isOpposite(Direction other) {
    return rowDelta == -other.rowDelta && colDelta == -other.colDelta;
  }

  bool isPerpendicular(Direction other) {
    // Using dot product: perpendicular vectors have dot product of 0
    return (rowDelta * other.rowDelta + colDelta * other.colDelta) == 0;
  }

  bool get isDiagonal => rowDelta != 0 && colDelta != 0;
}

class Grid2D {
  late List<List<String>> _grid;
  final int rows;
  final int cols;

  Grid2D(this.rows, this.cols, {String fill = '.'}) {
    _grid = List.generate(
      rows,
      (i) => List.generate(cols, (j) => fill),
    );
  }

  // Create from list of strings
  Grid2D.fromStrings(List<String> lines)
      : rows = lines.length,
        cols = lines[0].length {
    _grid = lines.map((line) => line.split('')).toList();

    // Validate all rows have same length
    if (!_grid.every((row) => row.length == cols)) {
      throw ArgumentError('All rows must have the same length');
    }
  }

  // Create from single multi-line string
  factory Grid2D.fromString(String input) {
    return Grid2D.fromStrings(input.trim().split('\n'));
  }

  // Basic operations
  String getAt(int row, int col) {
    if (!_isInBounds(row, col)) return '';
    return _grid[row][col];
  }

  String getAtPoint(Point p) => getAt(p.row, p.col);

  void setAt(int row, int col, String value) {
    if (!_isInBounds(row, col)) return;
    _grid[row][col] = value;
  }

  void setAtPoint(Point p, String value) => setAt(p.row, p.col, value);

  bool _isInBounds(int row, int col) {
    return row >= 0 && row < rows && col >= 0 && col < cols;
  }

  // Find a string in the grid, returns list of (starting point, direction) pairs
  List<(Point, Direction)> findString(String target) {
    List<(Point, Direction)> results = [];

    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        for (Direction dir in Direction.values) {
          if (_checkStringAt(row, col, target, dir)) {
            results.add((Point(row, col), dir));
          }
        }
      }
    }

    return results;
  }

  bool _checkStringAt(
      int startRow, int startCol, String target, Direction dir) {
    if (target.isEmpty) return true;

    int row = startRow;
    int col = startCol;

    for (int i = 0; i < target.length; i++) {
      if (!_isInBounds(row, col) || _grid[row][col] != target[i]) {
        return false;
      }
      row += dir.rowDelta;
      col += dir.colDelta;
    }

    return true;
  }

  // Get neighbors of a point
  List<Point> getNeighbors(Point p, {bool includeDiagonals = false}) {
    List<Point> neighbors = [];
    List<Direction> directions = includeDiagonals
        ? Direction.values
        : [Direction.up, Direction.down, Direction.left, Direction.right];

    for (var dir in directions) {
      int newRow = p.row + dir.rowDelta;
      int newCol = p.col + dir.colDelta;
      if (_isInBounds(newRow, newCol)) {
        neighbors.add(Point(newRow, newCol));
      }
    }

    return neighbors;
  }

  // Move around the grid
  Point? moveFrom(Point start, Direction direction) {
    final newPoint = start.move(direction);
    // Return null if the new point would be out of bounds
    return _isInBounds(newPoint.row, newPoint.col) ? newPoint : null;
  }

  // Print the grid
  void printGrid() {
    for (var row in _grid) {
      print(row.join());
    }
  }

  // Convert grid to string
  @override
  String toString() {
    return _grid.map((row) => row.join()).join('\n');
  }
}
