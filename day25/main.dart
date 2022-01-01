import 'dart:io';

Map<String, int> M = {
  '.': 0,
  '>': 1,
  'v': 2,
};

Map<int, String> Q = {
  0: '.',
  1: '>',
  2: 'v',
};

void copy(List<List<int>> floor, List<List<int>> other) {
  for (int i = 0; i < floor.length; i++) {
    for (int j = 0; j < floor[i].length; j++) {
      floor[i][j] = other[i][j];
    }
  }
}

int moveEast(List<List<int>> floor, {int moves = 0}) {
  List<List<int>> east =
      List.generate(floor.length, (int i) => List.generate(floor.first.length, (int j) => floor[i][j]));
  for (int i = 0; i < floor.length; i++) {
    for (int j = 0; j < floor[i].length; j++) {
      if (floor[i][j] == M['>'] && floor[i][(j + 1) % floor[i].length] == M['.']) {
        east[i][j] = M['.']!;
        east[i][(j + 1) % floor[i].length] = M['>']!;
        j++;

        moves++;
      }
    }
  }

  copy(floor, east);
  return moves;
}

int moveSouth(List<List<int>> floor, {int moves = 0}) {
  List<List<int>> south =
      List.generate(floor.length, (int i) => List.generate(floor.first.length, (int j) => floor[i][j]));
  for (int j = 0; j < floor.first.length; j++) {
    for (int i = 0; i < floor.length; i++) {
      if (floor[i][j] == M['v'] && floor[(i + 1) % floor.length][j] == M['.']) {
        south[i][j] = M['.']!;
        south[(i + 1) % floor.length][j] = M['v']!;
        i++;

        moves++;
      }
    }
  }

  copy(floor, south);
  return moves;
}

void partOne(List<List<int>> floor, {int steps = 1}) {
  while (moveEast(floor) + moveSouth(floor) > 0) {
    steps++;
  }

  print(steps);
}

void main() {
  List<List<int>> floor = File('input.txt')
      .readAsLinesSync()
      .map((String line) => line.split('').map((String char) => M[char]!).toList())
      .toList();
  partOne(floor);
}
