// import 'package:demo_bloc/core/colors.dart';
// import 'package:demo_bloc/screens/main_screen.dart';
// import 'package:flutter/material.dart';

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(home: Scaffold(body: HomePage()));
//   }
// }

// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   Offset offset = Offset.zero;
//   Offset position = Offset.zero;
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: <Widget>[
//         Positioned(
//           left: offset.dx,
//           top: offset.dy,
//           child: GestureDetector(
//             onPanEnd: (details) {
//               // isDragged = false;
//               position = offset;
//               offset = Offset.zero;
//               setState(() {});
//             },
//             onPanUpdate: (details) {
//               setState(() {
//                 offset = Offset(offset.dx + details.delta.dx, offset.dy + details.delta.dy);
//               });
//               print(offset);
//             },
//             child: Container(width: 100, height: 100, color: Colors.blue),
//           ),
//         ),
//       ],
//     );
//   }
// }
