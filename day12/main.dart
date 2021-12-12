import 'dart:io';

Map<String, List<String>> caves = Map<String, List<String>>();
Map<String, bool> F = {'start': true};

void addNode(String a, String b) {
  if (caves[a] == null) {
    caves[a] = [b];
  } else {
    caves[a]!.add(b);
  }
}

void read() {
  File('input.txt').readAsLinesSync().forEach((String line) {
    List<String> nodes = line.split('-');
    if (nodes[0] != 'end' && nodes[1] != 'start') addNode(nodes[0], nodes[1]);
    if (nodes[0] != 'start' && nodes[1] != 'end') addNode(nodes[1], nodes[0]);
  });
}

int dfs1(String node) {
  if (node == 'end') {
    return 1;
  } else {
    int count = 0;
    caves[node]!.forEach((String cave) {
      if (F[cave] == null || F[cave] == false || cave.toUpperCase() == cave) {
        F[cave] = true;
        count += dfs1(cave);
        F[cave] = false;
      }
    });
    return count;
  }
}

int dfs2(String node, bool exception) {
  if (node == 'end') {
    return 1;
  } else {
    int count = 0;
    caves[node]!.forEach((String cave) {
      if (F[cave] == null || F[cave] == false || cave.toUpperCase() == cave) {
        F[cave] = true;
        count += dfs2(cave, exception);
        F[cave] = false;
      } else if (exception == false) {
        exception = true;
        count += dfs2(cave, exception);
        exception = false;
      }
    });
    return count;
  }
}

void main() {
  read();
  print(dfs1('start'));
  print(dfs2('start', false));
}
