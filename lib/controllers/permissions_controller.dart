import 'package:get/get.dart';
import '../api/auth_apis.dart';
import '../utils/app_common.dart';

class PermissionsController extends GetxController {
  // Observable state
  final RxList<String> permissions = <String>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPermissions();
  }

  // Fetch user permissions
  Future<void> fetchPermissions() async {
    try {
      isLoading.value = true;
      error.value = '';

      final response = await AuthServiceApis.getUserPermissions();
      permissions.value = response;
      print("permissions: ${permissions.value}");
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // Check if user has a specific permission
  bool hasPermission(String permission) {
    return permissions.contains(permission);
  }

  // Check if user has any of the specified permissions
  bool hasAnyPermission(List<String> requiredPermissions) {
    for (var permission in requiredPermissions) {
      if (permissions.contains(permission)) {
        return true;
      }
    }
    return false;
  }

  // Check if user has all of the specified permissions
  bool hasAllPermissions(List<String> requiredPermissions) {
    for (var permission in requiredPermissions) {
      if (!permissions.contains(permission)) {
        return false;
      }
    }
    return true;
  }
}
