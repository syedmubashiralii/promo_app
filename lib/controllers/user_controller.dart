import 'package:flutter_ui/locator.dart';
import 'package:flutter_ui/repository/user_repository/user_repository.dart';
import 'package:flutter_ui/utils/http/utils.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  final UserRepository userRepository;
  UserController({required this.userRepository});

  final isLoading = false.obs;
  final registerLoading = false.obs;
  final isVisible = true.obs;
  final isPasswordVisible = true.obs;

  void togglePasswordVisibility() {
    isVisible.value = !isVisible.value;
  }

  void toggleIsPasswordVisible() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    isLoading.value = true;
    try {
      final data = await userRepository.login(email: email, password: password);
      await storage.setUser(data);
      return null;
    } catch (e, s) {
      $debugLog(e, stackTrace: s);
      return e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<String?> register({
    required String affiliationId,
    required String name,
    required String email,
    required String password,
    required String location,
    required String phoneNumber,
    required String dob,
  }) async {
    registerLoading.value = true;
    try {
      await userRepository.register(
        email: email,
        password: password,
        name: name,
        affiliationId: affiliationId,
        location: location,
        phoneNumber: phoneNumber,
        dob: dob,
      );
      return null;
    } catch (e) {
      $debugLog(e);
      return e.toString();
    } finally {
      registerLoading.value = false;
    }
  }
}
