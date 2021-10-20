import 'package:shared_preferences/shared_preferences.dart';
import 'package:get_it/get_it.dart';

GetIt injector = GetIt.instance;

class DependencyInjection {
  static Future<void> inject() async {
    final sharedPreferences = await SharedPreferences.getInstance();

    injector.registerSingleton<SharedPreferences>(sharedPreferences);
  }
}