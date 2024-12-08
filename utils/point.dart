import 'dart:math';

import 'package:meta/meta.dart';

import 'grid2D.dart';

@immutable
class Point {
  // constructor
  const Point(this.row, this.col);

  // members
  final int row;
  final int col;

  @override
  String toString() => '($row, $col)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Point &&
          runtimeType == other.runtimeType &&
          row == other.row &&
          col == other.col;

  @override
  int get hashCode => row.hashCode ^ col.hashCode;

  // operator overloading
  // Add two points
  Point operator +(Point other) {
    return Point(row + other.row, col + other.col);
  }

  // Subtract two points
  Point operator -(Point other) {
    return Point(row - other.row, col - other.col);
  }

  // You might also want to add scalar multiplication
  Point operator *(int scalar) {
    return Point(row * scalar, col * scalar);
  }

  // Add distance calculations
  int manhattanDistance(Point other) {
    return (row - other.row).abs() + (col - other.col).abs();
  }

  int chebyshevDistance(Point other) {
    return max((row - other.row).abs(), (col - other.col).abs());
  }

  double euclideanDistance(Point other) {
    return sqrt(pow(row - other.row, 2) + pow(col - other.col, 2));
  }
}


extension PointOperations on Point {
  Point move(Direction direction) {
    return Point(row + direction.rowDelta, col + direction.colDelta);
  }

  // Add a point and a direction
  Point operator +(Direction direction) {
    return move(direction);
  }
}
