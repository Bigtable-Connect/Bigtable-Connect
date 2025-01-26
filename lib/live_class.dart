// import 'package:bigtable_connect/create_meeting.dart';
// import 'package:flutter/material.dart';
//
// import 'create_meeting1.dart';
//
// class LiveClass extends StatefulWidget {
//   const LiveClass({super.key});
//
//   @override
//   State<LiveClass> createState() => _LiveClassState();
// }
//
// class _LiveClassState extends State<LiveClass> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF1B4D3E),
//         title: const Text(
//           "Live Session",
//           style: TextStyle(color: Color(0xFFdaa520)),
//         ),
//         leading: IconButton(
//           icon: const Icon(
//             Icons.arrow_back_ios_new,
//             color: Color(0xFFdaa520),
//           ),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: Padding(
//         padding:
//             const EdgeInsets.only(bottom: 10, left: 20, top: 30, right: 20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             // Action Buttons
//             ElevatedButton.icon(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => const CreateMeetingScreen(),
//                   ),
//                 );
//                 // Navigate to create meeting screen
//               },
//               icon: const Icon(Icons.video_call, size: 24),
//               label: const Text(
//                 "Start Meeting",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               style: ElevatedButton.styleFrom(
//                 padding: const EdgeInsets.symmetric(
//                   vertical: 16,
//                   horizontal: 24,
//                 ),
//                 backgroundColor: const Color(0xFF1B4D3E),
//                 foregroundColor: const Color(0xFFdaa520),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//               ),
//             ),
//             Divider(
//               height: MediaQuery.of(context).size.height * 0.03,
//             ),
//             ElevatedButton.icon(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => const JoinMeeting(),
//                   ),
//                 );
//                 // Navigate to join meeting screen
//               },
//               icon: const Icon(Icons.meeting_room, size: 24),
//               label: const Text(
//                 "Join Meeting",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               style: ElevatedButton.styleFrom(
//                 padding: const EdgeInsets.symmetric(
//                   vertical: 16,
//                   horizontal: 24,
//                 ),
//                 backgroundColor: const Color(0xFFdaa520),
//                 foregroundColor: const Color(0xFF1B4D3E),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//               ),
//             ),
//             const Spacer(),
//
//             // Footer Section
//             const Text(
//               "Powered by Bigtable Connect",
//               style: TextStyle(fontSize: 14, color: Colors.grey),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
