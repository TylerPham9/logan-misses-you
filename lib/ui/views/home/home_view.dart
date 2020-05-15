import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:matrix_gesture_detector/matrix_gesture_detector.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stacked/stacked.dart';

import 'home_viewmodel.dart';

const colorDodgerBlue = Color(0xFF1D90F3);
const colorYellow = Color(0xFFFFFE03);

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final GlobalKey _globalKey = new GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  _displaySnackBar(BuildContext context, String text) {
    // TODO: Make it clickable and open gallery
    final snackBar = SnackBar(content: Text('Image saved to $text'));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  void _capturePng(BuildContext context) async {
    if (await Permission.storage.request().isGranted) {
      try {
        RenderRepaintBoundary boundary =
            _globalKey.currentContext.findRenderObject();
        ui.Image image = await boundary.toImage(pixelRatio: 3.0);
        // TODO: Add gif/video capabilities
        ByteData byteData =
            await image.toByteData(format: ui.ImageByteFormat.png);
        Uint8List pngBytes = byteData.buffer.asUint8List();

        String result = await ImageGallerySaver.saveImage(pngBytes);
        _displaySnackBar(context, result);
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.grey,
        bottomNavigationBar: BottomAppBar(
          color: colorDodgerBlue,
          child: CustomBottomAppBar(
            updateImageFromCamera: () => model.updateImage(ImageSource.camera),
            updateImageFromGallery: () =>
                model.updateImage(ImageSource.gallery),
            resetPositon: () => model.resetMatrix(),
            captureImage: () => _capturePng(context),
          ),
        ),
        body: SafeArea(
          child: RepaintBoundary(
            key: _globalKey,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Listener(
                  onPointerDown: (_) => model.onPointerDown(),
                  onPointerUp: (_) => model.onPointerUp(),
                  child: MatrixGestureDetector(
                    onMatrixUpdate: (m, tm, sm, rm) {
                      model.onMatrixUpdate(tm, sm, rm);
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.5,
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: AnimatedBuilder(
                        animation: model.transformMatrix,
                        builder: (context, child) {
                          return Transform(
                            transform: model.transformMatrix.value,
                            child: model.image,
                          );
                        },
                      ),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: FittedBox(
                    child: IgnorePointer(
                      ignoring: true,
                      child: model.templateImage,
                    ),
                    fit: BoxFit.fill,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      viewModelBuilder: () => HomeViewModel(),
    );
  }
}

class CustomBottomAppBar extends StatelessWidget {
  final Function updateImageFromCamera;
  final Function updateImageFromGallery;
  final Function resetPositon;
  final Function captureImage;

  const CustomBottomAppBar({
    Key key,
    this.updateImageFromCamera,
    this.updateImageFromGallery,
    this.resetPositon,
    this.captureImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: Icon(
            Icons.add_a_photo,
            color: colorYellow,
          ),
          onPressed: updateImageFromCamera,
        ),
        IconButton(
          icon: Icon(
            Icons.collections,
            color: colorYellow,
          ),
          onPressed: updateImageFromGallery,
        ),
        IconButton(
          icon: Icon(
            Icons.refresh,
            color: colorYellow,
          ),
          onPressed: resetPositon,
        ),
        IconButton(
          icon: Icon(
            Icons.file_download,
            color: colorYellow,
          ),
          onPressed: captureImage,
        ),
      ],
    );
  }
}
