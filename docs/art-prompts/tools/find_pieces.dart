import 'dart:io';
import 'package:image/image.dart' as img;
void main(List<String> a) {
  final im = img.decodePng(File(a[0]).readAsBytesSync())!;
  final w = im.width, h = im.height;
  // coarse grid (8px cells) of "ink"; flood-fill cells with radius to merge nearby parts.
  const c = 8;
  final gw = (w + c - 1) ~/ c, gh = (h + c - 1) ~/ c;
  final ink = List.generate(gh, (_) => List.filled(gw, false));
  for (var y = 0; y < h; y++) {
    for (var x = 0; x < w; x++) {
      final p = im.getPixel(x, y);
      if (p.r < 245 || p.g < 245 || p.b < 245) ink[y ~/ c][x ~/ c] = true;
    }
  }
  final seen = List.generate(gh, (_) => List.filled(gw, false));
  const r = 6; // merge distance in cells (48px)
  final boxes = <List<int>>[];
  for (var y = 0; y < gh; y++) for (var x = 0; x < gw; x++) {
    if (!ink[y][x] || seen[y][x]) continue;
    var x0 = x, x1 = x, y0 = y, y1 = y;
    final st = [(x, y)]; seen[y][x] = true;
    while (st.isNotEmpty) {
      final (cx, cy) = st.removeLast();
      for (var dy = -r; dy <= r; dy++) for (var dx = -r; dx <= r; dx++) {
        final nx = cx + dx, ny = cy + dy;
        if (nx < 0 || ny < 0 || nx >= gw || ny >= gh) continue;
        if (!ink[ny][nx] || seen[ny][nx]) continue;
        seen[ny][nx] = true; st.add((nx, ny));
        if (nx < x0) x0 = nx; if (nx > x1) x1 = nx; if (ny < y0) y0 = ny; if (ny > y1) y1 = ny;
      }
    }
    boxes.add([x0 * c, y0 * c, (x1 + 1) * c, (y1 + 1) * c]);
  }
  boxes.sort((p, q) => ((p[1] ~/ 300) - (q[1] ~/ 300)) != 0 ? (p[1] ~/ 300) - (q[1] ~/ 300) : p[0] - q[0]);
  for (var i = 0; i < boxes.length; i++) print('$i ${boxes[i]}');
}
