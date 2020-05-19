import 'package:auto_route/auto_route_annotations.dart';
import 'package:logan_misses_you/ui/views/home/home_view.dart';
import 'package:logan_misses_you/ui/views/loading/loading_view.dart';

@MaterialAutoRouter()
class $Router {
  @initial
  HomeView homeViewRoute;
  LoadingView loadingViewRoute;
}
