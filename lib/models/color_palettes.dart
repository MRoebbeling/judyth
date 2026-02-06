import 'package:flutter/services.dart';
import 'dart:convert';

class ColorPalette {
  final int id;
  final String paletteName;
  final List<List<int>> color;

  ColorPalette({required this.id, required this.paletteName, required this.color});

  ColorPalette.fromJson(Map<String, dynamic> json)
    : id = json['palette-id'],
      paletteName = json['palette-name'],
      color = (json['colors'] as Map<String, dynamic>).values.map<List<int>>((colorMap) {
        if (colorMap is String && colorMap.startsWith('#') && (colorMap.length == 9)) {
          // Parse hex string
          int alpha = int.parse(colorMap.substring(1, 3), radix: 16);
          int red = int.parse(colorMap.substring(3, 5), radix: 16);
          int green = int.parse(colorMap.substring(5, 7), radix: 16);
          int blue = int.parse(colorMap.substring(7, 9), radix: 16);

          return [alpha, red, green, blue];
        } else if (colorMap is Map<String, dynamic>) {
          return [colorMap['alpha'] as int, colorMap['red'] as int, colorMap['green'] as int, colorMap['blue'] as int];
        } else {
          throw Exception('Invalid color format');
        }
      }).toList();
}

Future<Map<int, ColorPalette>> loadColorPalettes() async {
  final String response = await rootBundle.loadString('assets/Judith-colors.json');
  final data = await json.decode(response);
  //print('Json Color Palettes:, $data');
  //print('Länge: ${data.length}');
  // Load Color Palettes
  List colorPalettesData = data["ColorPalettes"];
  //print(colorPalettesData.length);
  Map<int, ColorPalette> colorPalettes = {};
  for (var index = 0; index < colorPalettesData.length; index++) {
    var paletteData = colorPalettesData[index].values.first;
    ColorPalette palette = ColorPalette.fromJson(paletteData);
    colorPalettes[palette.id] = palette;
    print('Loaded Palette ID: ${palette.id}, Name: ${palette.paletteName}, Colors : ${palette.color}');
  }
  //print(colorPalettes[1]!.paletteName);
  return colorPalettes;
}
