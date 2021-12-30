import 'dart:collection';
import 'dart:math';

const Map<String, int> Cost = const {
  'A': 1,
  'B': 10,
  'C': 100,
  'D': 1000,
};
const Map<String, List<int>> Target1 = const {
  'A': [11, 12],
  'B': [13, 14],
  'C': [15, 16],
  'D': [17, 18],
};
const Map<String, List<int>> Target2 = const {
  'A': [11, 12, 13, 14],
  'B': [15, 16, 17, 18],
  'C': [19, 20, 21, 22],
  'D': [23, 24, 25, 26],
};
const List<int> Bad1 = const [2, 4, 6, 8, 11, 13, 15, 17];
const List<int> Bad2 = const [2, 4, 6, 8, 11, 12, 13, 15, 16, 17, 19, 20, 21, 23, 24, 25];
const String start1 = '...........DDCCABBA';
const String finnish1 = '...........AABBCCDD';
const String start2 = '...........DDDDCCBCABABBACA';
const String finnish2 = '...........AAAABBBBCCCCDDDD';
List<List<int>> G1 = List.generate(19, (_) => []);
List<List<int>> G2 = List.generate(27, (_) => []);

void generateGraph1() {
  for (int i = 0; i < 10; i++) G1[i].add(i + 1);
  for (int i = 10; i > 0; i--) G1[i].add(i - 1);
  for (int i = 2, j = 11; i <= 8; i += 2, j += 2) {
    G1[i].add(j);
    G1[j].add(i);
  }
  for (int i = 11; i < 19; i += 2) {
    G1[i].add(i + 1);
    G1[i + 1].add(i);
  }
}

void generateGraph2() {
  for (int i = 0; i < 10; i++) G2[i].add(i + 1);
  for (int i = 10; i > 0; i--) G2[i].add(i - 1);
  for (int i = 2, j = 11; i <= 8; i += 2, j += 4) {
    G2[i].add(j);
    G2[j].add(i);
  }
  for (int i = 11; i < 27; i += 4) {
    for (int j = i; j < i + 3; j++) {
      G2[j].add(j + 1);
      G2[j + 1].add(j);
    }
  }
}

List<int> goInRoom(String burrow, String amphipod, int initial, List<List<int>> G, Map<String, List<int>> Target) {
  int toGo = -1;
  for (int i = Target.values.first.length - 1; i >= 0; i--) {
    bool allGood = true;
    for (int j = i + 1; j < Target.values.first.length; j++) {
      if (burrow[Target[amphipod]![j]] != amphipod) {
        allGood = false;
      }
    }
    if (allGood && burrow[Target[amphipod]![i]] == '.') {
      toGo = Target[amphipod]![i];
    }
  }
  List<bool> F = List.generate(G.length, (_) => false);
  Queue<List<int>> queue = Queue();
  queue.add([initial, 0]);
  while (queue.isNotEmpty && queue.first[0] != toGo) {
    List<int> q = queue.removeFirst();
    F[q[0]] = true;
    for (int node in G[q[0]]) {
      if (!F[node] && burrow[node] == '.') {
        queue.add([node, q[1] + 1]);
      }
    }
  }
  return [toGo, (queue.isNotEmpty && queue.first[0] == toGo ? queue.first[1] : -1)];
}

void solve(String start, String finnish, List<List<int>> G, List<int> Bad, Map<String, List<int>> Target) {
  Map<String, int> M = Map.from({start: 0});
  int sol = 0x3f3f3f3f;

  Queue<String> Q = Queue();
  Q.add(start);
  while (Q.isNotEmpty) {
    String currentBurrow = Q.removeFirst();
    int currentCost = M[currentBurrow]!;

    for (int i = 0; i < 11; i++) {
      if (currentBurrow[i] != '.') {
        List<int> free = goInRoom(currentBurrow, currentBurrow[i], i, G, Target);
        if (free[0] > 0 && free[1] > 0) {
          String newBurrow =
              currentBurrow.replaceRange(i, i + 1, '.').replaceRange(free[0], free[0] + 1, currentBurrow[i]);
          if (!M.containsKey(newBurrow) || Cost[currentBurrow[i]]! * free[1] + currentCost < M[newBurrow]!) {
            M[newBurrow] = Cost[currentBurrow[i]]! * free[1] + currentCost;
            Q.add(newBurrow);
          }
        }
      }
    }

    for (int i = 11; i < G.length; i++) {
      if (currentBurrow[i] != '.') {
        List<bool> F = List.generate(G.length, (_) => false);
        Queue<List<int>> queue = Queue();
        queue.add([i, 1]);
        while (queue.isNotEmpty) {
          List<int> q = queue.removeFirst();
          F[q[0]] = true;
          for (int node in G[q[0]]) {
            if (!F[node] && currentBurrow[node] == '.') {
              queue.add([node, q[1] + 1]);
              if (!Bad.contains(node)) {
                String newBurrow =
                    currentBurrow.replaceRange(i, i + 1, '.').replaceRange(node, node + 1, currentBurrow[i]);
                if (!M.containsKey(newBurrow) || Cost[currentBurrow[i]]! * q[1] + currentCost < M[newBurrow]!) {
                  M[newBurrow] = Cost[currentBurrow[i]]! * q[1] + currentCost;
                  Q.add(newBurrow);
                }
              }
            }
          }
        }
      }
    }
    if (currentBurrow == finnish) {
      sol = min(sol, currentCost);
    }
  }

  print(sol);
}

void partOne() {
  generateGraph1();
  solve(start1, finnish1, G1, Bad1, Target1);
}

void partTwo() {
  generateGraph2();
  solve(start2, finnish2, G2, Bad2, Target2);
}

void main() {
  partOne();
  partTwo();
}
