import 'dart:io';

List<int> di = [-1, -1, 0, 1, 1, 1, 0, -1];
List<int> dj = [0, 1, 1, 1, 0, -1, -1, -1];

void flash(List<List<int>> octopuses, int i, int j) {
  octopuses[i][j] = 0;
  for (int k = 0; k < 8; k++) {
    int ii = i + di[k];
    int jj = j + dj[k];
    if (ii > -1 && ii < 10 && jj > -1 && jj < 10 && octopuses[ii][jj] > 0) {
      octopuses[ii][jj]++;
      if (octopuses[ii][jj] > 9) {
        flash(octopuses, ii, jj);
      }
    }
  }
}

int countFlashes(List<List<int>> octopuses) {
  int flashes = 0;
  octopuses.forEach((List<int> line) {
    line.forEach((int octopus) => flashes += (octopus == 0 ? 1 : 0));
  });
  return flashes;
}

void partOne(List<List<int>> octopuses) {
  int flashes = 0;

  for (int step = 0; step < 100; step++) {
    for (int i = 0; i < 10; i++) {
      for (int j = 0; j < 10; j++) {
        octopuses[i][j] ++;
      }
    }

    for (int i = 0; i < 10; i++) {
      for (int j = 0; j < 10; j++) {
        if (octopuses[i][j] > 9) {
          flash(octopuses, i, j);
        }
      }
    }

    flashes += countFlashes(octopuses);
  }

  print(flashes);
}

void partTwo(List<List<int>> octopuses) {
  int step = 0;
  while(countFlashes(octopuses) < 100) {
    step ++;

    for (int i = 0; i < 10; i++) {
      for (int j = 0; j < 10; j++) {
        octopuses[i][j] ++;
      }
    }

    for (int i = 0; i < 10; i++) {
      for (int j = 0; j < 10; j++) {
        if (octopuses[i][j] == 10) {
          flash(octopuses, i, j);
        }
      }
    }
  }

  print(step);
}

void main() {
  // read
  List<List<int>> octopuses = File('input.txt').readAsLinesSync().map((String line) {
    List<int> lineInt = [];
    for (int i = 0; i < line.length; i++) lineInt.add(int.parse(line[i]));
    return lineInt;
  }).toList();

  partOne(octopuses.map((List<int> line) => line.map((int octopus) => octopus).toList()).toList());
  partTwo(octopuses.map((List<int> line) => line.map((int octopus) => octopus).toList()).toList());
}
