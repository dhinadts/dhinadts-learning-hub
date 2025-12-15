import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sampling_theorem/app/data/global_controllers/theme_controller.dart';
import 'package:sampling_theorem/app/routes/app_pages.dart';

void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize SystemChrome with error handling
    await _initializeSystemServices();
    // Initialize GetX bindings
    Get.put(ThemeController(), permanent: true);

    // Run the app
    runApp(const MyApp());
  } catch (e) {
    // Handle initialization errors
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('Initialization failed: $e'),
          ),
        ),
      ),
    );
  }
}

Future<void> _initializeSystemServices() async {
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      // For Android
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
      // For iOS
      // statusBarBrightness: Brightness.dark,
    ),
  );

  // Optional: Set system UI mode
  await SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
    overlays: [SystemUiOverlay.top],
  );

  // Optional: Set system navigation bar
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.white,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    return Obx(() {
      return GetMaterialApp(
        title: 'Sampling Theorem Tutorial',
        theme: themeController.currentTheme,
        /* theme: _buildLightTheme(),
        darkTheme: _buildDarkTheme(), */
        // themeMode: ThemeMode.system,
        darkTheme: themeController.darkTheme,
        themeMode:
            themeController.isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
        defaultTransition: Transition.cupertino,
        opaqueRoute: Get.isOpaqueRouteDefault,
        popGesture: Get.isPopGestureEnable,
        transitionDuration: const Duration(milliseconds: 300),
        // home: const HomeView(),

        // Routing configuration
        initialRoute: AppPages.initial,
        getPages: AppPages.routes,
        unknownRoute: GetPage(
          name: '/notfound',
          page: () => const Scaffold(
            body: Center(child: Text('Page not found')),
          ),
        ),
        debugShowCheckedModeBanner: false,
        // defaultTransition: Transition.cupertino,
        // popGesture: Get.isPopGestureEnable,
        // transitionDuration: const Duration(milliseconds: 300),

        // Optional: Add logging
        enableLog: true,
        // logWriterCallback: (text, {isError = false}) {
        //   if (isError) {
        //     print('[GETX ERROR] $text');
        //   }
        // },

        // debugShowCheckedModeBanner: false,
        // enableLog: true, // GetX logs
        logWriterCallback: (text, {bool isError = false}) {
          // Custom log writer if needed
          if (isError) {
            print('[GETX ERROR] $text');
          } else {
            print('[GETX] $text');
          }
        },
        // Global app settings
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaleFactor: 1.0, // Prevent system font scaling
            ),
            child: child!,
          );
        },
      );
    });
  }

  ThemeData _buildLightTheme() {
    return ThemeData(
      primarySwatch: Colors.blue,
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData.dark().copyWith(
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
    );
  }
}















/* import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import 'app/routes/app_pages.dart';

void main() {
  // Initialize SystemChrome BEFORE runApp()
  WidgetsFlutterBinding.ensureInitialized();

  /* SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
    ),
  ); */
  runApp(
    GetMaterialApp(
      title: "DSP Sampling Theorem",
      initialBinding: InitialBinding(), // Add the binding here
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
    ),
  );
}

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Initialize SystemChrome here
    _initializeSystemChrome();

    // You can also initialize other controllers here
    // Get.lazyPut(() => HomeController());
    // Get.lazyPut(() => SettingsController());
  }

  void _initializeSystemChrome() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    // Enable edge-to-edge display (Android 10+)
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }
}
 */