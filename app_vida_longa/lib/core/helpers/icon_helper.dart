import "package:flutter/material.dart";
import "package:flutter/widgets.dart";

abstract class IconHelper {
  static const double x16 = 16;
  static const double x24 = 24;
  static const double x32 = 32;
  static const double x64 = 64;
  static const double x128 = 128;
  static const double x256 = 256;
  static const double x512 = 512;

  static Image build({
    required String iconName,
    double size = x64,
    double? forceSize,
    Color? color,
  }) {
    assert(size >= 16);
    assert(size <= 512);

    final String pathSize = "_${size.toStringAsFixed(0)}";
    final String sizedIconPath = "assets/icons/$iconName$pathSize.png";

    return Image(
      fit: BoxFit.fill,
      image: AssetImage(sizedIconPath),
      width: forceSize ?? size,
      height: forceSize ?? size,
      color: color,
    );
  }
}
