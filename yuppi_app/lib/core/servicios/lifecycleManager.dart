// import 'package:flutter/widgets.dart';
// import 'camera_manager.dart'; // donde tengas tu CameraManager

// class LifecycleManager with WidgetsBindingObserver {
//   void startObserving() {
//     WidgetsBinding.instance.addObserver(this);
//   }

//   void stopObserving() {
//     WidgetsBinding.instance.removeObserver(this);
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.detached ||
//         state == AppLifecycleState.inactive) {
//       // 🔥 Cuando la app se destruye o va a background fuerte
//       CameraManager().dispose();
//     }
//   }
// }
