import 'dart:io';
import 'dart:math';

void partOne(List<int> players) {
  int die = 1, rolls = 0;
  List<int> score = List.generate(2, (_) => 0);

  while (score[0] < 1000 && score[1] < 1000) {
    int rollScore = ((die - 1) % 100 + 1) + (die % 100 + 1) + ((die + 1) % 100 + 1);

    players[rolls % 2] = (players[rolls % 2] + rollScore - 1) % 10 + 1;
    score[rolls % 2] += players[rolls % 2];

    die = (die + 2) % 100 + 1;
    rolls += 3;
  }

  print(min(score[0], score[1]) * rolls);
}

List<List<int>> play(int initial) {
  List<List<int>> turns = [];
  List<List<int>> player = List.generate(21, (_) => List.generate(11, (_) => 0));
  player[0][initial] = 1;

  while (true) {
    List<List<int>> next = List.generate(21, (_) => List.generate(11, (_) => 0));
    int nrWins = 0, nrLose = 0;

    for (int score = 0; score < 21; score++) {
      for (int space = 1; space < 11; space++) {
        if (player[score][space] > 0) {
          for (int x = 1; x < 4; x++) {
            for (int y = 1; y < 4; y++) {
              for (int z = 1; z < 4; z++) {
                int position = (space + x + y + z - 1) % 10 + 1;
                if (score + position > 20) {
                  nrWins += player[score][space];
                } else {
                  nrLose += player[score][space];
                  next[score + position][position] += player[score][space];
                }
              }
            }
          }
        }
      }
    }

    turns.add([nrWins, nrLose]);
    player = next;
    if (nrLose == 0) break;
  }
  return turns;
}

void partTwo(List<int> players) {
  List<List<int>> player1 = play(players[0]);
  List<List<int>> player2 = play(players[1]);
  List<int> wins = List.generate(2, (_) => 0);
  for (int i = 1; i < min(player1.length, player2.length); i++) {
    wins[0] += player1[i][0] * player2[i - 1][1]; // i - 1 because player 1 is first
    wins[1] += player2[i][0] * player1[i][1];
  }

  print(max(wins[0], wins[1]));
}

void main() {
  List<int> players = File('input.txt').readAsLinesSync().map((String player) => int.parse(player)).toList();

  partOne([...players]);
  partTwo([...players]);
}
