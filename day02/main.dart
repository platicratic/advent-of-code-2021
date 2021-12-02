import 'dart:io';

void PartOne(List<String> course) {
  int positionX = 0, positionY = 0;

  course.forEach((String step) {
    List<String> command = step.split(' ');
    switch (command[0]) {
      case 'forward':
        {
          positionX += int.parse(command[1]);
          break;
        }
      case 'down':
        {
          positionY += int.parse(command[1]);
          break;
        }
      case 'up':
        {
          positionY -= int.parse(command[1]);
          break;
        }
    }
  });

  print(positionX * positionY);
}

void PartTwo(List<String> course) {
  int horizontal = 0, depth = 0, aim = 0;

  course.forEach((String step) {
    List<String> command = step.split(' ');
    switch (command[0]) {
      case 'forward':
        {
          int units = int.parse(command[1]);
          horizontal += units;
          depth += aim * units;
          break;
        }
      case 'down':
        {
          aim += int.parse(command[1]);
          break;
        }
      case 'up':
        {
          aim -= int.parse(command[1]);
          break;
        }
    }
  });

  print(horizontal * depth);
}

void main() {
  List<String> course = File('input.txt').readAsLinesSync();
  PartOne(course);
  PartTwo(course);
}
