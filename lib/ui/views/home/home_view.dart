import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:path_provider/path_provider.dart';

import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:image_picker/image_picker.dart';
import 'home_viewmodel.dart';

import 'package:matrix_gesture_detector/matrix_gesture_detector.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  // File _image;
  bool _opacity = false;
  GlobalKey _globalKey = new GlobalKey();

  var status = Permission.camera.status;
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

  Row bottomAppBarWithIcons(HomeViewModel model) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: Icon(Icons.add_a_photo),
          onPressed: () => model.updateImage(ImageSource.camera),
        ),
        IconButton(
          icon: Icon(Icons.collections),
          onPressed: () => model.updateImage(ImageSource.gallery),
        ),
        IconButton(
          icon: Icon(Icons.refresh),
          onPressed: () => model.resetMatrix(),
        ),
        IconButton(
          icon: Icon(Icons.file_download),
          onPressed: () => _capturePng,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        backgroundColor: Colors.blueGrey,
        bottomNavigationBar: BottomAppBar(child: bottomAppBarWithIcons(model)),

        // Testing multiple Gestures
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
                    // model.onMatrixUpdate(MatrixGestureDetector.compose(
                    //     model.transformMatrix.value, tm, sm, rm));
                  },
                  child: AnimatedBuilder(
                    animation: model.transformMatrix,
                    builder: (context, child) {
                      return Transform(
                        // alignment: FractionalOffset.center,
                        transform: model.transformMatrix.value,
                        child: model.image,
                      );
                    },
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
                        color: Color.fromRGBO(255, 255, 255, 1.0),
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

        // ! ORIGINAL
        // body: SafeArea(
        //   child: RepaintBoundary(
        //     key: _globalKey,
        //     child: MatrixGestureDetector(
        //       clipChild: true,

        //       // TODO: Make the base image transparent when update is being made
        //       onMatrixUpdate: (m, tm, sm, rm) {
        //         model.onMatrixUpdate(MatrixGestureDetector.compose(
        //             model.transformMatrix.value, tm, sm, rm));
        //         // m = Matrix4.identity();
        //       },
        //       child: Stack(
        //         children: [
        //           AnimatedBuilder(
        //             animation: model.transformMatrix,
        //             builder: (context, child) {
        //               return Transform(
        //                 alignment: FractionalOffset.center,
        //                 transform: model.transformMatrix.value,
        //                 child: model.image,
        //               );
        //             },
        //           ),
        //           IgnorePointer(
        //             ignoring: false,
        //             child: Container(
        //               width: MediaQuery.of(context).size.width,
        //               height: MediaQuery.of(context).size.height,
        //               child: FittedBox(
        //                 child: Image(
        //                   image: AssetImage('assets/images/base.png'),
        //                   color: Color.fromRGBO(255, 255, 255, 1.0),
        //                   colorBlendMode: BlendMode.modulate,
        //                 ),
        //                 fit: BoxFit.fill,
        //               ),
        //             ),
        //           ),
        //         ],
        //       ),
        //     ),
        //   ),
        // ),

        // body: Center(
        //   child: GestureDetector(

        //     onScaleUpdate: (ScaleUpdateDetails details) {
        //       model.onScaleUpdate(details);
        //     },
        //     onScaleStart: (ScaleStartDetails details) {
        //       model.onScaleStart();
        //     },
        //     onScaleEnd: (ScaleEndDetails details) => {model.onScaleEnd()},

        //     // onScaleStart: true
        //     //     ? (ScaleStartDetails details) {
        //     //         model.updatePreviousScale();
        //     //       }
        //     //     : null,
        //     // onScaleUpdate: true
        //     //     ? (ScaleUpdateDetails details) {
        //     //         model.updateScale(details.scale);
        //     //       }
        //     //     : null,
        //     // onScaleEnd: true
        //     //     ? (ScaleEndDetails details) {
        //     //         model.clearScale();
        //     //       }
        //     //     : null,
        //     // onPanUpdate: true
        //     //     ? (tapInfo) {
        //     //         model.updatePosition(tapInfo.delta.dx, tapInfo.delta.dy);
        //     //       }
        //     //     : null,
        //     child: RepaintBoundary(
        //       key: _globalKey,
        //       child: Stack(
        //         children: [
        //           model.image,
        //           // Positioned(
        //           //   top: yPosition,
        //           //   left: xPosition,
        //           //   child: _image == null
        //           //       ? Text('No image selected.')
        //           //       : Transform(
        //           //           transform: Matrix4.diagonal3(
        //           //               new Vector3(scale, scale, scale)),
        //           //           alignment: FractionalOffset.center,
        //           //           child: Image.file(_image)),
        //           // ),
        //           // FittedBox(
        //           //   child: Image(
        //           //     image: AssetImage('assets/images/base.png'),
        //           //   ),
        //           //   fit: BoxFit.fill,
        //           // ),
        //           // Text(model.title),
        //         ],
        //       ),
        //     ),
        //   ),
        // ),
        // body: MatrixGestureDetector(
        //   onMatrixUpdate: (m, tm, sm, rm) {
        //     notifier.value = m;
        //   },
        //   child: AnimatedBuilder(
        //       animation: notifier,
        //       builder: (context, child) {
        //         return Transform(
        //           transform: notifier.value,
        //           child: Image(
        //             image: AssetImage('assets/images/base.png'),
        //           ),
        //         );
        //       }),

        // Center(
        //   child: Image(
        //     image: AssetImage('assets/images/base.png'),
        //   ),
        // ),
      ),
      viewModelBuilder: () => HomeViewModel(),
    );
  }
}
