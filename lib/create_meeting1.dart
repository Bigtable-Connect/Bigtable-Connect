// import 'package:flutter/material.dart';
// import 'package:jitsi_meet_wrapper/jitsi_meet_wrapper.dart';
//
// class CreateMeetingScreen extends StatefulWidget {
//   const CreateMeetingScreen({super.key});
//
//   @override
//   State<CreateMeetingScreen> createState() => _CreateMeetingScreenState();
// }
//
// class _CreateMeetingScreenState extends State<CreateMeetingScreen> {
//   final TextEditingController _meetingIdController = TextEditingController();
//   final TextEditingController _userNameController = TextEditingController();
//
//   @override
//   void dispose() {
//     _meetingIdController.dispose();
//     _userNameController.dispose();
//     super.dispose();
//   }
//
//
//   Future<void> _createMeeting() async {
//     try {
//       String meetingId = "meet_${DateTime.now().millisecondsSinceEpoch}"; // Room name
//       String password = "123456"; // Set a password
//
//       // Configure meeting options
//       var options = JitsiMeetingOptions(
//         roomNameOrUrl: meetingId, // Room ID
//         userDisplayName: "User", // Display Name for the user
//         isAudioMuted: false, // Whether audio is muted at the start
//         isVideoMuted: false, // Whether video is muted at the start
//         token: null, // Optional token if using authentication
//         featureFlags: {
//           "isVideoMuted": false,
//           "isAudioMuted": false,
//         },
//         // Any other custom flags
//       );
//
//       // Join the meeting with configured options
//       await JitsiMeetWrapper.joinMeeting(options: options);
//
//       // Inform the participants the meeting ID and password
//       debugPrint("Created meeting with ID: $meetingId and password: $password");
//
//       // Handle your password logic here
//       // You could show a dialog or display password on UI
//     } catch (error) {
//       debugPrint("Error: $error");
//     }
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Create a New Meeting"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               "Enter Meeting Details",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 16),
//             TextField(
//               controller: _meetingIdController,
//               decoration: const InputDecoration(
//                 labelText: "Meeting ID (Optional)",
//                 hintText: "Leave blank to auto-generate",
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 16),
//             TextField(
//               controller: _userNameController,
//               decoration: const InputDecoration(
//                 labelText: "Your Name",
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 32),
//             Center(
//               child: ElevatedButton(
//                 onPressed: _createMeeting,
//                 child: const Text("Create Meeting"),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
