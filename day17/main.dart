import 'dart:io';
import 'dart:math';

void solve(List<int> target) {
  int best = target[2], count = 0;

  for (int x = 0; x <= target[1]; x++) {
    for (int y = target[2]; y < 10000; y++) {
      int vx = x, vy = y, xx = 0, yy = 0, bestY = 0;
      while (true) {
        xx += vx;
        yy += vy;
        bestY = max(bestY, yy);

        if (xx > target[1] || yy < target[2] || (vx == 0 && xx < target[0])) {
          break;
        } else if (xx >= target[0] && xx <= target[1] && yy >= target[2] && yy <= target[3]) {
          best = max(best, bestY);
          count++;
          break;
        }

        vx -= (vx > 0 ? 1 : 0);
        vy -= 1;
      }
    }
  }
  print(best);
  print(count);
}

void main() {
  List<int> target = File('input.txt').readAsStringSync().split(' ').map((item) => int.parse(item)).toList();
  solve(target);
}
