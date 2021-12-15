import 'dart:collection';
import 'dart:io';

const List<int> di = const [-1, 0, 1, 0];
const List<int> dj = const [0, 1, 0, -1];

class Pair {
  final int i, j;

  Pair(this.i, this.j);
}

int solve(List<List<int>> cavern) {
  List<List<int>> v = List.generate(cavern.length,
      (_1) => List.generate(cavern.length, (_2) => (_1 == 0 && _2 == 0 ? 0 : 0x3f3f3f3f), growable: false),
      growable: false);

  Queue<Pair> q = Queue();
  q.add(Pair(0, 0));

  while (q.isNotEmpty) {
    for (int k = 0, ii, jj; k < 4; k++) {
      ii = q.first.i + di[k];
      jj = q.first.j + dj[k];

      if (ii >= 0 && ii < v.length && jj >= 0 && jj < v.length) {
        if (v[q.first.i][q.first.j] + cavern[ii][jj] < v[ii][jj]) {
          v[ii][jj] = v[q.first.i][q.first.j] + cavern[ii][jj];
          q.add(Pair(ii, jj));
        }
      }
    }
    q.removeFirst();
  }
  return v.last.last;
}

void partOne(List<List<int>> cavern) {
  print(solve(cavern));
}

void partTwo(List<List<int>> cavern) {
  int length = cavern.length;
  List<List<int>> newCavern = List.generate(length * 5, (_) => List.generate(length * 5, (_) => 0));
  for (int i = 0; i < 5; i++) {
    for (int j = 0; j < 5; j++) {
      for (int y = 0; y < length; y++) {
        for (int x = 0; x < length; x++) {
          newCavern[i * length + y][j * length + x] = (cavern[y][x] + i + j) % 10 + (cavern[y][x] + i + j > 9 ? 1 : 0);
        }
      }
    }
  }

  print(solve(newCavern));
}

void main() {
  List<List<int>> cavern = File('input.txt')
      .readAsLinesSync()
      .map((String line) => line.codeUnits.map((int codeUnit) => codeUnit - '0'.codeUnitAt(0)).toList())
      .toList();

  partOne(cavern);
  partTwo(cavern);
}
