import 'package:flutter/material.dart';

import 'Login.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final GlobalKey<FormState> _emailFormKey = GlobalKey<FormState>();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool isPasswordVisible = true;
  bool isConfirmPasswordVisible = true;
  bool isEmailValid = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1B4D3E),
              Color(0xFF124335),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 80),
              // "Sign up" Text rotated
              const Row(
                children: [
                  RotatedBox(
                    quarterTurns: -1,
                    child: Text(
                      "Sign up",
                      style: TextStyle(
                        color: Color(0xFF9C7945),
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Text(
                    "A platform for\nsharing everything\nwith your group",
                    style: TextStyle(
                      color: Color(0xFF9C7945),
                      fontSize: 28,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: TextField(
                      controller: firstNameController,
                      decoration: const InputDecoration(
                        labelText: "First name",
                        labelStyle: TextStyle(color: Color(0xFF9C7945)),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF9C7945)),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF9C7945)),
                        ),
                      ),
                      style: const TextStyle(color: Color(0xFF9C7945)),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.1,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: TextField(
                      controller: lastNameController,
                      decoration: const InputDecoration(
                        labelText: "Last name",
                        labelStyle: TextStyle(color: Color(0xFF9C7945)),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF9C7945)),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF9C7945)),
                        ),
                      ),
                      style: const TextStyle(color: Color(0xFF9C7945)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Email input field
              Form(
                key: _emailFormKey,
                child: Theme(
                  data: Theme.of(context).copyWith(
                    inputDecorationTheme: const InputDecorationTheme(
                      errorStyle: TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter email';
                      }
                      if (!isEmailValid) {
                        return 'User already exist';
                      }
                      return null;
                    },
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: "Email",
                      labelStyle: TextStyle(color: Color(0xFF9C7945)),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF9C7945)),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF9C7945)),
                      ),
                    ),
                    style: const TextStyle(color: Color(0xFF9C7945)),
                    onChanged: (value) {
                      // Reset email validity on each input change
                      setState(() {
                        isEmailValid = true;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Password input field
              TextField(
                onTap: () async {
                  // Validate email field when password field is tapped
                  // bool emailExists = await checkEmail(emailController.text);
                  // if (emailExists) {
                  //   // If email does not exist, show error
                  //   setState(() {
                  //     isEmailValid = false;
                  //   });
                  //   // Revalidate email form to show error message
                  //   _emailFormKey.currentState!.validate();
                  // }
                },
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: "Password",
                  labelStyle: const TextStyle(color: Color(0xFF9C7945)),
                  suffixIcon: IconButton(
                    icon: Icon(
                      isPasswordVisible
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: const Color(0xFF9C7945),
                    ),
                    onPressed: () {
                      _togglePasswordVisibility(context);
                    },
                  ),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF9C7945)),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF9C7945)),
                  ),
                ),
                obscureText: isPasswordVisible,
                style: const TextStyle(color: Color(0xFF9C7945)),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: confirmPasswordController,
                decoration: InputDecoration(
                  labelText: "Confirm passwords",
                  labelStyle: const TextStyle(color: Color(0xFF9C7945)),
                  suffixIcon: IconButton(
                    icon: Icon(
                      isConfirmPasswordVisible
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: const Color(0xFF9C7945),
                    ),
                    onPressed: () {
                      _toggleConfirmPasswordVisibility(context);
                    },
                  ),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF9C7945)),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF9C7945)),
                  ),
                ),
                obscureText: isConfirmPasswordVisible,
                style: const TextStyle(color: Color(0xFF9C7945)),
              ),
              const SizedBox(height: 40),
              // OK Button
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () async {
                    {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9C7945),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Sign up",
                        style: TextStyle(color: Color(0xFF1B4D3E), fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Icon(
                        Icons.arrow_forward,
                        color: Color(0xFF1B4D3E),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              // Bottom text for Sign in
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Have we met before? ",
                    style: TextStyle(color: Color(0xFF9C7945), fontSize: 15),
                  ),
                  GestureDetector(
                    onTap: () async {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    },
                    child: const Text(
                      "Sign in",
                      style: TextStyle(
                          color: Color(0xFF9C7945),
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _togglePasswordVisibility(BuildContext context) {
    setState(() {
      isPasswordVisible = !isPasswordVisible;
    });
  }

  void _toggleConfirmPasswordVisibility(BuildContext context) {
    setState(() {
      isConfirmPasswordVisible = !isConfirmPasswordVisible;
    });
  }

// Future<bool> checkEmail(String email) async {
//   var url = "http://$IP/checkEmail/$email";
//   try {
//     final response = await http.get(Uri.parse(url));
//     if (response.statusCode == 200) {
//       var status = jsonDecode(response.body);
//       return status;
//     } else {
//       if (kDebugMode) {
//         print('Failed to load users: ${response.statusCode}');
//       }
//     }
//   } catch (e) {
//     if (kDebugMode) {
//       print('Error: $e');
//     }
//   }
//   return false;
// }
}
