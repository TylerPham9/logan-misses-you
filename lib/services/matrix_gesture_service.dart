import 'package:flutter/rendering.dart';
import 'package:matrix_gesture_detector/matrix_gesture_detector.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class MatrixGestureService {
  Matrix4 composeMatrix({
    Matrix4 transformMatrix,
    Matrix4 translationMatrix,
    Matrix4 scaleMatrix,
    Matrix4 rotationMatrix,
  }) {
    return MatrixGestureDetector.compose(
        transformMatrix, translationMatrix, scaleMatrix, rotationMatrix);
  }
}
