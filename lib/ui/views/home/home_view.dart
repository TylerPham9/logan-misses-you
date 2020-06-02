import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:matrix_gesture_detector/matrix_gesture_detector.dart';
import 'package:stacked/stacked.dart';

import 'package:logan_misses_you/ui/shared/app_colors.dart';
import 'home_viewmodel.dart';

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

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.grey,
        bottomNavigationBar: BottomAppBar(
          color: wolverineBlue,
          child: CustomBottomAppBar(
            updateImageFromCamera: () => model.updateImage(false),
            updateImageFromGallery: () => model.updateImage(true),
            resetPositon: () => model.resetMatrix(),
            captureImage: () async {
              String filePath = await model
                  .captureImage(_globalKey.currentContext.findRenderObject());
              _displaySnackBar(context, filePath);
            },
            aboutDialog: () => model.showCustomAboutDialog(context),
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
                            child: model.userImage,
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
                Container(
                  alignment: Alignment(0.0, 0.0),
                  child: model.isBusy
                      ? SpinKitRing(
                          color: wolverineBlue,
                          size: 100.0,
                        )
                      : null,
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
  final Function aboutDialog;

  const CustomBottomAppBar({
    Key key,
    this.updateImageFromCamera,
    this.updateImageFromGallery,
    this.resetPositon,
    this.captureImage,
    this.aboutDialog,
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
            color: wolverineYellow,
          ),
          onPressed: updateImageFromCamera,
        ),
        IconButton(
          icon: Icon(
            Icons.collections,
            color: wolverineYellow,
          ),
          onPressed: updateImageFromGallery,
        ),
        IconButton(
          icon: Icon(
            Icons.refresh,
            color: wolverineYellow,
          ),
          onPressed: resetPositon,
        ),
        IconButton(
          icon: Icon(
            Icons.file_download,
            color: wolverineYellow,
          ),
          onPressed: captureImage,
        ),
        IconButton(
          icon: Icon(
            Icons.info_outline,
            color: wolverineYellow,
          ),
          onPressed: aboutDialog,
        ),
      ],
    );
  }
}
