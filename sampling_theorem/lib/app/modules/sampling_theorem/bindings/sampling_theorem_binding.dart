import 'package:get/get.dart';

import '../controllers/sampling_theorem_controller.dart';

class SamplingTheoremBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SamplingTheoremController>(
      () => SamplingTheoremController(),
    );
  }
}
