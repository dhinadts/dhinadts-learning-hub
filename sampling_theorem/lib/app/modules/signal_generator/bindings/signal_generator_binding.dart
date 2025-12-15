import 'package:get/get.dart';

import '../controllers/signal_generator_controller.dart';

class SignalGeneratorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignalGeneratorController>(
      () => SignalGeneratorController(),
    );
  }
}
