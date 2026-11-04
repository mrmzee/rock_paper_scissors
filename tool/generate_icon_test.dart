// Renders the branding PNGs from the in-app artwork:
//   flutter test tool/generate_icon_test.dart
// then regenerate the platform files:
//   dart run flutter_launcher_icons && dart run flutter_native_splash:create
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rock_paper_scissors/core/theme/app_theme.dart';

import 'branding/app_icon_art.dart';

void main() {
  const size = 1024.0;

  final outputs = <String, AppIconArt>{
    'assets/branding/icon.png': const AppIconArt(),
    'assets/branding/icon_foreground.png':
        const AppIconArt(withBackground: false, contentScale: 0.62),
    'assets/branding/splash.png':
        const AppIconArt(withBackground: false, contentScale: 0.85),
  };

  testWidgets('generate branding images', (tester) async {
    tester.view
      ..physicalSize = const Size.square(size)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    for (final MapEntry(key: path, value: art) in outputs.entries) {
      final boundary = GlobalKey();
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(disableAnimations: true),
          child: Theme(
            data: AppTheme.light,
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: Center(
                child: RepaintBoundary(key: boundary, child: art),
              ),
            ),
          ),
        ),
      );

      await tester.runAsync(() async {
        await Future<void>.delayed(const Duration(milliseconds: 500));
      });
      await tester.pump();

      final bytes = await tester.runAsync(() async {
        final render = boundary.currentContext!.findRenderObject()!
            as RenderRepaintBoundary;
        final image = await render.toImage();
        final data = await image.toByteData(format: ui.ImageByteFormat.png);
        return data!.buffer.asUint8List();
      });

      File(path)
        ..createSync(recursive: true)
        ..writeAsBytesSync(bytes!);
    }
  });
}
