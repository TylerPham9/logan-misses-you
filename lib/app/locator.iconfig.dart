// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:logan_misses_you/services/third_party_services_module.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:logan_misses_you/services/matrix_gesture_service.dart';
import 'package:logan_misses_you/services/media_service.dart';
import 'package:get_it/get_it.dart';

void $initGetIt(GetIt g, {String environment}) {
  final thirdPartyServicesModule = _$ThirdPartyServicesModule();
  g.registerLazySingleton<MatrixGestureService>(() => MatrixGestureService());
  g.registerLazySingleton<MediaService>(() => MediaService());

  //Eager singletons must be registered in the right order
  g.registerSingleton<DialogService>(thirdPartyServicesModule.dialogServices);
  g.registerSingleton<NavigationService>(
      thirdPartyServicesModule.navigationServices);
}

class _$ThirdPartyServicesModule extends ThirdPartyServicesModule {
  @override
  DialogService get dialogServices => DialogService();
  @override
  NavigationService get navigationServices => NavigationService();
}
