import '../utils/grid2D.dart';
import '../utils/index.dart';
import '../utils/point.dart';

class Day04 extends GenericDay {
  Day04() : super(4);

  @override
  Grid2D parseInput() {
    final grid = Grid2D.fromString(input.asString);
    return grid;
  }

  @override
  int solvePart1() {
    final grid = parseInput();

    final XMASStringsFound = grid.findString('XMAS');

    return XMASStringsFound.length;
  }

  @override
  int solvePart2() {
    final grid = parseInput();

    final XMASStringsFound = grid.findString('MAS');
    var foundOverlaps = 0;

    // searching for any a second XMAS string that the second character is
    // the second character of both.
    for (var i = 0; i < XMASStringsFound.length; i++) {
      for (var j = i + 1; j < XMASStringsFound.length; j++) {
        // get the next character in the found A's location for both i and j indexed Strings
        var iNextPos = XMASStringsFound[i].$1.move(XMASStringsFound[i].$2);
        var jNextPos = XMASStringsFound[j].$1.move(XMASStringsFound[j].$2);
        if (i != j && // not the same point
            iNextPos == jNextPos && // both have an the same second char (A)
            XMASStringsFound[i].$2.isDiagonal &&
            XMASStringsFound[j].$2.isDiagonal) {
          // print('Found that:');
          // print('${XMASStringsFound[i].$1} moving ${XMASStringsFound[i].$2}');
          // print('${XMASStringsFound[j].$1} moving ${XMASStringsFound[j].$2}');
          // print(
          //     '${grid.getAtPoint(XMASStringsFound[i].$1)}${grid.getAtPoint(iNextPos)}');
          // print(
          //     '${grid.getAtPoint(XMASStringsFound[j].$1)}${grid.getAtPoint(jNextPos)}');
          // print('${iNextPos} ${jNextPos} overlap.\n');

          foundOverlaps++;
        }
      }
    }

    return foundOverlaps;
  }
}
