import '../utils/index.dart';

class Day02 extends GenericDay {
  Day02() : super(2);

  @override
  List<List<int>> parseInput() {
    List<List<int>> reports = input.getPerLineAsInts();
    return reports;
  }

  bool checkReportSafety(List<int> report) {
    // verify that it's all asc or all desc.
    // and that any two adjacent levels differ by at least one and at most three.
    bool ascending = report[0] < report[1];
    if (ascending) {
      for (var i = 0; i < report.length - 1; i++) {
        if (report[i] >= report[i + 1]) return false;
        if (report[i + 1] - report[i] > 3) return false;
      }
    } else {
      for (var i = 0; i < report.length - 1; i++) {
        if (report[i] <= report[i + 1]) return false;
        if (report[i] - report[i + 1] > 3) return false;
      }
    }

    return true;
  }

  @override
  int solvePart1() {
    List<List<int>> reports = parseInput();

    // get count of safe reports
    int count = 0;
    for (var i = 0; i < reports.length; i++) {
      if (checkReportSafety(reports[i])) count++;
    }

    return count;
  }

  @override
  int solvePart2() {
    // print(checkReportSafety([7, 6, 4, 2, 1]));
    // print(checkReportSafety([1, 2, 7, 8, 9]));
    // print(checkReportSafety([9, 7, 6, 2, 1]));
    // print(checkReportSafety([1, 3, 2, 4, 5]));
    // print(checkReportSafety([1, 2, 3, 2, 1]));
    // print(checkReportSafety([8, 6, 4, 4, 1]));
    List<List<int>> reports = parseInput();

    // get count of safe reports
    int count = 0;
    for (var i = 0; i < reports.length; i++) {
      if (checkReportSafety(reports[i])) {
        count++;
      } else {
        for (var j = 0; j < reports[i].length; j++) {
          List<int> report = List.from(reports[i]);
          report.removeAt(j);
          if (checkReportSafety(report)) {
            count++;
            break;
          }
        }
      }
    }

    return count;
  }
}
