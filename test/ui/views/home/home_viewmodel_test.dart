import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logan_misses_you/ui/views/home/home_viewmodel.dart';

void main() {
  group('Home ViewModel Tests', () {
    var homeViewModel;
    setUpAll(() {
      homeViewModel = HomeViewModel();
    });
    test('Template image starts opaque', () {
      Color initialColorState = Color(0xffffffff);

      var defaultTemplateImage = homeViewModel.templateImage;
      expect(defaultTemplateImage.color, initialColorState);
    });

    test('Template image changes opacity when touched', () {
      Color initialColorState = Color(0xffffffff);

      homeViewModel.onPointerDown();
      var downTemplateImage = homeViewModel.templateImage;
      expect(
          downTemplateImage.color,
          isNot(
            equals(initialColorState),
          ));
      homeViewModel.onPointerUp();
      var upTemplateImage = homeViewModel.templateImage;
      expect(upTemplateImage.color, equals(initialColorState));
    });

    test('Reset Matrix', () {
      expect(homeViewModel.transformMatrix.value, Matrix4.identity());
    });
  });
}
