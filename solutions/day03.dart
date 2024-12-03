import '../utils/index.dart';

class Day03 extends GenericDay {
  Day03() : super(3);

  @override
  String parseInput() {
    return input.asString;
  }

  List<(int, int)> findValidMuls(String input) {
    // This pattern matches:
    // - 'mul(' exactly
    // - followed by 1-3 digits
    // - followed by exactly one comma
    // - followed by 1-3 digits
    // - followed by exactly one ')'
    final pattern = RegExp(r'mul\((\d{1,3}),(\d{1,3})\)');

    List<(int, int)> results = [];

    // Find all matches in the input string
    for (final match in pattern.allMatches(input)) {
      // match.group(1) is the first number, match.group(2) is the second number
      final num1 = int.parse(match.group(1)!);
      final num2 = int.parse(match.group(2)!);
      results.add((num1, num2));
    }

    return results;
  }

  String removeBetweenDontAndDo(String input) {
    // removed it all, but added something, as otherwise, it could result in incorrect results
    // so like muldon't()blahblahdo()(6,5) => mul(6,5) if we didn't insert anything, so added a space.
    final pattern =
        RegExp(r"(don't\(\))(.*?)(do\(\))", multiLine: true, dotAll: true);

    // Replace all matches with just the markers
    return input.replaceAllMapped(pattern, (match) => ' ');
  }

  @override
  int solvePart1() {
    final input = parseInput();

    final muls = findValidMuls(input);

    // Calculate sum of multiplications
    int sum = 0;
    for (final (num1, num2) in muls) {
      sum += num1 * num2;
    }
    return sum;
  }

  @override
  int solvePart2() {
    final input = removeBetweenDontAndDo(parseInput());

    final muls = findValidMuls(input);

    // Calculate sum of multiplications
    int sum = 0;
    for (final (num1, num2) in muls) {
      sum += num1 * num2;
    }
    return sum;
  }
}
