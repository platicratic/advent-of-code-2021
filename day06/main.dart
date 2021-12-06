import 'dart:io';

void partOne(List<int> lanternfish) {
  for (int i = 0; i < 80; i++) {
    int size = lanternfish.length;
    for (int j = 0; j < size; j++) {
      lanternfish[j]--;
      if (lanternfish[j] < 0) {
        lanternfish[j] = 6;
        lanternfish.add(8);
      }
    }
  }

  print(lanternfish.length);
}

void partTwo(List<int> lanternfish) {
  List<int> F = List.generate(11, (_) => 0, growable: false);
  for (int timer in lanternfish) F[timer] += 1;

  for (int i = 0; i < 256; i++) {
    F[9] = F[0];
    F[7] += F[0];
    for (int j = 0; j < 10; j++) {
      F[j] = F[j + 1];
    }
  }

  print(F.reduce((value, element) => value + element));
}

void main() {
  List<int> lanternfish =
      File('input.txt').readAsLinesSync()[0].split(',').map((String item) => int.parse(item)).toList();

  partOne([...lanternfish]);
  partTwo([...lanternfish]);
}
