import 'package:get/get.dart';

import '../controllers/voice_dsp_controller.dart';

class VoiceDspBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VoiceDspController>(
      () => VoiceDspController(),
    );
  }
}
