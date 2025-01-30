import 'package:bigtable_connect/screens/personal_chat_screen.dart';
import 'package:bigtable_connect/services/notification_service.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../Auth/SharedPreferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _messagingService = MessagingService();

  final icons = [
    "",
    "assets/Logo/img_2.png",
    "assets/Logo/img_1.png",
  ];

  final labels = [
    "Personal chat",
    "Joined Classes",
    "My classes",
  ];
  late String email;
  final key1 = 'Email';
  late String firstName;
  late String lastName;
  late String userKey;
  late String profileImage;
  bool isDataFetched = false;

  @override
  void initState() {
    super.initState();
    _messagingService.init(context);
  }

  Future<void> loadData() async {
    if (isDataFetched) return;
    String? userEmail = await getData(key1);
    String? userFirstName = await getData("FirstName");
    String? userLastName = await getData("LastName");
    String? profileImage1 = await getData("ProfileImage");
    String? userkey = await getKey();
    setState(() {
      email = userEmail!;
      userKey = userkey!;
      firstName = userFirstName!;
      lastName = userLastName!;
      if (profileImage1 != null) {
        profileImage = profileImage1;
      } else {
        profileImage = "";
      }
      isDataFetched = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 1,
      child: FutureBuilder(
        future: loadData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (firstName.isNotEmpty) {
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  title: Row(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.white10,
                          shape: BoxShape.circle, // Use circle shape
                        ),
                        child: ClipOval(
                          // Ensures the image itself is circular
                          child: Image.network(
                            profileImage,
                            fit: BoxFit.fill,
                            height: MediaQuery.of(context).size.height * 0.05,
                            width: MediaQuery.of(context).size.height *
                                0.05, // Maintain circular shape
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.02,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Hello, $firstName",
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 18)),
                          const Text("Discover your courses right away",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 14)),
                        ],
                      )
                    ],
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.notifications_outlined,
                          color: Colors.black),
                      onPressed: () {
                        print("Notifications tapped");
                      },
                    ),
                  ],
                ),
                body: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // const SizedBox(height: 20),

                        // Grid Buttons
                        // GridView.builder(
                        //   shrinkWrap: true,
                        //   itemCount: icons.length,
                        //   physics: const NeverScrollableScrollPhysics(),
                        //   gridDelegate:
                        //       const SliverGridDelegateWithFixedCrossAxisCount(
                        //     crossAxisCount: 3,
                        //     mainAxisSpacing: 16,
                        //     crossAxisSpacing: 16,
                        //   ),
                        //   itemBuilder: (context, index) {
                        //     // Define actions for each grid item
                        //     void onItemTapped(int index) {
                        //       switch (index) {
                        //         case 0:
                        //           print("Personal chat");
                        //           // Navigate to Category Screen
                        //           break;
                        //         case 1:
                        //           print("Joined classes");
                        //           // Navigate to Courses Screen
                        //           break;
                        //         case 2:
                        //           print("My class");
                        //           // Navigate to Free Course Screen
                        //           break;
                        //         default:
                        //           print("Unknown item tapped");
                        //       }
                        //     }
                        //
                        //     return GestureDetector(
                        //       onTap: () => onItemTapped(index), // Handle tap
                        //       child: Column(
                        //         mainAxisSize: MainAxisSize.min,
                        //         children: [
                        //           Container(
                        //             padding: const EdgeInsets.all(16),
                        //             decoration: const BoxDecoration(
                        //               color: Colors.orangeAccent,
                        //               shape: BoxShape.circle,
                        //             ),
                        //             child: Image.asset(
                        //               icons[index],
                        //               color: Colors.white,
                        //               height: MediaQuery.of(context).size.height *
                        //                   0.035,
                        //             ),
                        //           ),
                        //           SizedBox(
                        //               height: MediaQuery.of(context).size.height *
                        //                   0.009),
                        //           Text(
                        //             labels[index],
                        //             style: const TextStyle(
                        //                 fontSize: 14, color: Colors.black),
                        //             textAlign: TextAlign.center,
                        //           ),
                        //         ],
                        //       ),
                        //     );
                        //   },
                        // ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PersonalCharScreen(),
                              ),
                            );
                          }, // Handle tap
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: const BoxDecoration(
                                  color: Colors.orangeAccent,
                                  shape: BoxShape.circle,
                                ),
                                child: Image.asset(
                                  "assets/Logo/communication.png",
                                  color: Colors.white,
                                  height: MediaQuery.of(context).size.height *
                                      0.035,
                                ),
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.009),
                              const Text(
                                "Personal Chat",
                                style: TextStyle(
                                    fontSize: 14, color: Colors.black),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                print("Joined classes");
                              }, // Handle tap
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: const BoxDecoration(
                                      color: Colors.orangeAccent,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Image.asset(
                                      "assets/Logo/img_2.png",
                                      color: Colors.white,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.035,
                                    ),
                                  ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.009),
                                  const Text(
                                    "Joined Classes",
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.black),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                                width:
                                    MediaQuery.of(context).size.width * 0.05),
                            GestureDetector(
                              onTap: () {
                                print("My classes");
                              }, // Handle tap
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: const BoxDecoration(
                                      color: Colors.orangeAccent,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Image.asset(
                                      "assets/Logo/img_1.png",
                                      color: Colors.white,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.035,
                                    ),
                                  ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.009),
                                  const Text(
                                    "My Classes",
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.black),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                        Padding(
                          padding: const EdgeInsets.all(0),
                          child: Column(
                            children: [
                              SizedBox(
                                // dots place
                                height: MediaQuery.of(context).size.width * 1,
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  children: [
                                    CarouselSlider(
                                      items: [
                                        GestureDetector(
                                          child: Card(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10, right: 10, top: 10),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Column(
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                        child: Image.asset(
                                                          "assets/Logo/communication.png",
                                                          height: 120,
                                                          width: 120,
                                                          fit: BoxFit.fitHeight,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const Flexible(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 10),
                                                          child: Text(
                                                            "1",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 17),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 10),
                                                          child: Text(
                                                            "₹",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 10),
                                                          child: Text(
                                                            "userMap[index]!",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          child: Card(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10, right: 10, top: 10),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Column(
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                        child: Image.asset(
                                                          "assets/Logo/communication.png",
                                                          height: 120,
                                                          width: 120,
                                                          fit: BoxFit.fitHeight,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const Flexible(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 10),
                                                          child: Text(
                                                            "2",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 17),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 10),
                                                          child: Text(
                                                            "₹",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 10),
                                                          child: Text(
                                                            "userMap[index]!",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          child: Card(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10, right: 10, top: 10),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Column(
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                        child: Image.asset(
                                                          "assets/Logo/communication.png",
                                                          height: 120,
                                                          width: 120,
                                                          fit: BoxFit.fitHeight,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const Flexible(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 10),
                                                          child: Text(
                                                            "3",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 17),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 10),
                                                          child: Text(
                                                            "₹",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 10),
                                                          child: Text(
                                                            "userMap[index]!",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          child: Card(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10, right: 10, top: 10),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Column(
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                        child: Image.asset(
                                                          "assets/Logo/communication.png",
                                                          height: 120,
                                                          width: 120,
                                                          fit: BoxFit.fitHeight,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const Flexible(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 10),
                                                          child: Text(
                                                            "4",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 17),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 10),
                                                          child: Text(
                                                            "₹",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 10),
                                                          child: Text(
                                                            "userMap[index]!",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        // Add more cards if needed
                                      ],
                                      options: CarouselOptions(
                                        height:
                                            MediaQuery.of(context).size.width *
                                                1,
                                        aspectRatio: 16 / 9,
                                        viewportFraction: 0.9,
                                        initialPage: 0,
                                        enableInfiniteScroll: true,
                                        reverse: false,
                                        autoPlay: true,
                                        autoPlayInterval:
                                            const Duration(seconds: 3),
                                        autoPlayAnimationDuration:
                                            const Duration(milliseconds: 800),
                                        autoPlayCurve: Curves.fastOutSlowIn,
                                        enlargeCenterPage: true,
                                        scrollDirection: Axis.horizontal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                      ],
                    ),
                  ),
                ),

                // Bottom Navigation Bar
                // floatingActionButton: FloatingActionButton(
                //   backgroundColor: Colors.orange,
                //   child: const Icon(Icons.add),
                //   onPressed: () {
                //     print("FAB tapped");
                //   },
                // ),
                // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
                // bottomNavigationBar: BottomAppBar(
                //   shape: const CircularNotchedRectangle(),
                //   notchMargin: 8.0,
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                //     children: [
                //       IconButton(icon: const Icon(Icons.home), onPressed: () {}),
                //       IconButton(icon: const Icon(Icons.book), onPressed: () {}),
                //       const SizedBox(width: 40), // Space for FAB
                //       IconButton(
                //           icon: const Icon(Icons.bar_chart), onPressed: () {}),
                //       IconButton(
                //           icon: const Icon(Icons.person),
                //           onPressed: () {
                //             AuthService().signOut(context: context);
                //           }),
                //     ],
                //   ),
                // ),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
