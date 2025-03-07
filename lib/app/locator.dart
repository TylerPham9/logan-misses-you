import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'locator.iconfig.dart';

final locator = GetIt.instance;

@injectableInit
Future setupLocator() async {
  $initGetIt(locator);
}
