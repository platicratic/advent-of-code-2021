import 'dart:io';
import 'dart:math';

void partOne(String formula, Map<String, String> template, int steps) {
  while (steps-- != 0) {
    String newFormula = '';
    for (int i = 0; i < formula.length - 1; i++) {
      newFormula += formula[i] + template[formula[i] + formula[i + 1]]!;
    }
    formula = newFormula + formula[formula.length - 1];
  }

  List<int> F = List.generate(26, (_) => 0);
  formula.codeUnits.forEach((int charCode) {
    F[charCode - 'A'.codeUnitAt(0)]++;
  });
  F.removeWhere((int f) => f == 0);
  F.sort();
  print(F.last - F.first);
}

void partTwo(String formula, Map<String, String> template, int steps) {
  Map<String, int> pairs = {};
  for (int i = 0; i < formula.length - 1; i++) {
    pairs[formula[i] + formula[i + 1]] =
        (pairs[formula[i] + formula[i + 1]] != null ? pairs[formula[i] + formula[i + 1]]! + 1 : 1);
  }

  while (steps-- != 0) {
    Map<String, int> newPairs = {};
    pairs.forEach((String key, int value) {
      newPairs[key[0] + template[key]!] =
          (newPairs[key[0] + template[key]!] != null ? newPairs[key[0] + template[key]!]! + value : value);
      newPairs[template[key]! + key[1]] =
          (newPairs[template[key]! + key[1]] != null ? newPairs[template[key]! + key[1]]! + value : value);
    });
    pairs = {...newPairs};
  }

  Map<String, int> F = {};
  pairs.forEach((String key, int value) {
    F[key[0]] = (F[key[0]] != null ? F[key[0]]! + value : value);
    F[key[1]] = (F[key[1]] != null ? F[key[1]]! + value : value);
  });

  int small = 0x3f3f3f3f3f3f3f3f, big = 0;
  F.forEach((key, value) {
    big = max(big, (value ~/ 2) + (key == formula[0] || key == formula[formula.length - 1] ? 1 : 0));
    small = min(small, (value ~/ 2) + (key == formula[0] || key == formula[formula.length - 1] ? 1 : 0));
  });
  print((big - small));
}

void main() {
  List<String> lines = File('input.txt').readAsLinesSync();
  String formula = lines[0];
  Map<String, String> template = {};
  lines.skip(2).forEach((String line) {
    List<String> each = line.split(' -> ');
    template[each[0]] = each[1];
  });

  partOne(formula, template, 10);
  partTwo(formula, template, 40);
}
