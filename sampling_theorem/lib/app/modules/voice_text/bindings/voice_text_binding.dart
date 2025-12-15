import 'package:get/get.dart';

import '../controllers/voice_text_controller.dart';

class VoiceTextBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VoiceTextController>(
      () => VoiceTextController(),
    );
  }
}
