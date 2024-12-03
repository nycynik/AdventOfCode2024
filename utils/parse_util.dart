class ParseUtil {
  /// Throws an exception if any given String is not parseable.
  static List<int> stringListToIntList(List<String> strings) {
    return strings.map(int.parse).toList();
  }

  /// Returns decimal number from binary string
  static int binaryToDecimal(String binary) {
    return int.parse(binary, radix: 2);
  }

  /* 
  ** Transpose a list
  **
  ** // Usage:
  ** List<List<int>> rows = getPerLineAsInts();
  ** List<List<int>> columns = transpose(rows);
  */
  List<List<T>> transpose<T>(List<List<T>> lists) {
    if (lists.isEmpty || lists[0].isEmpty) return [];

    return List.generate(
        lists[0].length, (i) => lists.map((row) => row[i]).toList());
  }


}
