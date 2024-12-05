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
}

extension PointOperations on Point {
  Point move(Direction direction) {
    return Point(row + direction.rowDelta, col + direction.colDelta);
  }

  // Optionally, you could add operator overloading
  Point operator +(Direction direction) {
    return move(direction);
  }
}
