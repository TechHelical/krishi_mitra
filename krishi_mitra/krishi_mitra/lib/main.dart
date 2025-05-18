import 'package:flutter/material.dart';
import 'package:krishi_mitra/welcome_screen.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// import 'select_state.dart';
// import 'home_screen.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  runApp(MyApp());
}

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   // if (kIsWeb) {
//   //   // Web-specific Firebase initialization
//   //   await Firebase.initializeApp(
//   //     options: FirebaseOptions(
//   //       // apiKey: "YOUR_API_KEY",
//   //       // authDomain: "YOUR_PROJECT_ID.firebaseapp.com",
//   //       // projectId: "YOUR_PROJECT_ID",
//   //       // storageBucket: "YOUR_PROJECT_ID.appspot.com",
//   //       // messagingSenderId: "YOUR_MESSAGING_SENDER_ID",
//   //       // appId: "YOUR_APP_ID",
//   //
//   //         apiKey: "AIzaSyDJnL3CVEC4h7vGZJisu23a3hs0GCbcqK0",
//   //         authDomain: "to-do-e200b.firebaseapp.com",
//   //         projectId: "to-do-e200b",
//   //         storageBucket: "to-do-e200b.firebasestorage.app",
//   //         messagingSenderId: "1080111382250",
//   //         appId: "1:1080111382250:web:05b674e94b26afce772193",
//   //         measurementId: "G-V24HWPS6C9",
//   //     ),
//   //   );
//   // } else {
//   //   // Android & iOS Firebase initialization
//   //   await Firebase.initializeApp();
//   // }
//
//   runApp(MyApp());
// }

// Future<void> loginHardcodedUser() async {
//   try {
//     String email = "dummy@gmail.com"; // Hardcoded email
//     String password = "dummy123"; // Hardcoded password
//
//     UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
//       email: email,
//       password: password,
//     );
//
//     print("User signed in: ${userCredential.user!.email}");
//   } catch (e) {
//     print("Login failed: $e");
//   }
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // loginHardcodedUser(); // Call authentication function
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Krishi Mitra',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      // home: HomePage(),
      // home: HomeScreen(),
      home: WelcomeScreen(),
    );
  }
}
