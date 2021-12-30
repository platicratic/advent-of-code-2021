import 'dart:io';

const Map<String, int> M = const {
  'w': 0,
  'x': 1,
  'y': 2,
  'z': 3,
  'add': 0,
  'mul': 1,
  'div': 2,
  'mod': 3,
  'eql': 4,
};

class ALU {
  String set;
  int value;

  ALU(this.set, this.value);

  @override
  bool operator==(other) {
    return this.set == (other as ALU).set;
  }

  @override
  int get hashCode {
    return this.set.hashCode;
  }

  @override
  String toString() {
    return this.set + ' -> ' + this.value.toString();
  }

}

void createInstructions(List<List<List<int>>> instructions) {
  List<String> lines = File('input.txt').readAsLinesSync();
  for (int nr = 0; nr < 252; nr += 18) {
    List<List<int>> instruction = [];
    for (int i = nr + 1; i < nr + 18; i++) {
      List<String> split = lines[i].split(' ');
      if (M[split[0]]! == 0 && !M.containsKey(split[2]) && int.parse(split[2]) == 0) {
        continue;
      }
      if (M[split[0]]! == 2 && !M.containsKey(split[2]) && int.parse(split[2]) == 1) {
        continue;
      }
      if (M.containsKey(split[2])) {
        instruction.add([1, M[split[0]]!, M[split[1]]!, M[split[2]]!]);
      } else {
        instruction.add([0, M[split[0]]!, M[split[1]]!, int.parse(split[2])]);
      }
    }
    instructions.add(instruction);
  }
}

int bruteForce(List<List<List<int>>> instructions, int start, int finnish, int step) {
  List<Set<ALU>> S = List.generate(2, (_) => Set());
  S[0].add(ALU('0 0 0 0', 0));
  List<int> flip = [0, 1, 0];
  for (List<List<int>> instruction in instructions) {
    while (S[flip[0]].isNotEmpty) {
      for (int i = start; i != finnish; i += step) {
        List<int> L = [i, ...S[flip[0]].first.set.split(' ').map((String number) => int.parse(number)).toList().skip(1)];

        bool valid = true;
        for (List<int> instr in instruction) {
          if (!valid) break;
          switch (instr[1]) {
            case 0:
              {
                L[instr[2]] += (instr[0] > 0 ? L[instr[3]] : instr[3]);
                break;
              }
            case 1:
              {
                L[instr[2]] *= (instr[0] > 0 ? L[instr[3]] : instr[3]);
                break;
              }
            case 2:
              {
                int b = (instr[0] > 0 ? L[instr[3]] : instr[3]);
                if (b == 0) {
                  valid = false;
                  break;
                }
                L[instr[2]] ~/= b;
                break;
              }
            case 3:
              {
                int b = (instr[0] > 0 ? L[instr[3]] : instr[3]);
                if (L[instr[2]] < 0 || b <= 0) {
                  valid = false;
                  break;
                }
                L[instr[2]] %= b;
                break;
              }
            case 4:
              {
                L[instr[2]] = (L[instr[2]] == ((instr[0] > 0 ? L[instr[3]] : instr[3])) ? 1 : 0);
                break;
              }
          }
        }
        if (valid && L[3] > -100000 && L[3] < 100000) { // played with the interval to not compute all possibilities
          S[flip[1]].add(ALU(L.join(' '), S[flip[0]].first.value * 10 + i));
        }
      }
      S[flip[0]].remove(S[flip[0]].first);
    }
    flip[0] = flip[1];
    flip[1] = flip[2];
    flip[2] = flip[0];
  }
  return S[flip[0]].where((ALU alu) => alu.set.split(' ')[3] == '0').map((ALU alu) => alu.value).toList().first;
}

void main() {
  List<List<List<int>>> instructions = [];
  createInstructions(instructions);

  print(bruteForce(instructions, 9, 0, -1));
  print(bruteForce(instructions, 1, 10, 1));
}
