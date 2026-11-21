import 'dart:convert';
import 'dart:io';
import 'package:image/image.dart' as img;
void main(List<String> a) {
  final im = img.decodePng(File(a[0]).readAsBytesSync())!;
  final out = a[1];
  Directory(out).createSync(recursive: true);
  // a[2] = JSON file: {"name": [x0, y0, x1, y1], ...} (boxes from find_pieces.dart)
  final items = (jsonDecode(File(a[2]).readAsStringSync()) as Map).map((k, v) => MapEntry(k as String, (v as List).cast<int>()));
  items.forEach((name, b) {
    final c = img.copyCrop(im, x: b[0], y: b[1], width: b[2] - b[0], height: b[3] - b[1]).convert(numChannels: 4);
    final w = c.width, h = c.height;
    bool white(int x, int y) { final p = c.getPixel(x, y); return p.r >= 240 && p.g >= 240 && p.b >= 240; }
    final bg = List.generate(h, (_) => List.filled(w, false));
    final st = <(int, int)>[];
    for (var x = 0; x < w; x++) { st.add((x, 0)); st.add((x, h - 1)); }
    for (var y = 0; y < h; y++) { st.add((0, y)); st.add((w - 1, y)); }
    while (st.isNotEmpty) {
      final (x, y) = st.removeLast();
      if (x < 0 || y < 0 || x >= w || y >= h || bg[y][x] || !white(x, y)) continue;
      bg[y][x] = true;
      st..add((x + 1, y))..add((x - 1, y))..add((x, y + 1))..add((x, y - 1));
    }
    for (var y = 0; y < h; y++) for (var x = 0; x < w; x++) {
      final p = c.getPixel(x, y);
      if (bg[y][x]) { p.a = 0; continue; }
      var near = false;
      for (final (dx, dy) in [(1, 0), (-1, 0), (0, 1), (0, -1), (1, 1), (-1, -1), (1, -1), (-1, 1)]) {
        final nx = x + dx, ny = y + dy;
        if (nx >= 0 && ny >= 0 && nx < w && ny < h && bg[ny][nx]) near = true;
      }
      final m = [p.r, p.g, p.b].reduce((s, t) => s < t ? s : t);
      if (near && m > 150) { // light fringe pixel: fade and tint to outline colour
        final al = ((255 - m) / 105).clamp(0.0, 1.0);
        p.r = 0x2D; p.g = 0x2A; p.b = 0x4A; p.a = (al * 255).round();
      }
    }
    // trim to content with 2px pad
    final t = img.trim(c, mode: img.TrimMode.transparent);
    File('$out/$name.png').writeAsBytesSync(img.encodePng(t));
    print('$name ${t.width}x${t.height}');
  });
}
