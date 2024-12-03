import '../utils/index.dart';

class Day01 extends GenericDay {
  Day01() : super(1);

  @override
  List<List<int>> parseInput() {
    var locations = input.getPerLine();
    print(locations.length);

    List<int> left = [];
    List<int> right = [];

    for (var x = 0; x < locations.length; x++) {
      // split location into two numbers, and sum them
      var location = locations[x].split(' ');
      left.add(int.parse(location[0]));
      right.add(int.parse(location[location.length - 1]));
    }
    left.sort();
    right.sort();
    return [left, right];
  }

  @override
  int solvePart1() {
    List<List<int>> totals = parseInput();
    int totalDiff = 0;

    for (var x = 0; x < totals[0].length; x++) {
      totalDiff += (totals[1][x] - totals[0][x]).abs();
    }
    return totalDiff;
  }

  @override
  int solvePart2() {
    List<List<int>> totals = parseInput();
    int totalDiff = 0;

    for (var x = 0; x < totals[0].length; x++) {
      var leftVal = totals[0][x];
      // count occurances of leftVal in totals[1]
      int countOfRight = totals[1].where((number) => number == leftVal).length;

      int similarityScore = leftVal * countOfRight;
      totalDiff += similarityScore;
    }

    return totalDiff;
  }
}
