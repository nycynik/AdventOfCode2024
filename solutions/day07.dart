import 'dart:math';

import '../utils/index.dart';

typedef InputPair = ({int key, List<int> values});

class Day07 extends GenericDay {
  Day07() : super(7);

  @override
  List<InputPair> parseInput() {
    final inputList = input.getPerLine();
    final returnData = <InputPair>[];

    for (final line in inputList) {
      if (line.isEmpty) continue;

      final entry = line.split(':');
      final answer = int.parse(entry[0]);
      final inputs =
          entry[1].trim().split(' ').map((s) => int.parse(s.trim())).toList();
      returnData.add((key: answer, values: inputs));
    }
    return returnData;
  }

  @override
  int solvePart1() {
    var validOperations = ['*', '+'];

    var data = parseInput();
    var sum = 0;

    for (final pair in data) {
      if (canFindAMathSolution(pair, validOperations)) {
        sum += pair.key;
      }
    }
    return sum;
  }

  @override
  int solvePart2() {
    var validOperations = ['*', '+', '||'];
    var data = parseInput();
    var sum = 0;

    for (final pair in data) {
      if (canFindAMathSolution(pair, validOperations)) {
        sum += pair.key;
      }
    }
    return sum;
  }

  List<List<String>> generateOperationCombinations(
      List<String> operations, int length) {
    final result = <List<String>>[];
    final total = pow(operations.length, length);

    for (var i = 0; i < total; i++) {
      final combination = <String>[];
      var num = i;

      for (var j = 0; j < length; j++) {
        combination.add(operations[num % operations.length]);
        num ~/= operations.length;
      }

      result.add(combination);
    }

    return result;
  }

  bool canFindAMathSolution(InputPair pair, List<String> operations) {
    var outcomes = <int>[];
    var solutionFound = false;

    for (final combination
        in generateOperationCombinations(operations, pair.values.length - 1)) {
      var result = pair.values[0];
      for (var i = 0; i < pair.values.length - 1; i++) {
        switch (combination[i]) {
          case '*':
            result *= pair.values[i + 1];
          case '+':
            result += pair.values[i + 1];
          case '||':
            result = int.parse('$result${pair.values[i + 1]}');
        }
      }
      outcomes.add(result);
      if (result == pair.key) {
        solutionFound = true;
      }
    }
    return solutionFound;
    //  outcomes.contains(pair.key);
  }
}
