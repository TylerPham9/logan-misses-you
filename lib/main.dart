import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logan_misses_you/app/locator.dart';
import 'package:stacked_services/stacked_services.dart';

import 'app/router.gr.dart';

Future<void> main() async {
  try {
    await setupLocator();
    runApp(MyApp());
  } catch (error) {
    print('Locator setup has failed');
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: Routes.loadingViewRoute,
      onGenerateRoute: Router().onGenerateRoute,
      navigatorKey: locator<NavigationService>().navigatorKey,
    );
  }
}
