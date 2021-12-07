import 'dart:io';
import 'dart:math';

int calculateDistance1(int hole, List<int> positions) {
  int deference = 0;
  positions.forEach((int position) {
    deference += (position - hole).abs();
  });
  return deference;
}

int calculateDistance2(int hole, List<int> positions) {
  int deference = 0;
  positions.forEach((int position) {
    int distance = (position - hole).abs();
    deference += (distance * (distance + 1) ~/ 2);
  });
  return deference;
}

void solve(List<int> positions, Function calculateDistance) {
  int minim = positions[0], maxim = positions[0];
  positions.skip(1).forEach((int position) {
    minim = min(minim, position);
    maxim = max(maxim, position);
  });

  int minDist = calculateDistance(minim, positions);
  for (int i = minim + 1; i <= maxim; i++) {
    minDist = min(minDist, calculateDistance(i, positions));
  }

  print(minDist);
}

void main() {
  List<int> positions = File('input.txt').readAsStringSync().split(',').map((String item) => int.parse(item)).toList();
  solve(positions, calculateDistance1);
  solve(positions, calculateDistance2);
}
