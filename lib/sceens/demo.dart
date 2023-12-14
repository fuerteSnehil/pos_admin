// import 'package:flutter/material.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Stack Example'),
//         ),
//         body: Center(
//           child: Stack(
//             children: [
//               // First Container (Top)
//               Positioned(
//                 top: 20,
//                 left: 20,
//                 child: Container(
//                   width: 100,
//                   height: 100,
//                   color: Colors.blue,
//                 ),
//               ),
//               // Second Container (Bottom)
//               Positioned(
//                 bottom: 20,
//                 right: 20,
//                 child: Container(
//                   width: 150,
//                   height: 150,
//                   color: Colors.red,
//                 ),
//               ),
//               // Third Container (On Top of Second)
//               Container(
//                 width: 120,
//                 height: 120,
//                 color: Colors.green,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
