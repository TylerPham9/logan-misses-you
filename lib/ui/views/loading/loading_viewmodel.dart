import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:logan_misses_you/ui/shared/constants.dart';
import 'package:logan_misses_you/app/locator.dart';
import 'package:logan_misses_you/app/router.gr.dart';

class LoadingViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();

  handleImagePrecache(BuildContext context) async {
    await precacheImage(AssetImage(templateImagePath), context);
    await precacheImage(AssetImage(placeholderImagePath), context);
    await Future.delayed(const Duration(seconds: 1));
    await _navigationService.navigateTo(Routes.homeViewRoute);
  }
}
