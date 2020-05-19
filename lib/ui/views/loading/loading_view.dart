import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:stacked/stacked.dart';

import 'package:logan_misses_you/ui/shared/app_colors.dart';
import 'loading_viewmodel.dart';

class LoadingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoadingViewModel>.reactive(
      viewModelBuilder: () => LoadingViewModel(),
      onModelReady: (model) => model.handleImagePrecache(context),
      builder: (context, model, child) => Scaffold(
        backgroundColor: wolverineBlue,
        body: Center(
          child: SpinKitRing(
            color: wolverineYellow,
            size: 100.0,
          ),
        ),
      ),
    );
  }
}
