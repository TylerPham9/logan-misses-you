import 'package:injectable/injectable.dart';
import 'package:stacked_services/stacked_services.dart';

@module
abstract class ThirdPartyServicesModule {
  @singleton
  NavigationService get navigationServices;
  @singleton
  DialogService get dialogServices;
}
