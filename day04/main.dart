import 'dart:io';

const int MARKED = 0x3f3f3f3f;

void MarkBoards(List<List<List<int>>> boards, int number) {
  boards.forEach((List<List<int>> board) {
    for (int i = 0; i < 5; i++) {
      for (int j = 0; j < 5; j++) {
        if (board[i][j] == number) {
          board[i][j] = MARKED;
        }
      }
    }
  });
}

int VerifyBingo(List<List<List<int>>> boards) {
  for (int k = 0; k < boards.length; k++) {
    // ROWS
    for (int i = 0; i < 5; i++) {
      bool bingo = true;
      for (int j = 0; j < 5 && bingo; j++) {
        if (boards[k][i][j] != MARKED) {
          bingo = false;
        }
      }
      if (bingo) {
        return k;
      }
    }

    // COLUMNS
    for (int j = 0; j < 5; j++) {
      bool bingo = true;
      for (int i = 0; i < 5 && bingo; i++) {
        if (boards[k][i][j] != MARKED) {
          bingo = false;
        }
      }
      if (bingo) {
        return k;
      }
    }
  }
  return -1;
}

int finalScore(List<List<int>> board, int number) {
  int result = 0;
  for (int i = 0; i < 5; i++) {
    for (int j = 0; j < 5; j++) {
      if (board[i][j] != MARKED) {
        result += board[i][j];
      }
    }
  }
  result *= number;
  return result;
}

void PartOne(List<int> random, List<List<List<int>>> boards) {
  for (int number in random) {
    MarkBoards(boards, number);
    int bingoBoard = VerifyBingo(boards);
    if (bingoBoard > 0) {
      print(finalScore(boards[bingoBoard], number));
      break;
    }
  }
}

void PartTwo(List<int> random, List<List<List<int>>> boards) {
  int? lastBoardToWinFinalScore;
  for (int number in random) {
    MarkBoards(boards, number);
    int bingoBoard = VerifyBingo(boards);
    while (bingoBoard >= 0) {
      lastBoardToWinFinalScore = finalScore(boards[bingoBoard], number);
      boards.removeAt(bingoBoard);
      bingoBoard = VerifyBingo(boards);
    }
  }
  print(lastBoardToWinFinalScore);
}

void main() {
  List<String> bingo = File('input.txt').readAsLinesSync();
  List<int> random = bingo[0].split(',').map((String item) => int.parse(item)).toList();
  List<List<List<int>>> boards = [];
  for (int i = 1; i < bingo.length; i += 6) {
    List<List<int>> board = [];
    for (int k = i + 1; k < i + 6; k++) {
      List<int> row = [];
      bingo[k].split(' ').forEach((String item) {
        if (item.length > 0) {
          row.add(int.parse(item));
        }
      });
      board.add([...row]);
    }
    boards.add(board);
  }

  // Trying to pass by value: where, what, how, why not ?
  // PartOne(random, boards.map((e) => e.map((e) => e.map((e) => e).toList()).toList()).toList());
  PartOne(random, boards);
  PartTwo(random, boards);
}
