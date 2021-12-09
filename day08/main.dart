import 'dart:io';

List<String>? segments;
List<List<String>>? input;
List<List<String>>? output;

void read() {
  segments = File('input.txt').readAsLinesSync();
  input = segments!.map((String line) => line.split('|')[0].trim().split(' ')).toList();
  output = segments!.map((String line) => line.split('|')[1].trim().split(' ')).toList();
}

void partOne() {
  List<int> F = List.generate(9, (_) => 0, growable: false);
  output!.forEach((List<String> line) {
    line.forEach((String segment) {
      F[segment.length]++;
    });
  });

  print(F[2] + F[3] + F[4] + F[7]);
}

void find1478(List<String> line, Map<int, String> seven) {
  line.forEach((String segment) {
    switch (segment.length) {
      case 2:
        {
          seven[1] = segment;
          break;
        }
      case 3:
        {
          seven[7] = segment;
          break;
        }
      case 4:
        {
          seven[4] = segment;
          break;
        }
      case 7:
        {
          seven[8] = segment;
          break;
        }
    }
  });
}

void find3(List<String> line, Map<int, String> seven) {
  line.forEach((String segment) {
    if (segment.length == 5) {
      int is3 = 0;
      for (int i = 0; i < seven[1]!.length; i++) {
        if (segment.contains(seven[1]![i])) {
          is3++;
        }
      }
      if (is3 == 2) {
        seven[3] = segment;
        return;
      }
    }
  });
}

void find9(List<String> line, Map<int, String> seven) {
  Set<String> nine = Set<String>();
  for (int i = 0; i < seven[3]!.length; i++) nine.add(seven[3]![i]);
  for (int i = 0; i < seven[4]!.length; i++) nine.add(seven[4]![i]);

  line.forEach((String segment) {
    if (segment.length == 6) {
      int is9 = 0;
      for (String char in nine) {
        if (segment.contains(char)) {
          is9++;
        }
      }
      if (is9 == 6) {
        seven[9] = segment;
        return;
      }
    }
  });
}

void find25(List<String> line, Map<int, String> seven) {
  String? char;
  for (int i = 0; i < seven[8]!.length; i++) {
    if (seven[9]!.contains(seven[8]![i]) == false) {
      char = seven[8]![i];
    }
  }
  line.forEach((String segment) {
    if (segment.length == 5) {
      if (segment.contains(char!)) {
        seven[2] = segment;
      } else if (segment != seven[3]) {
        seven[5] = segment;
      }
    }
  });
}

void find06(List<String> line, Map<int, String> seven) {
  Set<String> six = Set<String>();
  for (int i = 0; i < seven[5]!.length; i++) six.add(seven[5]![i]);
  for (int i = 0; i < seven[8]!.length; i++) {
    if (seven[9]!.contains(seven[8]![i]) == false) {
      six.add(seven[8]![i]);
    }
  }
  line.forEach((String segment) {
    if (segment.length == 6) {
      if (segment != seven[9]) {
        int is0 = 0;
        for (int i = 0; i < seven[1]!.length; i++) {
          if (segment.contains(seven[1]![i])) {
            is0++;
          }
        }
        if (is0 == 2) {
          seven[0] = segment;
        } else {
          seven[6] = segment;
        }
      }
    }
  });
}

bool same(String a, String b) {
  Set<String> c = {};
  if (a.length != b.length) return false;
  for (int i = 0; i < a.length; i++) c.add(a[i]);
  for (int i = 0; i < b.length; i++) {
    if (c.contains(b[i]) == false) {
      return false;
    }
  }
  return true;
}

int decode(List<String> line, Map<int, String> seven) {
  int number = 0;
  line.forEach((String segment) {
    seven.forEach((key, value) {
      if (same(segment, value)) {
        number = number * 10 + key;
      }
    });
  });

  return number;
}

void partTwo() {
  int sum = 0;
  for (int i = 0; i < input!.length; i++) {
    Map<int, String> seven = {};
    find1478(input![i], seven);
    find3(input![i], seven);
    find9(input![i], seven);
    find25(input![i], seven);
    find06(input![i], seven);
    sum += decode(output![i], seven);
  }

  print(sum);
}

void main() {
  read();
  partOne();
  partTwo();
}
