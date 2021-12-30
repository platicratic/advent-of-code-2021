import 'dart:io';
import 'dart:math';

class Pair {
  Pair? first;
  Pair? second;
  int number;
  bool isChanging;

  Pair({this.first = null, this.second = null, this.number = -1, this.isChanging = false});

  @override
  String toString() {
    if (first == null && second == null) {
      return this.number.toString();
    }
    return '[' + this.first.toString() + ',' + this.second.toString() + ']';
  }
}

Pair createPair(String line) {
  if (line.length == 1) {
    return Pair(first: null, second: null, number: int.parse(line[0]));
  }
  line = line.substring(1, line.length - 1);

  int notMine = 0, comma = 0;
  for (int i = 0; i < line.length; i++) {
    if (line[i] == '[') {
      notMine++;
    } else if (line[i] == ']') {
      notMine--;
    } else if (notMine == 0 && line[i] == ',') {
      comma = i;
      break;
    }
  }

  return Pair(first: createPair(line.substring(0, comma)), second: createPair(line.substring(comma + 1)));
}

bool isExplosion(Pair pair, int depth) {
  if (depth >= 4 && pair.number < 0) {
    return true;
  } else if (pair.number < 0) {
    return isExplosion(pair.first!, depth + 1) || isExplosion(pair.second!, depth + 1);
  }
  return false;
}

Pair? findExplosion(Pair pair, int depth) {
  if (pair.number < 0) {
    if (depth >= 4) {
      return pair;
    }
    Pair? found = findExplosion(pair.first!, depth + 1);
    return (found != null ? found : findExplosion(pair.second!, depth + 1));
  }
}

void findLeft(Pair pair, Pair exploding) {
  if (exploding.isChanging && pair.number >= 0) {
    pair.number += exploding.first!.number;
    exploding.isChanging = false;
  } else if (pair == exploding) {
    exploding.isChanging = true;
  } else if (pair.number < 0) {
    findLeft(pair.second!, exploding);
    findLeft(pair.first!, exploding);
  }
}

void findRight(Pair pair, Pair exploding, bool found) {
  if (exploding.isChanging && pair.number >= 0) {
    pair.number += exploding.second!.number;
    exploding.isChanging = false;
  } else if (pair == exploding) {
    exploding.isChanging = true;
    return;
  } else if (pair.number < 0) {
    findRight(pair.first!, exploding, found);
    findRight(pair.second!, exploding, found);
  }
}

void explosion(Pair pair) {
  Pair exploding = findExplosion(pair, 0)!;
  findLeft(pair, exploding);
  findRight(pair, exploding, false);

  exploding.first = null;
  exploding.second = null;
  exploding.number = 0;
}

bool isSplit(Pair pair) {
  if (pair.number < 0) {
    return isSplit(pair.first!) || isSplit(pair.second!);
  }
  return (pair.number > 9);
}

Pair? findSplit(Pair pair) {
  if (pair.number > 9) {
    return pair;
  } else if (pair.number < 0) {
    Pair? found = findSplit(pair.first!);
    return (found != null ? found : findSplit(pair.second!));
  }
}

void split(Pair pair) {
  Pair splitting = findSplit(pair)!;

  splitting.first = Pair(first: null, second: null, number: (splitting.number / 2).floor());
  splitting.second = Pair(first: null, second: null, number: (splitting.number / 2).ceil());
  splitting.number = -1;
}

void reduction(Pair pair) {
  while (isExplosion(pair, 0) || isSplit(pair)) {
    if (isExplosion(pair, 0)) {
      explosion(pair);
    } else {
      split(pair);
    }
  }
}

int magnitude(Pair node) {
  return (node.first == null ? node.number : 3 * magnitude(node.first!)) +
      (node.second == null ? node.number : 2 * magnitude(node.second!));
}

void partOne(List<String> lines) {
  Pair god = Pair(first: createPair(lines[0]), second: createPair(lines[1]));
  reduction(god);
  lines.skip(2).forEach((String line) {
    god = Pair(first: god, second: createPair(line));
    reduction(god);
  });

  print(magnitude(god) ~/ 2);
}

void partTwo(List<String> lines) {
  int best = 0;
  for (int i = 0; i < lines.length; i++) {
    for (int j = 0; j < lines.length; j++) {
      if (i != j) {
        Pair pair = Pair(first: createPair(lines[i]), second: createPair(lines[j]));
        reduction(pair);
        best = max(best, magnitude(pair) ~/ 2);
      }
    }
  }

  print(best);
}

void main() {
  List<String> lines = File('input.txt').readAsLinesSync();
  partOne(lines);
  partTwo(lines);
}
