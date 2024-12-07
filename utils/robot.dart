// CellType class to define what different cells mean
import 'package:meta/meta.dart';

import 'grid2D.dart';
import 'point.dart';

// CellTypes - what the robot thinks the grid pos is.
class CellType {
  final String symbol;
  final String description;
  final CellBehavior behavior;

  const CellType(this.symbol, this.description, this.behavior);
}

enum CellBehavior { clear, blocking, start, goal }

@immutable
class PositionState {
  final Point position;
  final Direction facing;

  const PositionState(this.position, this.facing);

  @override
  String toString() => 'PositionState(pos: $position, facing: $facing)';

  // to compare states
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PositionState &&
          position == other.position &&
          facing == other.facing;

  @override
  int get hashCode => Object.hash(position, facing);
}

// MAiN ROBO+ CLASS
class Robot {
  Point position;
  Direction facing;
  final Grid2D grid;
  final List<CellType> cellTypes;
  final Set<Point> visitedPositions = {};
  final List<PositionState> visitHistory = [];

  // Default cell types if none provided
  static final List<CellType> defaultCellTypes = [
    const CellType('.', 'Clear space', CellBehavior.clear),
    const CellType('#', 'Wall', CellBehavior.blocking),
    const CellType('G', 'Goal', CellBehavior.goal),
    const CellType('S', 'Start', CellBehavior.start),
    const CellType('*', 'Visited', CellBehavior.clear),
    const CellType('!', 'OffGrid', CellBehavior.blocking),
  ];

  Robot({
    Point? initialPosition,
    required this.facing,
    required this.grid,
    List<CellType>? cellTypes,
  })  : cellTypes = cellTypes ?? defaultCellTypes,
        position = initialPosition ?? const Point(0, 0) {
    if (initialPosition == null) {
      if (!findStartingPoint()) {
        throw ArgumentError(
          'No starting position provided and no start cell found on grid',
        );
      }
    } else if (!_isValidPosition(initialPosition)) {
      throw ArgumentError('Invalid initial position: $initialPosition');
    }

    // Mark initial position as visited
    visitedPositions.add(position);
    visitHistory.add(PositionState(position, facing));
  }

  // Copy constructor with optional new grid
  Robot.from(Robot other, {Grid2D? newGrid})
      : position = other.position,
        facing = other.facing,
        grid = newGrid ?? Grid2D.fromString(other.grid.toString()),
        cellTypes = List.from(other.cellTypes) {
    visitedPositions.addAll(other.visitedPositions);
    visitHistory.addAll(other.visitHistory);
  }

  // Movement methods
  bool moveForward() {
    final nextPosition = position.move(facing);

    if (_canMoveTo(nextPosition)) {
      position = nextPosition;
      visitedPositions.add(position);
      visitHistory.add(PositionState(position, facing));
      return true;
    }
    return false;
  }

  void turnLeft() {
    facing = switch (facing) {
      Direction.up => Direction.left,
      Direction.left => Direction.down,
      Direction.down => Direction.right,
      Direction.right => Direction.up,
      _ => facing, // Handle diagonal directions if needed
    };
    // Record state after turn
    visitHistory.add(PositionState(position, facing));
  }

  void turnRight() {
    facing = switch (facing) {
      Direction.up => Direction.right,
      Direction.right => Direction.down,
      Direction.down => Direction.left,
      Direction.left => Direction.up,
      _ => facing, // Handle diagonal directions if needed
    };
    // Record state after turn
    visitHistory.add(PositionState(position, facing));
  }

  // Helper methods
  bool _isValidPosition(Point p) {
    return grid.isInBounds(p.row, p.col);
  }

  bool _canMoveTo(Point p) {
    if (!_isValidPosition(p)) {
      return false;
    }

    final cell = grid.getAt(p.row, p.col);
    return _isClearCell(cell);
  }

  bool _isClearCell(String cell) {
    return cellTypes.where((type) => type.symbol == cell).any((type) =>
        type.behavior == CellBehavior.clear ||
        type.behavior == CellBehavior.start);
  }

  // Status methods
  bool isAtGoal() {
    final currentCell = grid.getAt(position.row, position.col);
    return cellTypes
        .where((type) => type.symbol == currentCell)
        .any((type) => type.behavior == CellBehavior.goal);
  }

  // Move multiple steps forward
  int moveForwardSteps(int steps) {
    int stepsTaken = 0;
    for (var i = 0; i < steps; i++) {
      if (!moveForward()) break;
      stepsTaken++;
    }
    return stepsTaken;
  }

  // Get what's in front of the robot
  String lookAhead() {
    final ahead = position.move(facing);
    if (_isValidPosition(ahead)) {
      return grid.getAt(ahead.row, ahead.col);
    }
    return '!'; // Treat out of bounds as wall
  }

  // check around the robot
  String lookInDirection(Direction dir) {
    final lookDir = position.move(dir);
    if (_isValidPosition(lookDir)) {
      return grid.getAt(lookDir.row, lookDir.col);
    }
    return '!'; // Treat out of bounds as wall
  }

  // Check if movement is possible
  bool canMoveForward() {
    final ahead = position.move(facing);
    return _canMoveTo(ahead);
  }

  // Get surrounding cells
  Map<Direction, String> getSurroundings() {
    final surroundings = <Direction, String>{};
    for (final dir in Direction.values) {
      final pos = position.move(dir);
      surroundings[dir] =
          _isValidPosition(pos) ? grid.getAt(pos.row, pos.col) : '#';
    }
    return surroundings;
  }

  // Clear visited tracking
  void resetVisited() {
    visitedPositions
      ..clear()
      ..add(position);
  }

  // Get statistics about visited locations
  Map<String, int> getVisitedStats() {
    var totalTraversable = 0;

    for (var row = 0; row < grid.rows; row++) {
      for (var col = 0; col < grid.cols; col++) {
        if (_isClearCell(grid.getAt(row, col))) {
          totalTraversable++;
        }
      }
    }

    return {
      'visited': visitedPositions.length,
      'traversable': totalTraversable,
      'coverage': totalTraversable > 0
          ? visitedPositions.length * 100 ~/ totalTraversable
          : 0,
    };
  }

  // Check if a position has been visited
  bool hasVisited(Point p) => visitedPositions.contains(p);

  // Get unvisited adjacent positions
  List<Point> getUnvisitedAdjacent() {
    return Direction.values
        .map((dir) => position.move(dir))
        .where((p) => _isValidPosition(p) && _canMoveTo(p) && !hasVisited(p))
        .toList();
  }

  Point getRelativePosition(Direction relativeDir) {
    // Calculate the absolute direction based on robot's facing and relative direction
    Direction absoluteDir = switch (relativeDir) {
      // Forward - same as current facing
      Direction.up => facing,

      // Right - rotate 90° clockwise
      Direction.right => switch (facing) {
          Direction.up => Direction.right,
          Direction.right => Direction.down,
          Direction.down => Direction.left,
          Direction.left => Direction.up,
          _ => facing,
        },

      // Backward - opposite of current facing
      Direction.down => switch (facing) {
          Direction.up => Direction.down,
          Direction.right => Direction.left,
          Direction.down => Direction.up,
          Direction.left => Direction.right,
          _ => facing,
        },

      // Left - rotate 90° counter-clockwise
      Direction.left => switch (facing) {
          Direction.up => Direction.left,
          Direction.right => Direction.up,
          Direction.down => Direction.right,
          Direction.left => Direction.down,
          _ => facing,
        },
      _ => facing,
    };

    // Return the point one step in that direction
    return position + absoluteDir;
  }

  Point getAheadPosition() => getRelativePosition(Direction.up);
  Point getRightPosition() => getRelativePosition(Direction.right);
  Point getBehindPosition() => getRelativePosition(Direction.down);
  Point getLeftPosition() => getRelativePosition(Direction.left);

  bool isAheadVisited() => visitedPositions.contains(getAheadPosition());
  bool isRightVisited() => visitedPositions.contains(getRightPosition());
  bool isBehindVisited() => visitedPositions.contains(getBehindPosition());
  bool isLeftVisited() => visitedPositions.contains(getLeftPosition());

  // Find starting point on the grid based on CellBehavior.start
  // being found on the grid. If not found, set the starting point
  // to (0, 0) and return false.
  bool findStartingPoint() {
    for (var row = 0; row < grid.rows; row++) {
      for (var col = 0; col < grid.cols; col++) {
        final cell = grid.getAt(row, col);
        if (cellTypes
            .where((type) => type.symbol == cell)
            .any((type) => type.behavior == CellBehavior.start)) {
          position = Point(row, col);
          return true;
        }
      }
    }
    position = const Point(0, 0);
    return false;
  }

  // get visited locations
  String getVisitedMap({
    bool withCoordinates = false,
    String visitedMarker = '•',
    bool showCurrent = true,
  }) {
    var displayGrid = grid.copy();

    // Mark all visited positions
    for (final pos in visitedPositions) {
      displayGrid.setAt(pos.row, pos.col, visitedMarker);
    }

    // Optionally show current position with direction
    if (showCurrent) {
      String directionMarker = switch (facing) {
        Direction.up => '^',
        Direction.down => 'v',
        Direction.left => '<',
        Direction.right => '>',
        _ => 'R',
      };
      displayGrid.setAt(position.row, position.col, directionMarker);
    }

    return withCoordinates
        ? displayGrid.toStringWithCoordinates()
        : displayGrid.toString();
  }

  // Get path visualization
  String getPathMap({bool withCoordinates = false}) {
    var displayGrid = grid.copy();

    // Mark path with direction markers
    for (var state in visitHistory) {
      String marker = switch (state.facing) {
        Direction.up => '↑',
        Direction.down => '↓',
        Direction.left => '←',
        Direction.right => '→',
        _ => '•',
      };
      displayGrid.setAt(state.position.row, state.position.col, marker);
    }

    return withCoordinates
        ? displayGrid.toStringWithCoordinates()
        : displayGrid.toString();
  }

  // Get the movement history as a string
  String getHistoryString() {
    return visitHistory.map((state) {
      final dirSymbol = switch (state.facing) {
        Direction.up => '↑',
        Direction.down => '↓',
        Direction.left => '←',
        Direction.right => '→',
        _ => '•',
      };
      return '(${state.position.row},${state.position.col}):$dirSymbol';
    }).join(' -> ');
  }

  @override
  String toString() => 'Robot at $position facing $facing';

  Direction getRightDirection() {
    return switch (facing) {
      Direction.up => Direction.right,
      Direction.right => Direction.down,
      Direction.down => Direction.left,
      Direction.left => Direction.up,
      _ => facing,
    };
  }

  Direction getLeftDirection() {
    return switch (facing) {
      Direction.up => Direction.left,
      Direction.right => Direction.up,
      Direction.down => Direction.right,
      Direction.left => Direction.down,
      _ => facing,
    };
  }
}
