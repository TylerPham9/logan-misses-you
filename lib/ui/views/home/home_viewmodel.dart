import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:matrix_gesture_detector/matrix_gesture_detector.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stacked/stacked.dart';
import 'package:logan_misses_you/ui/shared/constants.dart';

class HomeViewModel extends BaseViewModel {
  // ? I don't want to use Value Notifier here
  ValueNotifier<Matrix4> _transformMatrix = ValueNotifier(Matrix4.identity());
  bool _isInUse = false;
  Image _userImage = Image.asset(placeholderImagePath);

  ValueNotifier<Matrix4> get transformMatrix => _transformMatrix;
  Image get userImage => _userImage;

  Image get templateImage {
    return Image(
      image: AssetImage(templateImagePath),
      color: Color.fromRGBO(255, 255, 255, _isInUse ? 0.75 : 1.0),
      colorBlendMode: BlendMode.modulate,
    );
  }

  void updateImage(ImageSource source) async {
    // TODO: need error states
    try {
      if (source == ImageSource.camera) {
        if (await Permission.camera.request().isGranted) {
          _getImageFromPicker(source);
        }
      } else {
        if (await Permission.storage.request().isGranted) {
          _getImageFromPicker(source);
        }
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }

  void _getImageFromPicker(ImageSource source) async {
    File newImage = await ImagePicker.pickImage(source: source);

    // ImagePicker returns null if user presses back button
    // only update image if user selects an image
    if (newImage != null) {
      _userImage = Image.file(newImage);
      resetMatrix();
    }
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

  Future<String> captureImage(RenderRepaintBoundary boundary) async {
    String result = '';
    // TODO: need error states
    try {
      if (await Permission.storage.request().isGranted) {
        setBusy(true);
        ui.Image image = await boundary.toImage(pixelRatio: 3.0);
        // TODO: Add gif/video capabilities
        ByteData byteData =
            await image.toByteData(format: ui.ImageByteFormat.png);

        Uint8List pngBytes = byteData.buffer.asUint8List();
        String result = await ImageGallerySaver.saveImage(pngBytes);

        setBusy(false);
        return result;
      }
    } catch (e) {
      print(e);
      throw e;
    }
    return result;
  }
}
