import 'dart:io';
import 'dart:math';

class Pair {
  int x, y;

  Pair(this.x, this.y);
}

void solve(List<Pair> hot, List<List<String>> folds) {
  int maxJ = 0, maxI = 0;
  folds.forEach((List<String> fold) {
    if (fold[0] == 'y') maxI = max(maxI, (int.parse(fold[1]) << 1) + 1);
    if (fold[0] == 'x') maxJ = max(maxJ, (int.parse(fold[1]) << 1) + 1);
  });

  List<List<bool>> map = List.generate(maxI, (_) => List.generate(maxJ, (_) => false));
  hot.forEach((Pair pair) {
    map[pair.y][pair.x] = true;
  });

  folds.forEach((List<String> fold) {
    if (fold[0] == 'y') {
      int y = int.parse(fold[1]);
      for (int i = 0; i < y; i++) {
        for (int j = 0; j < maxJ; j++) {
          map[i][j] = (map[i][j] || map[maxI - i - 1][j]);
        }
      }
      maxI = y;
    } else {
      int x = int.parse(fold[1]);
      for (int j = 0; j < x; j++) {
        for (int i = 0; i < maxI; i++) {
          map[i][j] = (map[i][j] || map[i][maxJ - j - 1]);
        }
      }
      maxJ = x;
    }
  });

  // partOne
  int count = 0;
  for (int i = 0; i < maxI; i++) {
    for (int j = 0; j < maxJ; j++) {
      if (map[i][j]) {
        count++;
      }
    }
  }
  print(count);

  // partTwo
  for (int i = 0; i < maxI; i++) {
    for (int j = 0; j < maxJ; j++) {
      if (map[i][j]) {
        stdout.write('#');
      } else {
        stdout.write('.');
      }
    }
    stdout.write('\n');
  }
}

void main() {
  List<String> thermal = File('input.txt').readAsLinesSync();
  List<Pair> hot = [];
  while (thermal.first.length > 0) {
    hot.add(Pair(int.parse(thermal.first.split(',')[0]), int.parse(thermal.first.split(',')[1])));
    thermal.removeAt(0);
  }
  List<List<String>> folds = [];
  do {
    thermal.removeAt(0);
    folds.add(thermal.first.split('along ')[1].split('='));
  } while (thermal.length > 1);

  solve(hot, folds);
}
