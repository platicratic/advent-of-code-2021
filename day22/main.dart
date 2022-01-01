import 'dart:io';

import 'dart:math';

void partOne(List<List<int>> steps) {
  List<List<List<int>>> C = List.generate(101, (_) => List.generate(101, (_) => List.generate(101, (_) => 0)));
  steps.forEach((List<int> step) {
    if (step.skip(1).every((int coordinate) => coordinate >= 0 && coordinate <= 100)) {
      for (int x = step[1]; x <= step[2]; x++) {
        for (int y = step[3]; y <= step[4]; y++) {
          for (int z = step[5]; z <= step[6]; z++) {
            C[x][y][z] = step[0];
          }
        }
      }
    }
  });
  int sol = 0;
  C.forEach((List<List<int>> c) {
    c.forEach((List<int> cc) {
      cc.forEach((int ccc) {
        sol += ccc;
      });
    });
  });
  print(sol);
}

void partTwo(List<List<int>> steps) {
  List<List<int>> cubes = List.from(steps);
  steps.forEach((List<int> step) {
    List<List<int>> intersections = [];
    cubes.forEach((List<int> cube) {
      List<int> intersection = [
        max(step[1], cube[1]),
        min(step[2], cube[2]),
        max(step[3], cube[3]),
        min(step[4], cube[4]),
        max(step[5], cube[5]),
        min(step[6], cube[6]),
      ];
      if (intersection[0] <= intersection[1] && intersection[2] <= intersection[3] && intersection[4] <= intersection[5]) {
        intersections.add([-cube[0], ...intersection]);
      }
    });
    cubes.addAll(intersections);
    cubes.add(step);
  });

  int sol = 0;
  cubes.forEach((List<int> cube) {
    sol += (cube[0] * (cube[2] - cube[1] + 1) * (cube[4] - cube[3] + 1) * (cube[6] - cube[5] + 1));
  });
  print(sol);
}

void main() {
  List<List<int>> steps = File('input.txt')
      .readAsLinesSync()
      .map((String line) => [
            (line[1] == 'n' ? 1 : 0),
            ...RegExp('\-{0,1}[0-9]+')
                .allMatches(line)
                .map((RegExpMatch match) => int.parse(match.group(0)!) + 50)
                .toList()
          ])
      .toList();
  partOne(steps);
  partTwo(steps);
}
