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

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  GlobalKey _globalKey = new GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  void _capturePng() async {
    if (await Permission.storage.request().isGranted) {
      try {
        RenderRepaintBoundary boundary =
            _globalKey.currentContext.findRenderObject();
        ui.Image image = await boundary.toImage(pixelRatio: 3.0);
        ByteData byteData =
            await image.toByteData(format: ui.ImageByteFormat.png);
        Uint8List pngBytes = byteData.buffer.asUint8List();

        await ImageGallerySaver.saveImage(pngBytes);
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        backgroundColor: Colors.blueGrey,
        bottomNavigationBar: BottomAppBar(
          child: CustomBottomAppBar(
            updateImageFromCamera: () => model.updateImage(ImageSource.camera),
            updateImageFromGallery: () =>
                model.updateImage(ImageSource.gallery),
            resetPositon: () => model.resetMatrix(),
            captureImage: () => _capturePng(),
          ),
        ),
        body: SafeArea(
          child: RepaintBoundary(
            key: _globalKey,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                MatrixGestureDetector(
                  // TODO: Make the base image transparent when update is being made
                  onMatrixUpdate: (m, tm, sm, rm) {
                    model.onMatrixUpdate(tm, sm, rm);
                  },
                  child: Container(
                    // alignment: Alignment.bottomCenter,
                    // width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height / 2,
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
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: FittedBox(
                    child: IgnorePointer(
                      ignoring: true,
                      child: Image(
                        image: AssetImage('assets/images/base.png'),
                        color: Color.fromRGBO(255, 255, 255, 1),
                        colorBlendMode: BlendMode.modulate,
                      ),
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
          icon: Icon(Icons.add_a_photo),
          onPressed: updateImageFromCamera,
        ),
        IconButton(
          icon: Icon(Icons.collections),
          onPressed: updateImageFromGallery,
        ),
        IconButton(
          icon: Icon(Icons.refresh),
          onPressed: resetPositon,
        ),
        IconButton(
          icon: Icon(Icons.file_download),
          onPressed: captureImage,
        ),
      ],
    );
  }
}
