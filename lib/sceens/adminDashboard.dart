import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lottie/lottie.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pos_admin/constants/colors.dart';
import 'package:pos_admin/sceens/addCustomerScreen.dart';
import 'package:pos_admin/sceens/addDepartmentScreen.dart';
import 'package:pos_admin/sceens/addItemScreen.dart';
import 'package:pos_admin/sceens/addTaxScreen.dart';
import 'package:pos_admin/sceens/addUnits.dart';
import 'package:pos_admin/sceens/allCustomerScreen.dart';
import 'package:pos_admin/sceens/allDepartmentScreen.dart';
import 'package:pos_admin/sceens/allFoodScreen.dart';
import 'package:pos_admin/sceens/allTaxScreen.dart';
import 'package:pos_admin/sceens/allUnitScreen.dart';
import 'package:pos_admin/sceens/inception.dart';
import 'package:pos_admin/sceens/itemScreen.dart';
import 'package:pos_admin/sceens/overAllReports.dart';
import 'package:pos_admin/screen.dart';
import 'package:pos_admin/widgets/circleWidget.dart';
import 'package:pos_admin/widgets/cstmList.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminDashboard extends StatefulWidget {
  final String Uid;
  const AdminDashboard({required this.Uid, Key? key}) : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  bool showMasterSublist = false;
  bool showReportSublist = false;
  late FirebaseFirestore _firestore;
  bool isFetched = true;
  String name = '';
  String email = '';
  String phone = '';

  @override
  void initState() {
    super.initState();
    _firestore = FirebaseFirestore.instance;
    _fetchAdminData();
  }

  Future<void> _fetchAdminData() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await _firestore.collection('AllAdmins').doc(widget.Uid).get();

      if (documentSnapshot.exists) {
        Map<String, dynamic> data = documentSnapshot.data()!;

        // Assuming your document structure has 'name', 'email', and 'phone' fields
        name = data['name'];
        email = data['email'];
        phone = data['phone'];

        // Now you can display the fetched data in your UI or use it as needed
        print('Name: $name');
        print('Email: $email');
        print('Phone: $phone');
        setState(() {
          isFetched = false;
        });
      } else {
        setState(() {
          isFetched = false;
        });
        print('Document does not exist');
      }
    } catch (e) {
      setState(() {
        isFetched = false;
      });
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    //  double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0XFFf65656),
        centerTitle: true,
        title: const Text(
          'Galaxy',
          style: TextStyle(
            color: white,
            fontFamily: "tabfont",
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.logout_rounded,
              color: white,
              size: 30,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext) {
                  return Dialog(
                      // backgroundColor: Colors.amber.shade100,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(50.0)), //this right here
                      child: SizedBox(
                        height: 200,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Text(
                                "Are you sure ?",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w500),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0XFF26c589)),
                                    child: const Text("Cancel",
                                        style: TextStyle(color: Colors.white)),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red),
                                    child: const Text(
                                      "Logout",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onPressed: () async {
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      await prefs.setBool('isLogged', false);
                                      FirebaseAuth.instance.signOut();
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const Inception(),
                                          ));
                                    },
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ));
                },
              );
            },
          ),
        ],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: ListTile(
                leading: Icon(MdiIcons.speedometer),
                title: const Text('Dashboard'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
            ListTile(
              leading: const Icon(Icons.laptop),
              title: const Text('Master'),
              onTap: () {
                setState(() {
                  showMasterSublist = !showMasterSublist;
                });
              },
            ),
            if (showMasterSublist)
              Column(
                children: [
                  // ListTile(
                  //   leading: Icon(Icons.subdirectory_arrow_right),
                  //   title: Text(
                  //     'Customer',
                  //   ),
                  //   onTap: () {
                  //     Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //             builder: (context) =>
                  //                 AddCustomerScreen(uid: widget.Uid)));
                  //   },
                  // ),
                  ListTile(
                    leading: const Icon(Icons.subdirectory_arrow_right),
                    title: const Text(
                      'Customer List',
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  AllCustomerScreen(adminUid: widget.Uid)));
                    },
                  ),
                  // ListTile(
                  //   leading: Icon(Icons.subdirectory_arrow_right),
                  //   title: Text('Offer Coupen'),
                  //   onTap: () {
                  //     Navigator.pop(context);
                  //   },
                  // ),
                  // ListTile(
                  //   leading: Icon(Icons.subdirectory_arrow_right),
                  //   title: Text('Other Users'),
                  //   onTap: () {
                  //     Navigator.pop(context);
                  //   },
                  // ),
                  // ListTile(
                  //   leading: Icon(Icons.subdirectory_arrow_right),
                  //   title: Text('Table Group'),
                  //   onTap: () {
                  //     Navigator.pop(context);
                  //   },
                  // ),
                  // ListTile(
                  //   leading: Icon(Icons.subdirectory_arrow_right),
                  //   title: Text('Department'),
                  //   onTap: () {
                  //     Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //             builder: (context) => AddDepartmentScreen(
                  //                   docId: widget.Uid,
                  //                 )));
                  //   },
                  // ),
                  ListTile(
                    leading: const Icon(Icons.subdirectory_arrow_right),
                    title: const Text('Department List'),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DepartmentListScreen(
                                    docId: widget.Uid,
                                  )));
                    },
                  ),
                  // ListTile(
                  //   leading: Icon(Icons.subdirectory_arrow_right),
                  //   title: Text('Table Master'),
                  //   onTap: () {
                  //     Navigator.pop(context);
                  //   },
                  // ),
                  // ListTile(
                  //   leading: Icon(Icons.subdirectory_arrow_right),
                  //   title: Text('Tax Setting'),
                  //   onTap: () {
                  //     Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //             builder: (context) =>
                  //                 AddTaxScreen(docId: widget.Uid)));
                  //   },
                  // ),
                  ListTile(
                    leading: const Icon(Icons.subdirectory_arrow_right),
                    title: const Text('Tax List'),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TaxListScreen(
                                    docId: widget.Uid,
                                  )));
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.subdirectory_arrow_right),
                    title: const Text('Unit List'),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder:(context)=>AllUnitScreen(uid: widget.Uid)));
                    },
                  ),
                  // ListTile(
                  //   leading: Icon(Icons.subdirectory_arrow_right),
                  //   title: Text('Units'),
                  //   onTap: () {
                  //     Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //             builder: (context) =>
                  //                 AddUnitScreen(docId: widget.Uid)));
                  //   },
                  // ),
                  // ListTile(
                  //   leading: Icon(Icons.subdirectory_arrow_right),
                  //   title: Text('Kotgroup'),
                  //   onTap: () {
                  //     Navigator.pop(context);
                  //   },
                  // ),
                  // ListTile(
                  //   leading: Icon(Icons.subdirectory_arrow_right),
                  //   title: Text('Kotmessage'),
                  //   onTap: () {
                  //     Navigator.pop(context);
                  //   },
                  // ),
                  // ListTile(
                  //   leading: Icon(Icons.subdirectory_arrow_right),
                  //   title: Text('Item'),
                  //   onTap: () {
                  //     Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //             builder: (context) =>
                  //                 ItemScreen(uid: widget.Uid)));
                  //   },
                  // ),
                  // ListTile(
                  //   leading: Icon(Icons.subdirectory_arrow_right),
                  //   title: Text('Import'),
                  //   onTap: () {
                  //     Navigator.pop(context);
                  //   },
                  // ),
                ],
              ),
            ListTile(
              leading: Icon(MdiIcons.file),
              title: const Text('Reports'),
              onTap: () {
                setState(() {
                  showReportSublist = !showReportSublist;
                });
              },
            ),
            if (showReportSublist)
              Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.subdirectory_arrow_right),
                    title: const Text('Over All Report'),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OverAllReport()));
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.subdirectory_arrow_right),
                    title: const Text('Report Billwise'),
                    onTap: () {},
                  ),
                ],
              ),
          ],
        ),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return isFetched
              ? const Center(
                  child: CircularProgressIndicator(
                  color: Color(0XFFf65656),
                ))
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      Stack(
                        children: <Widget>[
                          Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(50),
                              ),
                              color: black,
                            ),
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height / 3,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 220),
                                  child: Column(
                                    children: [
                                      Text(
                                        phone,
                                        style: const TextStyle(
                                          color: white,
                                          fontFamily: "tabfont",
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      const Text(
                                        'Phone-No',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: grey,
                                          fontFamily: "fontmain",
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 220),
                                  child: Column(
                                    children: [
                                      Text(
                                        email,
                                        style: const TextStyle(
                                          color: white,
                                          fontFamily: "tabfont",
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      const Text(
                                        'E-mail',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: grey,
                                          fontFamily: "fontmain",
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ), //Container
                          Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(50),
                              ),
                              color: Color(0XFF120125),
                            ),
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height / 5,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(left: 20, top: 30),
                                  child: SizedBox(
                                    height: 90,
                                    width: 90,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 20.0,
                                      backgroundImage:
                                          AssetImage('$imagesPath/account.gif'),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 20, top: 80),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Hii ${name}',
                                        style: const TextStyle(
                                          fontSize: 20,
                                          color: white,
                                          fontFamily: "tabfont",
                                        ),
                                      ),
                                      const Text(
                                        'You can access all your data here..',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: grey,
                                          fontFamily: "fontmain",
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ), //Container
                          Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(50),
                              ),
                              color: Color(0XFFf65656),
                            ),
                            height: MediaQuery.of(context).size.height / 20,
                            width: double.infinity,
                          ), //Container
                        ], //<Widget>[]
                      ),
                      const SizedBox(
                        height: 80,
                      ),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(
                                left: 27,
                                bottom: 20,
                              ),
                              child: Text(
                                'Quick Actions',
                                style: TextStyle(
                                  fontSize: 15,
                                  letterSpacing: 1.5,
                                  fontFamily: "tabfont",
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AddCustomerScreen(
                                                    uid: widget.Uid)));
                                  },
                                  child: CircleContainer(
                                    gradient: const LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      stops: [
                                        0.009,
                                        0.4,
                                      ],
                                      colors: [
                                        Colors.white,
                                        Color(0XFFaf6eee),
                                      ],
                                      // colors: [Colors.white, Colors.deepPurple],
                                    ),
                                    icon: Icon(
                                      MdiIcons.account,
                                      color: white,
                                      size: 30,
                                    ),
                                    text: 'CUSTOMER',
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => AddItemScreen(
                                                uid: widget.Uid)));
                                  },
                                  child: const CircleContainer(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      stops: [
                                        0.009,
                                        0.4,
                                      ],
                                      colors: [
                                        Colors.white,
                                        Color(0XFFfe6ca2),
                                      ],
                                      // colors: [Colors.white, Colors.deepPurple],
                                    ),
                                    icon: Icon(
                                      CommunityMaterialIcons.food,
                                      size: 30,
                                      color: white,
                                    ),
                                    text: 'ITEMS',
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => AddTaxScreen(
                                                docId: widget.Uid)));
                                  },
                                  child: const CircleContainer(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      stops: [
                                        0.009,
                                        0.4,
                                      ],
                                      colors: [
                                        Colors.white,
                                        Color(0XFFfea36a),
                                      ],
                                      // colors: [Colors.white, Colors.deepPurple],
                                    ),
                                    icon: Icon(
                                      CommunityMaterialIcons
                                          .currency_usd_circle,
                                      color: white,
                                      size: 30,
                                    ),
                                    text: 'TAX',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => AddUnitScreen(
                                                docId: widget.Uid)));
                                  },
                                  child: CircleContainer(
                                    gradient: const LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      stops: [
                                        0.009,
                                        0.4,
                                      ],
                                      colors: [
                                        Colors.white,
                                        Color(0XFF04a8ff),
                                      ],
                                      // colors: [Colors.white, Colors.deepPurple],
                                    ),
                                    icon: Icon(
                                      MdiIcons.scaleUnbalanced,
                                      color: white,
                                      size: 30,
                                    ),
                                    text: 'UNITS',
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AddDepartmentScreen(
                                                    docId: widget.Uid)));
                                  },
                                  child: CircleContainer(
                                    gradient: const LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      stops: [
                                        0.009,
                                        0.4,
                                      ],
                                      colors: [
                                        Colors.white,
                                        Color(0XFF26c589),
                                      ],
                                      // colors: [Colors.white, Colors.deepPurple],
                                    ),
                                    icon: Icon(
                                      MdiIcons.textBoxOutline,
                                      color: white,
                                    ),
                                    text: 'CATEGORY',
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AllFoodsScreen(
                                                    documentId: widget.Uid)));
                                  },
                                  child: CircleContainer(
                                    gradient: const LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      stops: [
                                        0.009,
                                        0.4,
                                      ],
                                      colors: [
                                        Colors.white,
                                        Color(0XFF6c51fd),
                                      ],
                                      // colors: [Colors.white, Colors.deepPurple],
                                    ),
                                    icon: Icon(
                                      MdiIcons.handCoinOutline,
                                      color: white,
                                    ),
                                    text: 'ALL-ITEM',
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                );
        } else {
          return Expanded(
            child: Container(
              child: Row(
                children: [
                  Container(
                    color: webColor,
                    height: double.infinity,
                    width: MediaQuery.of(context).size.width / 2.7,
                    child: Lottie.asset(
                      "$lottiePath/loginWeb.json",
                      fit: BoxFit.fitWidth,
                      alignment: Alignment.center,
                      width: Screen(context).width * 0.9,
                      frameRate: FrameRate(90),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      }),
    );
  }
}
