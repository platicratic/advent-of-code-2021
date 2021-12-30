import 'dart:io';

void printImage(List<List<int>> image) {
  for (int i = 0; i < image.length; i++) {
    for (int j = 0; j < image.length; j++) {
      stdout.write((image[i][j] == 0 ? '.' : '#'));
    }
    stdout.write('\n');
  }
}

int count(List<List<int>> image) {
  int count = 0;
  for (int i = 101; i < image.length - 101; i++) {
    for (int j = 101; j < image.length - 101; j++) {
      count += image[i][j];
    }
  }
  return count;
}

void solve(List<List<int>> image, List<int> imageEnhancement, int times) {
  List<List<int>> imageCopy = List.generate(image.length, (_) => List.generate(image.length, (_) => 0));

  while (times-- > 0) {
    for (int i = 1; i < image.length - 1; i++) {
      for (int j = 1; j < image.length - 1; j++) {
        int number = 0, pow = 8;
        for (int k = i - 1; k <= i + 1; k++) {
          for (int l = j - 1; l <= j + 1; l++) {
            number += (image[k][l] << pow--);
          }
        }
        imageCopy[i][j] = imageEnhancement[number];
      }
    }
    image = imageCopy.map((List<int> item) => item.map((int item) => item).toList()).toList();
  }

  print(count(image));
}

void main() {
  List<String> input = File('input.txt').readAsLinesSync();
  List<int> imageEnhancement = List.generate(512, (index) => (input[0][index] == '.' ? 0 : 1));
  List<List<int>> image = List.generate(input.length - 2 + 512, (_) => List.generate(input.length - 2 + 512, (_) => 0));
  for (int i = 0; i < input.length - 2; i++) {
    for (int j = 0; j < input.length - 2; j++) {
      image[i + 256][j + 256] = (input[i + 2][j] == '.' ? 0 : 1);
    }
  }

  solve(image, imageEnhancement, 2);
  solve(image, imageEnhancement, 50);
}
