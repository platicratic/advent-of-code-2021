import 'dart:io';

Map<String, int> scores = {
  '(': 1,
  '[': 2,
  '{': 3,
  '<': 4,
};

void solve(List<String> navigation) {
  int score = 0;
  List<String> stack = [];
  List<int> contest = [];

  navigation.forEach((String line) {
    // part 1
    for (int i = 0; i < line.length; i++) {
      if (line[i].contains('(') || line[i].contains('[') || line[i].contains('{') || line[i].contains('<')) {
        stack.add(line[i]);
      } else {
        switch (line[i]) {
          case ')':
            {
              if (!stack.last.contains('(')) {
                score += 3;
                stack = [];
              }
              break;
            }
          case ']':
            {
              if (!stack.last.contains('[')) {
                score += 57;
                stack = [];
              }
              break;
            }
          case '}':
            {
              if (!stack.last.contains('{')) {
                score += 1197;
                stack = [];
              }
              break;
            }
          case '>':
            {
              if (!stack.last.contains('<')) {
                score += 25137;
                stack = [];
              }
              break;
            }
        }
        if (stack.isEmpty) {
          break;
        }
        stack.removeLast();
      }
    }

    // part 2
    if (stack.isNotEmpty) {
      int contestScore = 0;
      while (stack.isNotEmpty) {
        contestScore = contestScore * 5 + scores[stack.last]!;
        stack.removeLast();
      }
      contest.add(contestScore);
    }
  });
  contest.sort();

  print(score);
  print(contest[contest.length ~/ 2]);
}

void main() {
  List<String> navigation = File('input.txt').readAsLinesSync();
  solve(navigation);
}
