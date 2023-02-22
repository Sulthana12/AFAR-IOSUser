import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppVersionController extends GetxController {
  RxString appVersion = ''.obs;

  Future<void> initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();

    appVersion.value = info.version.toString();
    print(appVersion.value);
    update();
  }
}
