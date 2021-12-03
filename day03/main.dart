import 'dart:io';

void PartOne(List<String> numbers) {
  int epsilon = 0, gamma = 0, numberLength = numbers.first.length;
  List<int> F = List.filled(numberLength, 0);

  numbers.forEach((String number) {
    for (int i = 0; i < numberLength; i++) {
      F[i] += int.parse(number[i]);
    }
  });

  for (int i = numberLength - 1, bit = 1; i >= 0; i--, bit <<= 1) {
    if (F[i] * 2 > numbers.length) {
      gamma += bit;
    } else {
      epsilon += bit;
    }
  }

  print(gamma * epsilon);
}

int findBits(List<String> numbers, int position) {
  int bits = 0;
  numbers.forEach((String number) {
    bits += int.parse(number[position]);
  });
  return bits;
}

void PartTwo(List<String> numbers) {
  int oxigenGenerator = 0, co2Scrubber = 0, numberLength = numbers.first.length;
  List<String> oxigen = [...numbers];
  List<String> co2 = [...numbers];

  for (int pos = 0; pos < numberLength; pos++) {
    if (oxigen.length > 1) {
      oxigen.removeWhere((String number) => number[pos] == (findBits(oxigen, pos) * 2 >= oxigen.length ? '0' : '1'));
    }
    if (co2.length > 1) {
      co2.removeWhere((String number) => number[pos] == (findBits(co2, pos) * 2 >= co2.length ? '1' : '0'));
    }
  }

  for (int i = 0; i < numberLength; i++) {
    oxigenGenerator += ((int.parse(oxigen.single[i]) << (numberLength - i - 1)));
    co2Scrubber += ((int.parse(co2.single[i]) << (numberLength - i - 1)));
  }
  print(oxigenGenerator * co2Scrubber);
}

void main() {
  List<String> numbers = File('input.txt').readAsLinesSync();
  PartOne(numbers);
  PartTwo(numbers);
}
