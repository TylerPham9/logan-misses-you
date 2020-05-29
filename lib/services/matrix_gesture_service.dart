import 'package:flutter/rendering.dart';
import 'package:matrix_gesture_detector/matrix_gesture_detector.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class MatrixGestureService {
  // Future<File> getImage({bool fromGallery}) {
  //   return ImagePicker.pickImage(
  //       source: fromGallery ? ImageSource.gallery : ImageSource.camera);
  // }

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
