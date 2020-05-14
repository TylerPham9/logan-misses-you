import 'dart:io';
// import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:path_provider/path_provider.dart';
// import 'package:path_provider_macos/path_provider_macos.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';

import 'package:vector_math/vector_math_64.dart' show Vector3;

import 'ui/views/home/home_view.dart';
import 'ui/views/home/demo_app.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: HomeView()
        // home: DemoApp()
        // home: MyHomePage(title: 'Flutter Demo Home Page'),
        // home: ControllerExample()
        );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GlobalKey _globalKey = new GlobalKey();
  File _image;

  bool inside = false;
  Uint8List imageInMemory;
  double xPosition = 0;
  double yPosition = 0;
  double scale = 1.0;
  double previousScale;

  double opacity = 1;
  bool condition = true;

  void getImage(ImageSource source) async {
    // var image = await ImagePicker.r
    var image = await ImagePicker.pickImage(source: source);

    setState(() {
      _image = image;
    });
  }

  Future<Uint8List> _capturePng() async {
    try {
      print('inside');
      final directory = await getExternalStorageDirectory();
      final myImagePath = '${directory.path}/MyImages';
      final myImgDir = await new Directory(myImagePath).create();

      inside = true;
      RenderRepaintBoundary boundary =
          _globalKey.currentContext.findRenderObject();
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();
      print('png done');
      setState(() {
        imageInMemory = pngBytes;
        inside = false;
      });

      print(myImagePath);
      var file = File("$myImagePath/image_test.jpg")
        ..writeAsBytesSync(pngBytes);

      return pngBytes;
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Image Picker Example'),
      ),

      // body: Container(
      //   child: _image == null
      //       ? Text('No image selected.')
      //       : ClipRect(
      //           child: PhotoView.customChild(
      //             child: Image.file(_image),
      //           ),
      //         ),
      // ),

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
      //           // ),,
      body: Center(
        child: GestureDetector(
          onScaleStart: condition
              ? (ScaleStartDetails details) {
                  setState(() {
                    previousScale = scale;
                  });
                }
              : null,
          onScaleUpdate: condition
              ? (ScaleUpdateDetails details) {
                  setState(() {
                    scale = previousScale * details.scale;
                  });
                }
              : null,
          onScaleEnd: condition
              ? (ScaleEndDetails details) {
                  setState(() {
                    previousScale = null;
                  });
                }
              : null,
          // onPanUpdate: (tapInfo) {
          //   setState(() {
          //     xPosition += tapInfo.delta.dx;
          //     yPosition += tapInfo.delta.dy;
          //   });
          // },
          child: RepaintBoundary(
            key: _globalKey,
            child: Stack(
              children: [
                Positioned(
                  top: yPosition,
                  left: xPosition,
                  child: _image == null
                      ? Text('No image selected.')
                      : Transform(
                          transform: Matrix4.diagonal3(
                              new Vector3(scale, scale, scale)),
                          alignment: FractionalOffset.center,
                          child: Image.file(_image)),
                ),
                FittedBox(
                  child: Image(
                    image: AssetImage('assets/images/base.png'),
                  ),
                  fit: BoxFit.fill,
                ),
              ],
            ),
          ),
        ),
      ),

      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(Icons.add_a_photo),
              onPressed: () {
                getImage(ImageSource.camera);
              },
            ),
            IconButton(
              icon: Icon(Icons.collections),
              onPressed: () {
                getImage(ImageSource.gallery);
              },
            ),
            IconButton(
              icon: Icon(Icons.file_download),
              onPressed: _capturePng,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        setState(() {
          condition = !condition;
        });
        print(condition);
      }),
      // floatingActionButton: FloatingActionButton(
      //     onPressed: getImage, tooltip: 'Pick Image', child: Icon(Icons.camera)
      //     // child: Icon(Icons.add_a_photo),
      //     ),
    );
  }
}

// class MoveableStackItem extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return _MoveableStackItemState();
//   }
// }

// class _MoveableStackItemState extends State<MoveableStackItem> {
//   double xPosition = 0;
//   double yPosition = 0;
//   Color color;
//   @override
//   void initState() {
//     // color = RandomColor().randomColor();
//     color = Colors.blue;
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Positioned(
//       top: yPosition,
//       left: xPosition,
//       child: GestureDetector(
//         onPanUpdate: (tapInfo) {
//           setState(() {
//             xPosition += tapInfo.delta.dx;
//             yPosition += tapInfo.delta.dy;
//           });
//         },
//         child: Container(
//           width: 150,
//           height: 150,
//           color: color,
//         ),
//       ),
//     );
//   }
// }

// Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           GestureDetector(
//             onPanUpdate: (tapInfo) {
//               setState(() {
//                 xPosition += tapInfo.delta.dx;
//                 yPosition += tapInfo.delta.dy;
//               });
//             },
//             child: RepaintBoundary(
//               key: _globalKey,
//               child: Stack(
//                 children: [
//                   Positioned(
//                     top: yPosition,
//                     left: xPosition,
//                     child: _image == null
//                         ? Text('No image selected.')
//                         : Image.file(_image),
//                   ),
//                   MoveableStackItem(),
//                   FittedBox(
//                     child: Image(
//                       image: AssetImage('assets/images/base.png'),
//                       fit: BoxFit.fill,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           // inside
//           //     ? CircularProgressIndicator()
//           //     : imageInMemory != null
//           //         ? Container(
//           //             child: Image.memory(imageInMemory),
//           //             margin: EdgeInsets.all(10))
//           //         : Container(),
//         ],
//       ),
