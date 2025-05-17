import 'package:flutter_ui/repository/localStorage/storage.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

IStorage get storage => locator<PrefsStorage>();

abstract class DependencyInjectionEnvironment {
  static Future<void> setup() async {
    locator.registerLazySingleton<PrefsStorage>(() => PrefsStorage());
    await storage.init();
  }
}
