import 'dart:io';
import 'dart:math';

const Map<String, String> M = {
  '0': '0000',
  '1': '0001',
  '2': '0010',
  '3': '0011',
  '4': '0100',
  '5': '0101',
  '6': '0110',
  '7': '0111',
  '8': '1000',
  '9': '1001',
  'A': '1010',
  'B': '1011',
  'C': '1100',
  'D': '1101',
  'E': '1110',
  'F': '1111',
};
int i = 0, first = 0, second = 0;

String transformToBits(String packet) {
  String bits = '';
  for (int i = 0; i < packet.length; i++) {
    bits += M[packet[i]]!;
  }
  return bits;
}

int decodeBinary(String bits) {
  int number = 0;
  for (int i = 0; i < bits.length; i++) {
    if (bits[i] == '1') {
      number += (1 << (bits.length - i - 1));
    }
  }
  return number;
}

List<int> packet(String bits, int length, int nr) {
  List<int> ret = [];
  while (i < length && nr > 0) {
    first += decodeBinary(bits.substring(i, i += 3));
    int id = decodeBinary(bits.substring(i, i += 3));

    if (id == 4) {
      String number = '';
      while (i < length && bits[i] == '1') {
        number += bits.substring(i + 1, i += 5);
      }
      number += bits.substring(i + 1, i += 5);
      ret.add(decodeBinary(number));
    } else {
      List<int> subPackets = (bits[i] == '0'
          ? packet(bits, i + 16 + decodeBinary(bits.substring(i + 1, i += 16)), 0x3f3f3f3f)
          : packet(bits, length, decodeBinary(bits.substring(i + 1, i += 12))));
      if (id == 0) {
        ret.add(subPackets.reduce((value, element) => value + element));
      } else if (id == 1) {
        ret.add(subPackets.reduce((value, element) => value * element));
      } else if (id == 2) {
        ret.add(subPackets.reduce((value, element) => min(value, element)));
      } else if (id == 3) {
        ret.add(subPackets.reduce((value, element) => max(value, element)));
      } else if (id == 5) {
        ret.add((subPackets[0] > subPackets[1] ? 1 : 0));
      } else if (id == 6) {
        ret.add((subPackets[0] < subPackets[1] ? 1 : 0));
      } else if (id == 7) {
        ret.add((subPackets[0] == subPackets[1] ? 1 : 0));
      }
    }
    nr--;
  }
  return ret;
}

void solve(String bits) {
  second = packet(bits, bits.length, 1).first;
  print(first);
  print(second);
}

void main() {
  solve(transformToBits(File('input.txt').readAsStringSync()));
}
