import '../utils/index.dart';

typedef InputPair = ({int key, List<int> values});

class Day07 extends GenericDay {
  Day07() : super(7);

  @override
  List<InputPair> parseInput() {
    final inputList = input.getPerLine();
    final returnData = <InputPair>[];

    // for (final line in inputList) {
    //   print(line);
    //   final entry = line.split(':');
    //   final answer = int.parse(entry[0]);
    //   final inputs =
    //       entry[1].split(' ').map((s) => int.parse(s.trim())).toList();
    //   returnData.add((key: answer, values: inputs));
    // }
    return returnData;
  }

  @override
  int solvePart1() {
    var data = parseInput();

    for (final pair in data) {
      print('Key: ${pair.key}, Values: ${pair.values}');
    }
    return 0;
  }

  @override
  int solvePart2() {
    //var data = parseInput();
    return 0;
  }
}
