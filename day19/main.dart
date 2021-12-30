import 'dart:io';
import 'dart:math';

import 'package:vector_math/vector_math.dart';

List<List<List<Vector3>>> read_and_create_24() {
  List<String> lines = File('input.txt').readAsLinesSync();
  List<List<Vector3>> scanners = [];
  List<Vector3> scanner;
  for (int i = 0; i < lines.length; i++) {
    if (lines[i].length == 0) {
      scanners.add(scanner);
    } else if (lines[i].contains('scanner')) {
      scanner = [];
    } else {
      List<double> coordinates = lines[i].split(',').map((String number) => double.parse(number)).toList();
      scanner.add(Vector3(coordinates[0], coordinates[1], coordinates[2]));
    }
  }

  List<Vector3> Axes = [
    Vector3(1, 0, 0),
    Vector3(0, 1, 0),
    Vector3(0, 0, 1),
    Vector3(-1, 0, 0),
    Vector3(0, -1, 0),
    Vector3(0, 0, -1)
  ];
  List<double> Angles = [0, 90, 180, 270].map((int angle) => angle * pi / 180).toList();

  List<List<List<Vector3>>> scanners24 = [];
  for (List<Vector3> scanner in scanners) {
    List<List<Vector3>> scanner24 = [];
    for (int axis = 0; axis < 6; axis++) {
      for (double angle in Angles) {
        List<Vector3> scannerCopy = scanner.map((Vector3 beacon) {
          switch (axis) {
            case 0:
              {
                return Vector3.copy(beacon);
              }
            case 1:
              {
                return Vector3(-beacon.y, beacon.x, beacon.z);
              }
            case 2:
              {
                return Vector3(beacon.z, beacon.y, -beacon.x);
              }
            case 3:
              {
                return Vector3(-beacon.x, -beacon.y, beacon.z);
              }
            case 4:
              {
                return Vector3(beacon.y, -beacon.x, beacon.z);
              }
            case 5:
              {
                return Vector3(-beacon.z, beacon.y, beacon.x);
              }
          }
        }).toList();

        scannerCopy.forEach((Vector3 beacon) {
          beacon.applyAxisAngle(Axes[axis], angle);
          beacon.round();
        });

        scanner24.add(scannerCopy);
      }
    }
    scanners24.add(scanner24);
  }
  return scanners24;
}

List<int> findScannerPosition(List<Vector3> scanner1, List<Vector3> scanner2) {
  List<int> possibleX = [], possibleY = [], possibleZ = [];
  for (int i = -2000; i < 2000; i++) {
    int countX = 0, countY = 0, countZ = 0;
    scanner1.forEach((Vector3 vector1) {
      scanner2.forEach((Vector3 vector2) {
        if (vector1.x == vector2.x + i) countX++;
        if (vector1.y == vector2.y + i) countY++;
        if (vector1.z == vector2.z + i) countZ++;
      });
    });
    if (countX >= 12) possibleX.add(i);
    if (countY >= 12) possibleY.add(i);
    if (countZ >= 12) possibleZ.add(i);
  }

  for (int x in possibleX) {
    for (int y in possibleY) {
      for (int z in possibleZ) {
        int count = 0;
        scanner1.forEach((Vector3 vector1) {
          scanner2.forEach((Vector3 vector2) {
            if (vector1.x == vector2.x + x && vector1.y == vector2.y + y && vector1.z == vector2.z + z) {
              count++;
            }
          });
        });
        if (count >= 12) {
          return [x, y, z];
        }
      }
    }
  }

  return [];
}

class Node {
  final int scanner, direction;

  Node(this.scanner, this.direction);

  @override
  String toString() {
    return 'scanner: ' + this.scanner.toString() + ' -> direction: ' + this.direction.toString();
  }
}

const int numberOfScanners = 37;
List<List<List<List<List<int>>>>> H = List.generate(numberOfScanners,
    (_) => List.generate(24, (_) => List.generate(numberOfScanners, (_) => List.generate(24, (_) => null))));

void dfs(List<List<List<Vector3>>> scanners24, List<Node> steps, List<Node> from, List<bool> done) {
  if (steps.length == scanners24.length) {
    done.add(true);
    partOne(scanners24, steps, from);
    partTwo(steps, from);
  }

  Set<int> used = Set.from(steps.map((Node step) => step.scanner));
  for (Node node in steps) {
    for (int i = 0; i < scanners24.length && done.length < 1; i++) {
      if (!used.contains(i)) {
        for (int d = 0; d < 24; d++) {
          if (H[node.scanner][node.direction][i][d] == null) {
            H[node.scanner][node.direction][i][d] =
                findScannerPosition(scanners24[node.scanner][node.direction], scanners24[i][d]);
          }
          if (H[node.scanner][node.direction][i][d].length > 0) {
            steps.add(Node(i, d));
            from.add(node);
            dfs(scanners24, steps, from, done);
            from.removeLast();
            steps.removeLast();
          }
        }
      }
    }
  }
}

Map<Node, Vector3> getScannersPositions(List<Node> steps, List<Node> from) {
  Map<Node, Vector3> L = {steps[0]: Vector3(0, 0, 0)};
  for (int i = 0; i < from.length; i++) {
    List<int> scannerPosition = H[from[i].scanner][from[i].direction][steps[i + 1].scanner][steps[i + 1].direction];
    L[steps[i + 1]] = Vector3(
        L[from[i]].x + scannerPosition[0], L[from[i]].y + scannerPosition[1], L[from[i]].z + scannerPosition[2]);
  }
  return L;
}

void partOne(List<List<List<Vector3>>> scanners24, List<Node> steps, List<Node> from) {
  Set<Vector3> S = {};
  getScannersPositions(steps, from).forEach((Node node, Vector3 coordinate) {
    for (Vector3 beacon in scanners24[node.scanner][node.direction]) {
      S.add(Vector3(beacon.x + coordinate.x, beacon.y + coordinate.y, beacon.z + coordinate.z));
    }
  });
  print(S.length);
}

void partTwo(List<Node> steps, List<Node> from) {
  List<Vector3> L = getScannersPositions(steps, from).values.toList();
  int best = 0;
  for (int i = 0; i < L.length; i ++) {
    for (int j = i + 1; j < L.length; j ++) {
      best = max(best, (L[i].x - L[j].x).toInt().abs() + (L[i].y - L[j].y).toInt().abs() + (L[i].z - L[j].z).toInt().abs());
    }
  }
  print(best);
}

void main() {
  List<List<List<Vector3>>> scanners24 = read_and_create_24();
  dfs(scanners24, [Node(0, 0)], [], []);
}
