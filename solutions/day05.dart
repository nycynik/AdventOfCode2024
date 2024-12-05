import '../utils/index.dart';

class PrintData {
  final Map<int, List<int>> preceedingRules;
  final Map<int, List<int>> postRules;
  final List<List<int>> updates;

  PrintData({
    required this.preceedingRules,
    required this.postRules,
    required this.updates,
  });

  // Named constructor
  PrintData.empty()
      : preceedingRules = {},
        postRules = {},
        updates = [];
}

class Day05 extends GenericDay {
  Day05() : super(5);

  @override
  PrintData parseInput() {
    var lines = input.getPerLine();
    var preceedingRules = <int, List<int>>{};
    var postRules = <int, List<int>>{};
    var updates = <List<int>>[];

    var mode = 0;
    for (var line in lines) {
      if (line.isEmpty) {
        mode++;
        continue;
      }
      if (mode == 0) {
        // parse rules
        var rule = line.trim().split('|');
        var key = int.parse(rule[0]);
        var value = int.parse(rule[1].trim());
        if (preceedingRules.containsKey(key)) {
          preceedingRules[key]!.add(value);
        } else {
          preceedingRules[key] = [value];
        }
        if (postRules.containsKey(value)) {
          postRules[value]!.add(key);
        } else {
          postRules[value] = [key];
        }
      } else if (mode == 1) {
        // parse update data
        var update = line.trim().split(',').map((e) => int.parse(e)).toList();
        updates.add(update);
      }
    }
    return PrintData(
        preceedingRules: preceedingRules,
        postRules: postRules,
        updates: updates);
  }

  @override
  int solvePart1() {
    final pd = parseInput();

    // find valid rules
    final validPrintData = <List<int>>[];
    for (final update in pd.updates) {
      // add each valid printdata/book into
      // the final array
      if (isValidEntry(update, pd)) {
        validPrintData.add(update);
      }
    }

    if (validPrintData.isEmpty) {
      return 0;
    }

    // sum middles of valid rules
    var sum = 0;
    for (final update in validPrintData) {
      sum += update[update.length ~/ 2];
      //print(update);
    }

    return sum;
  }

  bool isValidEntry(List<int> update, PrintData pd) {
    var valid = true;

    // for each entry in the update, validate
    // that there is no rule that includes
    // the page can come after the first page
    for (var i = 0; i < update.length; i++) {
      final entry = update[i];
      //var tested = update[i].toString();
      if (pd.preceedingRules.containsKey(entry)) {
        //tested += ' fwd:';
        // validate each entry in the update
        // against the rules
        for (var j = i + 1; j < update.length; j++) {
          //tested += update[j].toString() + ',';
          if (!pd.preceedingRules[entry]!.contains(update[j])) {
            valid = false;
            break;
          }
        }
      }
      if (pd.postRules.containsKey(entry)) {
        //tested += ' back:';
        for (var j = i - 1; j >= 0; j--) {
          //tested += update[j].toString() + ',';
          if (!pd.postRules[entry]!.contains(update[j])) {
            valid = false;
            break;
          }
        }
      }
      //print(tested);
    }
    return valid;
  }

  @override
  int solvePart2() {
    final pd = parseInput();

    // find valid rules
    final inValidPrintData = <List<int>>[];
    for (final update in pd.updates) {
      // add each valid printdata/book into
      // the final array
      if (!isValidEntry(update, pd)) {
        inValidPrintData.add(fixEntry(pd, update));
      }
    }

    if (inValidPrintData.isEmpty) {
      return 0;
    }

    // sum middles of valid rules
    var sum = 0;
    for (final update in inValidPrintData) {
      sum += update[update.length ~/ 2];
      //print(update);
    }

    return sum;
  }

  // for an invalid entry, swap the invalid entries
  // until it's valid.
  List<int> fixEntry(PrintData pd, List<int> update) {
    // guards
    if (update.isEmpty) return update;

    // fix preceedings
    var iteration = 0;
    // we need foundFix because we are testing if valid, but only fixing one
    // set of rules. So it's possible we can't fix it yet, but we don't need
    // to continue.
    var foundFix = false;
    do {
      foundFix = false;
      // iterate over the entry, finding the first invalid entry
      for (var i = 0; i < update.length; i++) {
        final entry = update[i];
        if (pd.preceedingRules.containsKey(entry)) {
          // validate each entry in the update
          // against the rules
          for (var j = i + 1; j < update.length; j++) {
            if (!pd.preceedingRules[entry]!.contains(update[j])) {
              // swap the entries
              update[i] = update[j];
              update[j] = entry;
              foundFix = true;
              break;
            }
          }
        }
      }

      iteration++;
      if (iteration > 100) {
        print('pre iteration exceeded 100');
        break;
      }
    } while (foundFix && !isValidEntry(update, pd));

    // fix post rules
    iteration = 0;
    foundFix = false; // we really don't need foundFix for this part
    do {
      foundFix = false;
      // iterate over the entry, finding the first invalid entry
      for (var i = 0; i < update.length; i++) {
        final entry = update[i];
        if (pd.postRules.containsKey(entry)) {
          // validate each entry in the update
          // against the rules
          for (var j = i - 1; j >= 0; j--) {
            if (!pd.postRules[entry]!.contains(update[j])) {
              // swap the entries
              update[i] = update[j];
              update[j] = entry;
              foundFix = true;
              break;
            }
          }
        }
      }

      iteration++;
      if (iteration > 100) {
        print('iteration exceeded 100');
        break;
      }
    } while (foundFix && !isValidEntry(update, pd));

    return update;
  }
}
