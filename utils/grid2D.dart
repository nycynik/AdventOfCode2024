import 'point.dart';

/*
 * Grid2D
 * 
 * A basic 2D grid class.
 * 
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
  final Map<String, int> spaceTypes = {};

  Grid2D(this.rows, this.cols, {String fill = '.'}) {
    _grid = List.generate(
      rows,
      (i) => List.generate(cols, (j) => fill),
    );
    spaceTypes[fill] = rows * cols;
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

    // Count occurrences of each character
    for (var row in _grid) {
      for (var char in row) {
        spaceTypes[char] = (spaceTypes[char] ?? 0) + 1;
      }
    }
  }

  // Create from single multi-line string
  factory Grid2D.fromString(String input) {
    return Grid2D.fromStrings(input.trim().split('\n'));
  }

  // copy
  Grid2D copy() {
    // Create a new grid with copied rows
    return Grid2D.fromString(toString());
  }

  // getters & setters
  Set<String> get characters => spaceTypes.keys.toSet();
  int getCharCount(String char) => spaceTypes[char] ?? 0;

  // Basic operations
  String getAt(int row, int col) {
    if (!isInBounds(row, col)) return '';
    return _grid[row][col];
  }

  String getAtPoint(Point p) => getAt(p.row, p.col);

  void setAt(int row, int col, String value) {
    if (!isInBounds(row, col)) return;
    _grid[row][col] = value;
  }

  void setAtPoint(Point p, String value) => setAt(p.row, p.col, value);

  bool isInBounds(int row, int col) {
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
      if (!isInBounds(row, col) || _grid[row][col] != target[i]) {
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
      if (isInBounds(newRow, newCol)) {
        neighbors.add(Point(newRow, newCol));
      }
    }

    return neighbors;
  }

  List<Point> findInstances(String target) {
    List<Point> results = [];

    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        if (_grid[row][col] == target) {
          results.add(Point(row, col));
        }
      }
    }

    return results;
  }

  // Move around the grid
  Point? moveFrom(Point start, Direction direction) {
    final newPoint = start.move(direction);
    // Return null if the new point would be out of bounds
    return isInBounds(newPoint.row, newPoint.col) ? newPoint : null;
  }

  /* Distance between two points ***********************************/
  // Check if the distance calculation is valid within grid bounds
  bool canReach(Point from, Point to, {int maxDistance = 1}) {
    if (!isValidPoint(from) || !isValidPoint(to)) return false;
    return from.manhattanDistance(to) <= maxDistance;
  }

  // Get all points within a certain distance
  List<Point> getPointsWithinDistance(Point center, int distance) {
    final points = <Point>[];

    for (var r = -distance; r <= distance; r++) {
      for (var c = -distance; c <= distance; c++) {
        final point = Point(center.row + r, center.col + c);
        if (isValidPoint(point) &&
            center.manhattanDistance(point) <= distance) {
          points.add(point);
        }
      }
    }

    return points;
  }

  // Helper method to check if a point is within grid bounds
  bool isValidPoint(Point p) {
    return p.row >= 0 && p.row < rows && p.col >= 0 && p.col < cols;
  }

  /* Print and display the grid ************************************/
  // Print the grid
  void printGrid() {
    for (final row in _grid) {
      print(row.join());
    }
  }

  String toStringWithCoordinates({
    bool showTens = false,
    String padding = ' ',
    bool showRowNumbers = true,
  }) {
    final buffer = StringBuffer();

    if (showTens && cols > 10) {
      buffer.write('   ');
      for (var col = 0; col < cols; col++) {
        buffer.write(col ~/ 10 > 0 ? (col ~/ 10).toString() : padding);
      }
      buffer.writeln();
    }

    buffer.write('  ');
    for (var col = 0; col < cols; col++) {
      buffer.write(col % 10);
    }
    buffer.writeln();

    for (var row = 0; row < rows; row++) {
      if (showRowNumbers) {
        if (row < 10) {
          buffer.write('$row ');
        } else {
          buffer.write(row);
        }
      }

      for (var col = 0; col < cols; col++) {
        buffer.write(getAt(row, col));
      }
      buffer.writeln();
    }

    return buffer.toString();
  }

  // Convert grid to string
  @override
  String toString() {
    return _grid.map((row) => row.join()).join('\n');
  }
}
