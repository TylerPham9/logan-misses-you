import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stacked/stacked.dart';
import 'package:logan_misses_you/app/locator.dart';
import 'package:logan_misses_you/ui/shared/constants.dart';
import 'package:logan_misses_you/ui/widgets/app_icon.dart';
import 'package:logan_misses_you/services/matrix_gesture_service.dart';
import 'package:logan_misses_you/services/media_service.dart';

class HomeViewModel extends BaseViewModel {
  final MediaService _mediaService = locator<MediaService>();
  final MatrixGestureService _matrixGestureService =
      locator<MatrixGestureService>();

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

  void updateImage(bool fromGallery) async {
    // TODO: I dont like this conditional
    try {
      if (fromGallery) {
        if (await Permission.storage.request().isGranted) {
          _getImageFromPicker(fromGallery);
        }
      } else {
        if (await Permission.camera.request().isGranted) {
          _getImageFromPicker(fromGallery);
        }
      }
      // TODO: need error states
    } catch (e) {
      print(e);
      throw e;
    }
  }

  void _getImageFromPicker(bool fromGallery) async {
    File newImage = await _mediaService.getImage(fromGallery: fromGallery);

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
    _transformMatrix.value = _matrixGestureService.composeMatrix(
        transformMatrix: _transformMatrix.value,
        translationMatrix: translationMatrix,
        scaleMatrix: scaleMatrix,
        rotationMatrix: rotationMatrix);
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

  void showCustomAboutDialog(BuildContext context) {
    final double _padding = 20.0;
    return showAboutDialog(
      context: context,
      applicationName: applicationName,
      applicationVersion: '1.0.1',
      applicationLegalese:
          'This application has been approved for all audiences',
      applicationIcon: AppIcon(),
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: _padding),
          child: Text('Instructions'),
        ),
        Text('1. Upload images from your camera or image gallery'),
        Text('2. Use two fingers to reposition your image'),
        Text('3. Download and enjoy!'),
        Padding(
          padding: EdgeInsets.only(top: _padding),
          child: Text('Made with Flutter'),
        ),
      ],
    );
  }
}
