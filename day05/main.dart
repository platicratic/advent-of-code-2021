import 'dart:io';
import 'dart:math';

void printOverlaps(List<List<int>> floor) {
  int overlap = 0;
  for (int i = 0; i < 1000; i++) {
    for (int j = 0; j < 1000; j++) {
      if (floor[i][j] > 1) {
        overlap++;
      }
    }
  }
  print(overlap);
}

void partOne(List<List<String>> coordinates) {
  List<List<int>> floor = List.generate(1000, (_) => List.generate(1000, (_) => 0), growable: false);
  for (List<String> coordinate in coordinates) {
    int x1 = int.parse(coordinate[0].split(',')[0]);
    int y1 = int.parse(coordinate[0].split(',')[1]);
    int x2 = int.parse(coordinate[1].split(',')[0]);
    int y2 = int.parse(coordinate[1].split(',')[1]);
    if (x1 == x2 || y1 == y2) {
      for (int i = min(x1, x2); i <= max(x1, x2); i++) {
        for (int j = min(y1, y2); j <= max(y1, y2); j++) {
          floor[j][i] += 1;
        }
      }
    }
  }

  printOverlaps(floor);
}

void partTwo(List<List<String>> coordinates) {
  List<List<int>> floor = List.generate(1000, (_) => List.generate(1000, (_) => 0), growable: false);
  for (List<String> coordinate in coordinates) {
    int x1 = int.parse(coordinate[0].split(',')[0]);
    int y1 = int.parse(coordinate[0].split(',')[1]);
    int x2 = int.parse(coordinate[1].split(',')[0]);
    int y2 = int.parse(coordinate[1].split(',')[1]);
    if (x1 != x2 && y1 != y2) {
      for (int i = x1, j = y1; i != x2 && j != y2; i += (x1 < x2 ? 1 : -1), j += (y1 < y2 ? 1 : -1)) {
        floor[i][j] += 1;
      }
      floor[x2][y2] += 1;
    } else {
      for (int i = min(x1, x2); i <= max(x1, x2); i++) {
        for (int j = min(y1, y2); j <= max(y1, y2); j++) {
          floor[i][j] += 1;
        }
      }
    }
  }

  printOverlaps(floor);
}

void main() {
  List<List<String>> coordinates =
      File('input.txt').readAsLinesSync().map((String line) => line.split(' -> ')).toList();
  partOne(coordinates);
  partTwo(coordinates);
}
