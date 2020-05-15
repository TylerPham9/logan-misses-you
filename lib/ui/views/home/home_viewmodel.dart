import 'dart:io';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:image_picker/image_picker.dart';
import 'package:matrix_gesture_detector/matrix_gesture_detector.dart';

const String templateImagePath = 'assets/images/base.png';
const String placeholderImagePath = 'assets/images/image-placeholder.png';

class HomeViewModel extends BaseViewModel {
  // ? I don't want to use Value Notifier here
  ValueNotifier<Matrix4> _transformMatrix = ValueNotifier(Matrix4.identity());
  bool _isInUse = false;
  File _image;

  ValueNotifier<Matrix4> get transformMatrix => _transformMatrix;

  Image get image {
    if (_image == null) {
      return Image.asset(
        placeholderImagePath,
      );
    } else {
      return Image.file(_image);
    }
  }

  Image get templateImage {
    return Image(
      image: AssetImage(templateImagePath),
      color: Color.fromRGBO(255, 255, 255, _isInUse ? 0.75 : 1.0),
      colorBlendMode: BlendMode.modulate,
    );
  }

  void updateImage(ImageSource source) async {
    _image = await ImagePicker.pickImage(source: source);
    resetMatrix();
  }

  void onMatrixUpdate(
    Matrix4 translationMatrix,
    Matrix4 scaleMatrix,
    Matrix4 rotationMatrix,
  ) {
    _transformMatrix.value = MatrixGestureDetector.compose(
        _transformMatrix.value, translationMatrix, scaleMatrix, rotationMatrix);
    notifyListeners();
  }

  void resetMatrix() {
    _transformMatrix.value = Matrix4.identity();
    notifyListeners();
  }

  void onPointerDown() {
    _isInUse = true;
    notifyListeners();
  }

  void onPointerUp() {
    _isInUse = false;
    notifyListeners();
  }
}
