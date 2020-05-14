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

  // EditMode _editMode;
  // double _xPosition = 0.0;
  // double _yPosition = 0.0;

  // double _scale = 1.0;
  // double _previousScale;

  // double _rotation = 0.0;
  // double _lastRotation = 0.0;

  String _title = 'Home View';

  String get title => _title;
  // EditMode get editMode => _editMode;
  ValueNotifier<Matrix4> get transformMatrix => _transformMatrix;
  // bool get panEditMode => _editMode == EditMode.pan;
  // bool get scaleEditMode => _editMode == EditMode.scale;
  // bool get rotateEditMode => _editMode == EditMode.rotate;

  Widget get image {
    // return Positioned.fromRect(
    //   rect: Rect.fromPoints(
    //     Offset(_xPosition - 0, _yPosition - 0),
    //     Offset(_xPosition + 300.0, _yPosition + 300.0),
    //   ),
    //   // top: _yPosition,
    //   // left: _xPosition,
    //   child: _image == null
    //       ? Text('No Image Selected.')
    //       : Transform(
    //           transform: Matrix4.diagonal3(new Vector3(_scale, _scale, _scale)),
    //           alignment: FractionalOffset.center,
    //           child: Image.file(_image)),
    // );

    if (_image == null) {
      return Image.asset(
        'assets/images/image-placeholder.png',
        // width: 200.0,
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

  // EditMode _updateEditMode(EditMode type) {
  //   return _editMode == type ? null : type;
  // }

  // void updateEditModeToPan() {
  //   _editMode = _updateEditMode(EditMode.pan);
  //   notifyListeners();
  // }

  // void updateEditModeToScale() {
  //   _editMode = _updateEditMode(EditMode.scale);
  //   notifyListeners();
  // }

  // void updateEditModeToRotate() {
  //   _editMode = _updateEditMode(EditMode.rotate);
  //   notifyListeners();
  // }

  // void updatePosition(double x, double y) {
  //   _yPosition += y;
  //   _xPosition += x;
  //   notifyListeners();
  // }

  // void updatePreviousScale() {
  //   _previousScale = _scale;
  //   notifyListeners();
  // }

  // void updateScale(double scaleChange) {
  //   _scale = _previousScale * scaleChange;
  //   notifyListeners();
  // }

  // void clearScale() {
  //   _previousScale = null;
  //   notifyListeners();
  // }

  // void onScaleStart() {
  //   _previousScale = _scale;
  //   notifyListeners();
  // }

  // void onScaleUpdate(ScaleUpdateDetails details) {
  //   _rotation += _lastRotation - details.rotation;
  //   _lastRotation = details.rotation;
  //   // _xPosition = details.focalPoint.dx;
  //   _xPosition = details.focalPoint.dx;
  //   _yPosition = details.focalPoint.dy;

  //   _scale = _previousScale * details.scale;
  //   notifyListeners();
  // }

  // void onScaleEnd() {
  //   _previousScale = null;
  //   notifyListeners();
  // }

  // void onMatrixUpdate(Matrix4 m, Matrix4 tm, Matrix4 sm, Matrix4 rm) {
  //   // setBusy(true);
  //   // TODO: add setbusy for keeping track of when the image is being moved

  //   _transformMatrix.value = MatrixGestureDetector.compose(
  //     _transformMatrix.value,
  //     tm,
  //     sm,
  //     rm,
  //   );
  //   notifyListeners();
  // }
  void onMatrixUpdate(
      Matrix4 translationMatrix, Matrix4 scaleMatrix, Matrix4 rotationMatrix) {
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
