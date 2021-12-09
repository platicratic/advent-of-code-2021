import 'dart:io';

List<List<int>>? heightmap;
List<int> di = [-1, 0, 1, 0];
List<int> dj = [0, 1, 0, -1];
List<int> adjacent  = [1, 0, 1, 2, 3];

void read() {
  heightmap = File('input.txt').readAsLinesSync().map((String line) {
    List<int> intLine = [];
    for (int i = 0; i < line.length; i++) {
      intLine.add(int.parse(line[i]));
    }
    return intLine;
  }).toList();
}

bool verify(int i, int j) {
  return (i >= 0 && i < heightmap!.length && j >= 0 && j < heightmap![i].length);
}

void partOne() {
  int sum = 0;
  for (int i = 0; i < heightmap!.length; i++) {
    for (int j = 0; j < heightmap![i].length; j++) {
      bool lowest = true;
      for (int k = 0; k < 4; k++) {
        int ii = i + di[k];
        int jj = j + dj[k];
        if (verify(ii, jj) && heightmap![i][j] >= heightmap![ii][jj]) {
          lowest = false;
          break;
        }
      }
      if (lowest) {
        sum += heightmap![i][j] + 1;
      }
    }
  }

  print(sum);
}

int basin(int i, int j) {
  if (verify(i, j) && heightmap![i][j] < 9) {
    heightmap![i][j] = 9;
    return adjacent.reduce((result, k) => result + basin(i + di[k], j + dj[k]));
  }
  return 0;
}

void partTwo() {
  List<int> basins = [];
  for (int i = 0; i < heightmap!.length; i++) {
    for (int j = 0; j < heightmap![i].length; j++) {
      basins.add(basin(i, j));
    }
  }
  basins.sort();
  print(basins[basins.length - 1] * basins[basins.length - 2] * basins[basins.length - 3]);
}

void main() {
  read();
  partOne();
  partTwo();
}
