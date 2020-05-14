import 'dart:io';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:image_picker/image_picker.dart';
import 'package:matrix_gesture_detector/matrix_gesture_detector.dart';

enum EditMode { pan, scale, rotate }

class HomeViewModel extends BaseViewModel {
  // ? I don't want to use Value Notifier here
  ValueNotifier<Matrix4> _transformMatrix = ValueNotifier(Matrix4.identity());
  File _image;
  String _title = 'Home View';

  String get title => _title;
  ValueNotifier<Matrix4> get transformMatrix => _transformMatrix;

  Image get image {
    if (_image == null) {
      return Image.asset(
        'assets/images/image-placeholder.png',
      );
    } else {
      return Image.file(_image);
    }
  }

  void updateImage(ImageSource source) async {
    _image = await ImagePicker.pickImage(source: source);
    resetMatrix();
    notifyListeners();
  }

  void onMatrixUpdate(
    Matrix4 translationMatrix,
    Matrix4 scaleMatrix,
    Matrix4 rotationMatrix,
  ) {
    // setBusy(true);
    // TODO: add setbusy for keeping track of when the image is being moved

    _transformMatrix.value = MatrixGestureDetector.compose(
        _transformMatrix.value, translationMatrix, scaleMatrix, rotationMatrix);
    notifyListeners();
  }

  void resetMatrix() {
    _transformMatrix.value = Matrix4.identity();
    notifyListeners();
  }
}
