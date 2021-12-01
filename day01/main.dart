import 'dart:io';

void PartOne(List<int> depths) {
  int count = 0;
  for (int i = 1; i < depths.length; i++) {
    if (depths[i] > depths[i - 1]) {
      count++;
    }
  }

  print(count);
}

void PartTwo(List<int> depths) {
  List<int> threeSumDepths = [];
  for (int i = 0; i < depths.length - 2; i++) {
    threeSumDepths.add(depths[i] + depths[i + 1] + depths[i + 2]);
  }
  PartOne(threeSumDepths);
}

void main() {
  List<int> depths = File('input.txt').readAsLinesSync().map((String item) => int.parse(item)).toList();
  PartOne(depths);
  PartTwo(depths);
}
