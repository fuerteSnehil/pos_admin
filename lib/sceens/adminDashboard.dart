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
import 'package:pos_admin/sceens/inception.dart';
import 'package:pos_admin/sceens/itemScreen.dart';
import 'package:pos_admin/sceens/overallbill.dart';
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
  late FirebaseFirestore _firestore;
  bool isFetched = true;
  String name = '';
  String email = '';
  String phone = '';
  bool dashboard = true;
  bool allcustomers = false;
  bool allcategory = false;
  bool alltaxes = false;
  bool allitems = false;
  bool addcustomer = false;
  bool additems = false;
  bool addtax = false;
  bool addcategory = false;
  bool allreport = false;

  @override
  void initState() {
    super.initState();
    print(widget.Uid);
    _firestore = FirebaseFirestore.instance;
    _fetchAdminData();
  }

  ScrollController _scrollController = ScrollController();
  ScrollController _scrollController2 = ScrollController();
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
      appBar: MediaQuery.of(context).size.width < 600
          ? AppBar(
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
                                borderRadius: BorderRadius.circular(
                                    50.0)), //this right here
                            child: SizedBox(
                              height: 200,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    const Text(
                                      "Are you sure ?",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  const Color(0XFF26c589)),
                                          child: const Text("Cancel",
                                              style: TextStyle(
                                                  color: Colors.white)),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red),
                                          child: const Text(
                                            "Logout",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          onPressed: () async {
                                            SharedPreferences prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                            await prefs.setBool(
                                                'isLogged', false);
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
            )
          : null,
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
                  setState(() {
                    counter = 1;
                    allcategory = false;
                    dashboard = true;
                    alltaxes = false;
                    allcustomers = false;
                    allitems = false;
                    addcustomer = false;
                    additems = false;
                    addtax = false;
                    addcategory = false;
                    allreport = false;
                  });
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
                  ListTile(
                    leading: const Icon(Icons.subdirectory_arrow_right),
                    title: const Text(
                      'Customer List',
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      setState(() {
                        counter = 2;
                        allcategory = false;
                        dashboard = false;
                        alltaxes = false;
                        allcustomers = true;
                        allitems = false;
                        addcustomer = false;
                        additems = false;
                        addtax = false;
                        addcategory = false;
                        allreport = false;
                      });
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.subdirectory_arrow_right),
                    title: const Text('Department List'),
                    onTap: () {
                      Navigator.pop(context);
                      setState(() {
                        counter = 3;
                        allcategory = true;
                        dashboard = false;
                        alltaxes = false;
                        allcustomers = false;
                        allitems = false;
                        addcustomer = false;
                        additems = false;
                        addtax = false;
                        addcategory = false;
                        allreport = false;
                      });
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.subdirectory_arrow_right),
                    title: const Text('Tax List'),
                    onTap: () {
                      Navigator.pop(context);
                      setState(() {
                        counter = 4;
                        allcategory = false;
                        dashboard = false;
                        alltaxes = true;
                        allcustomers = false;
                        allitems = false;
                        addcustomer = false;
                        additems = false;
                        addtax = false;
                        addcategory = false;
                        allreport = false;
                      });
                    },
                  ),
                ],
              ),
            ListTile(
              leading: Icon(MdiIcons.file),
              title: const Text('Reports'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  counter = 6;
                  allcategory = false;
                  dashboard = false;
                  alltaxes = false;
                  allcustomers = false;
                  allitems = false;
                  addcustomer = false;
                  additems = false;
                  addtax = false;
                  addcategory = false;
                  allreport = true;
                });
              },
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
              : allcustomers
                  ? AllCustomerScreen(
                      adminUid: widget.Uid,
                    )
                  : allcategory
                      ? DepartmentListScreen(
                          docId: widget.Uid,
                        )
                      : alltaxes
                          ? TaxListScreen(
                              docId: widget.Uid,
                            )
                          : allitems
                              ? AllFoodsScreen(documentId: widget.Uid)
                              : addcustomer
                                  ? AddCustomerScreen(uid: widget.Uid)
                                  : additems
                                      ? AddItemScreen(uid: widget.Uid)
                                      : addtax
                                          ? AddTaxScreen(docId: widget.Uid)
                                          : addcategory
                                              ? AddDepartmentScreen(
                                                  docId: widget.Uid)
                                              : allreport
                                                  ? OverAllReport()
                                                  : SingleChildScrollView(
                                                      child: Column(
                                                        children: [
                                                          Stack(
                                                            children: <Widget>[
                                                              Container(
                                                                decoration:
                                                                    const BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .only(
                                                                    bottomLeft:
                                                                        Radius.circular(
                                                                            50),
                                                                  ),
                                                                  color: black,
                                                                ),
                                                                width: double
                                                                    .infinity,
                                                                height: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height /
                                                                    3,
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceAround,
                                                                  children: [
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                          top:
                                                                              220),
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          Text(
                                                                            phone,
                                                                            style:
                                                                                const TextStyle(
                                                                              color: white,
                                                                              fontFamily: "tabfont",
                                                                            ),
                                                                          ),
                                                                          const SizedBox(
                                                                            height:
                                                                                8,
                                                                          ),
                                                                          const Text(
                                                                            'Phone-No',
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 12,
                                                                              color: grey,
                                                                              fontFamily: "fontmain",
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                          top:
                                                                              220),
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          Text(
                                                                            email,
                                                                            style:
                                                                                const TextStyle(
                                                                              color: white,
                                                                              fontFamily: "tabfont",
                                                                            ),
                                                                          ),
                                                                          const SizedBox(
                                                                            height:
                                                                                8,
                                                                          ),
                                                                          const Text(
                                                                            'E-mail',
                                                                            style:
                                                                                TextStyle(
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
                                                                decoration:
                                                                    const BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .only(
                                                                    bottomLeft:
                                                                        Radius.circular(
                                                                            50),
                                                                  ),
                                                                  color: Color(
                                                                      0XFF120125),
                                                                ),
                                                                width: double
                                                                    .infinity,
                                                                height: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height /
                                                                    5,
                                                                child: Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    const Padding(
                                                                      padding: EdgeInsets.only(
                                                                          left:
                                                                              20,
                                                                          top:
                                                                              30),
                                                                      child:
                                                                          SizedBox(
                                                                        height:
                                                                            90,
                                                                        width:
                                                                            90,
                                                                        child:
                                                                            CircleAvatar(
                                                                          backgroundColor:
                                                                              Colors.white,
                                                                          radius:
                                                                              20.0,
                                                                          backgroundImage:
                                                                              AssetImage('$imagesPath/account.gif'),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                          left:
                                                                              20,
                                                                          top:
                                                                              80),
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            'Hii ${name}',
                                                                            style:
                                                                                const TextStyle(
                                                                              fontSize: 20,
                                                                              color: white,
                                                                              fontFamily: "tabfont",
                                                                            ),
                                                                          ),
                                                                          const Text(
                                                                            'You can access all your data here..',
                                                                            style:
                                                                                TextStyle(
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
                                                                decoration:
                                                                    const BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .only(
                                                                    bottomLeft:
                                                                        Radius.circular(
                                                                            50),
                                                                  ),
                                                                  color: Color(
                                                                      0XFFf65656),
                                                                ),
                                                                height: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height /
                                                                    20,
                                                                width: double
                                                                    .infinity,
                                                              ), //Container
                                                            ], //<Widget>[]
                                                          ),
                                                          const SizedBox(
                                                            height: 80,
                                                          ),
                                                          Container(
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                const Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .only(
                                                                    left: 27,
                                                                    bottom: 20,
                                                                  ),
                                                                  child: Text(
                                                                    'Quick Actions',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                      letterSpacing:
                                                                          1.5,
                                                                      fontFamily:
                                                                          "tabfont",
                                                                    ),
                                                                  ),
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceAround,
                                                                  children: [
                                                                    GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        setState(
                                                                            () {
                                                                          counter =
                                                                              10;
                                                                          dashboard =
                                                                              false;
                                                                          allcategory =
                                                                              false;
                                                                          allcustomers =
                                                                              false;
                                                                          alltaxes =
                                                                              false;
                                                                          allitems =
                                                                              false;
                                                                          addcustomer =
                                                                              true;
                                                                          additems =
                                                                              false;
                                                                          addtax =
                                                                              false;
                                                                          addcategory =
                                                                              false;
                                                                        });
                                                                      },
                                                                      child:
                                                                          CircleContainer(
                                                                        gradient:
                                                                            const LinearGradient(
                                                                          begin:
                                                                              Alignment.topLeft,
                                                                          end: Alignment
                                                                              .bottomRight,
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
                                                                        icon:
                                                                            Icon(
                                                                          MdiIcons
                                                                              .account,
                                                                          color:
                                                                              white,
                                                                          size:
                                                                              30,
                                                                        ),
                                                                        text:
                                                                            'CUSTOMER',
                                                                      ),
                                                                    ),
                                                                    GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        setState(
                                                                            () {
                                                                          counter =
                                                                              10;
                                                                          dashboard =
                                                                              false;
                                                                          allcategory =
                                                                              false;
                                                                          allcustomers =
                                                                              false;
                                                                          alltaxes =
                                                                              false;
                                                                          allitems =
                                                                              false;
                                                                          addcustomer =
                                                                              false;
                                                                          additems =
                                                                              true;
                                                                          addtax =
                                                                              false;
                                                                          addcategory =
                                                                              false;
                                                                        });
                                                                        // Navigator.push(
                                                                        //     context,
                                                                        //     MaterialPageRoute(
                                                                        //         builder: (context) =>
                                                                        //            ));
                                                                      },
                                                                      child:
                                                                          const CircleContainer(
                                                                        gradient:
                                                                            LinearGradient(
                                                                          begin:
                                                                              Alignment.topLeft,
                                                                          end: Alignment
                                                                              .bottomRight,
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
                                                                        icon:
                                                                            Icon(
                                                                          CommunityMaterialIcons
                                                                              .food,
                                                                          size:
                                                                              30,
                                                                          color:
                                                                              white,
                                                                        ),
                                                                        text:
                                                                            'ITEMS',
                                                                      ),
                                                                    ),
                                                                    GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        setState(
                                                                            () {
                                                                          counter =
                                                                              10;
                                                                          dashboard =
                                                                              false;
                                                                          allcategory =
                                                                              false;
                                                                          allcustomers =
                                                                              false;
                                                                          alltaxes =
                                                                              false;
                                                                          allitems =
                                                                              false;
                                                                          addcustomer =
                                                                              false;
                                                                          additems =
                                                                              false;
                                                                          addtax =
                                                                              true;
                                                                          addcategory =
                                                                              false;
                                                                        });
                                                                        // Navigator.push(
                                                                        //     context,
                                                                        //     MaterialPageRoute(
                                                                        //         builder: (context) =>
                                                                        //             AddTaxScreen(
                                                                        //                 docId:
                                                                        //                     widget.Uid)));
                                                                      },
                                                                      child:
                                                                          const CircleContainer(
                                                                        gradient:
                                                                            LinearGradient(
                                                                          begin:
                                                                              Alignment.topLeft,
                                                                          end: Alignment
                                                                              .bottomRight,
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
                                                                        icon:
                                                                            Icon(
                                                                          CommunityMaterialIcons
                                                                              .currency_usd_circle,
                                                                          color:
                                                                              white,
                                                                          size:
                                                                              30,
                                                                        ),
                                                                        text:
                                                                            'TAX',
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                const SizedBox(
                                                                  height: 40,
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceAround,
                                                                  children: [
                                                                    GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute(builder: (context) => AddUnitScreen(docId: widget.Uid)));
                                                                      },
                                                                      child:
                                                                          CircleContainer(
                                                                        gradient:
                                                                            const LinearGradient(
                                                                          begin:
                                                                              Alignment.topLeft,
                                                                          end: Alignment
                                                                              .bottomRight,
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
                                                                        icon:
                                                                            Icon(
                                                                          MdiIcons
                                                                              .scaleUnbalanced,
                                                                          color:
                                                                              white,
                                                                          size:
                                                                              30,
                                                                        ),
                                                                        text:
                                                                            'UNITS',
                                                                      ),
                                                                    ),
                                                                    GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        setState(
                                                                            () {
                                                                          counter =
                                                                              10;
                                                                          dashboard =
                                                                              false;
                                                                          allcategory =
                                                                              false;
                                                                          allcustomers =
                                                                              false;
                                                                          alltaxes =
                                                                              false;
                                                                          allitems =
                                                                              false;
                                                                          addcustomer =
                                                                              false;
                                                                          additems =
                                                                              false;
                                                                          addtax =
                                                                              false;
                                                                          addcategory =
                                                                              true;
                                                                        });
                                                                        // Navigator.push(
                                                                        //     context,
                                                                        //     MaterialPageRoute(
                                                                        //         builder:
                                                                        //             (context) =>
                                                                        //                 AddDepartmentScreen(docId: widget.Uid)));
                                                                      },
                                                                      child:
                                                                          CircleContainer(
                                                                        gradient:
                                                                            const LinearGradient(
                                                                          begin:
                                                                              Alignment.topLeft,
                                                                          end: Alignment
                                                                              .bottomRight,
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
                                                                        icon:
                                                                            Icon(
                                                                          MdiIcons
                                                                              .textBoxOutline,
                                                                          color:
                                                                              white,
                                                                        ),
                                                                        text:
                                                                            'CATEGORY',
                                                                      ),
                                                                    ),
                                                                    GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute(builder: (context) => AllFoodsScreen(documentId: widget.Uid)));
                                                                      },
                                                                      child:
                                                                          CircleContainer(
                                                                        gradient:
                                                                            const LinearGradient(
                                                                          begin:
                                                                              Alignment.topLeft,
                                                                          end: Alignment
                                                                              .bottomRight,
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
                                                                        icon:
                                                                            Icon(
                                                                          MdiIcons
                                                                              .handCoinOutline,
                                                                          color:
                                                                              white,
                                                                        ),
                                                                        text:
                                                                            'ALL-ITEM',
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
          return Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(color: Colors.white),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 6,
                  height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(
                    //borderRadius: BorderRadius.circular(15),
                    //color: Color(0xd0424e),
                    color: Color(0XFFd0424e),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: ListView(
                      children: [
                        const SizedBox(
                          height: 12,
                        ),
                        const Text(
                          'Pos Admin',
                          style: TextStyle(
                              fontFamily: "tabfont",
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 25),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        // Column(
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: [
                        //     Text(
                        //       phone,
                        //       style: const TextStyle(
                        //         color: white,
                        //         fontFamily: "tabfont",
                        //       ),
                        //     ),
                        //     const SizedBox(
                        //       height: 8,
                        //     ),
                        //     const Text(
                        //       'Phone-No',
                        //       style: TextStyle(
                        //         fontSize: 12,
                        //         color: grey,
                        //         fontFamily: "fontmain",
                        //       ),
                        //     )
                        //   ],
                        // ),
                        const SizedBox(
                          height: 30,
                        ),
                        dashboardicon(1),
                        dashboardicon(2),
                        dashboardicon(3),
                        dashboardicon(4),
                        dashboardicon(5),
                        dashboardicon(6)
                        //dashboardicon(6),
                      ],
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width -
                          MediaQuery.of(context).size.width / 6,
                      height: MediaQuery.of(context).size.height,
                      child: allcustomers
                          ? AllCustomerScreen(
                              adminUid: widget.Uid,
                            )
                          : allcategory
                              ? DepartmentListScreen(
                                  docId: widget.Uid,
                                )
                              : alltaxes
                                  ? TaxListScreen(
                                      docId: widget.Uid,
                                    )
                                  : allitems
                                      ? AllFoodsScreen(documentId: widget.Uid)
                                      : addcustomer
                                          ? AddCustomerScreen(uid: widget.Uid)
                                          : additems
                                              ? AddItemScreen(uid: widget.Uid)
                                              : addtax
                                                  ? AddTaxScreen(
                                                      docId: widget.Uid)
                                                  : addcategory
                                                      ? AddDepartmentScreen(
                                                          docId: widget.Uid)
                                                      : allreport
                                                          ? OverAllReport()
                                                          : ListView(
                                                              children: [
                                                                Container(
                                                                  width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width -
                                                                      MediaQuery.of(context)
                                                                              .size
                                                                              .width /
                                                                          6,
                                                                  height: 55,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                        .white,

                                                                    boxShadow: [
                                                                      BoxShadow(
                                                                          color: Colors.grey.withOpacity(
                                                                              0.8),
                                                                          spreadRadius:
                                                                              0.5,
                                                                          blurRadius:
                                                                              0.5)
                                                                    ],
                                                                    // boxShadow: [
                                                                    //   BoxShadow(color: Colors.grey.withOpacity(0.3), spreadRadius: 1, blurRadius: 1)
                                                                    // ]
                                                                  ),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(left: 40),
                                                                            child:
                                                                                Text('Hii $name', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 21, fontFamily: 'tabfont')),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const Spacer(),
                                                                      Padding(
                                                                        padding: const EdgeInsets
                                                                            .only(
                                                                            right:
                                                                                25),
                                                                        child:
                                                                            Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            Text(
                                                                              email,
                                                                              style: const TextStyle(
                                                                                color: Colors.black,
                                                                                fontFamily: "tabfont",
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      IconButton(
                                                                          onPressed:
                                                                              () {
                                                                            showDialog(
                                                                              context: context,
                                                                              builder: (BuildContext) {
                                                                                return Dialog(
                                                                                    // backgroundColor: Colors.amber.shade100,
                                                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)), //this right here
                                                                                    child: SizedBox(
                                                                                      height: 200,
                                                                                      width: 300,
                                                                                      child: Center(
                                                                                        child: Column(
                                                                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                          children: [
                                                                                            const Text(
                                                                                              "Are you sure ?",
                                                                                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                                                                                            ),
                                                                                            Row(
                                                                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                                              children: [
                                                                                                ElevatedButton(
                                                                                                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0XFF26c589)),
                                                                                                  child: const Text("Cancel", style: TextStyle(color: Colors.white)),
                                                                                                  onPressed: () {
                                                                                                    Navigator.pop(context);
                                                                                                  },
                                                                                                ),
                                                                                                ElevatedButton(
                                                                                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                                                                                  child: const Text(
                                                                                                    "Logout",
                                                                                                    style: TextStyle(color: Colors.white),
                                                                                                  ),
                                                                                                  onPressed: () async {
                                                                                                    SharedPreferences prefs = await SharedPreferences.getInstance();
                                                                                                    await prefs.setBool('isLogged', false);
                                                                                                    FirebaseAuth.instance.signOut();
                                                                                                    Navigator.pushReplacement(
                                                                                                        context,
                                                                                                        MaterialPageRoute(
                                                                                                          builder: (context) => const Inception(),
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
                                                                          icon:
                                                                              const Icon(
                                                                            Icons.logout,
                                                                            color:
                                                                                Colors.black,
                                                                          )),
                                                                      const SizedBox(
                                                                        width:
                                                                            25,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  height: 25,
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          40),
                                                                  child: Column(
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          IconButton(
                                                                            icon:
                                                                                Icon(Icons.arrow_back),
                                                                            onPressed:
                                                                                () {
                                                                              _scrollController.animateTo(
                                                                                _scrollController.offset - MediaQuery.of(context).size.width,
                                                                                duration: Duration(milliseconds: 500),
                                                                                curve: Curves.easeInOut,
                                                                              );
                                                                            },
                                                                          ),
                                                                          IconButton(
                                                                            icon:
                                                                                Icon(Icons.arrow_forward),
                                                                            onPressed:
                                                                                () {
                                                                              _scrollController.animateTo(
                                                                                _scrollController.offset + MediaQuery.of(context).size.width,
                                                                                duration: Duration(milliseconds: 500),
                                                                                curve: Curves.easeInOut,
                                                                              );
                                                                            },
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            132,
                                                                        child:
                                                                            SingleChildScrollView(
                                                                          scrollDirection:
                                                                              Axis.horizontal,
                                                                          controller:
                                                                              _scrollController,
                                                                          child:
                                                                              Row(
                                                                            children:
                                                                                List.generate(
                                                                              4,
                                                                              (index) => GestureDetector(
                                                                                onTap: () {
                                                                                  setState(() {
                                                                                    setState(() {
                                                                                index == 0
                                                                                    ? {
                                                                                        counter = 10,
                                                                                        dashboard = false,
                                                                                        allcategory = false,
                                                                                        allcustomers = false,
                                                                                        alltaxes = false,
                                                                                        allitems = false,
                                                                                        addcustomer = true,
                                                                                        additems = false,
                                                                                        addtax = false,
                                                                                        addcategory = false,
                                                                                        allreport = false,
                                                                                      }
                                                                                    : index == 1
                                                                                        ? {
                                                                                            counter = 10,
                                                                                            dashboard = false,
                                                                                            allcategory = false,
                                                                                            allcustomers = false,
                                                                                            alltaxes = false,
                                                                                            allitems = false,
                                                                                            addcustomer = false,
                                                                                            additems = true,
                                                                                            addtax = false,
                                                                                            addcategory = false,
                                                                                            allreport = false,
                                                                                          }
                                                                                        : index == 2
                                                                                            ? {
                                                                                                counter = 10,
                                                                                                dashboard = false,
                                                                                                allcategory = false,
                                                                                                allcustomers = false,
                                                                                                alltaxes = false,
                                                                                                allitems = false,
                                                                                                addcustomer = false,
                                                                                                additems = false,
                                                                                                addtax = true,
                                                                                                addcategory = false,
                                                                                                allreport = false,
                                                                                              }
                                                                                            : {
                                                                                                counter = 10,
                                                                                                dashboard = false,
                                                                                                allcategory = false,
                                                                                                allcustomers = false,
                                                                                                alltaxes = false,
                                                                                                allitems = false,
                                                                                                addcustomer = false,
                                                                                                additems = false,
                                                                                                addtax = false,
                                                                                                addcategory = true,
                                                                                                allreport = false,
                                                                                              };
                                                                              });
                                                                                  });
                                                                                },
                                                                                child: Padding(
                                                                                  padding: const EdgeInsets.only(right: 25, top: 1, bottom: 1, left: 1),
                                                                                  child: Container(
                                                                                    height: 130,
                                                                                    width: 285,
                                                                                    decoration: BoxDecoration(
                                                                                      color: index == 0
                                                                                          ? const Color(0XFFd0424e)
                                                                                          : index == 1
                                                                                              ? const Color(0XFFf5a623)
                                                                                              : index == 2
                                                                                                  ? const Color(0XFFd0424e)
                                                                                                  : const Color(0XFFf5a623),
                                                                                      borderRadius: BorderRadius.circular(8),
                                                                                    ),
                                                                                    child: Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                                      children: [
                                                                                        Column(
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                                          children: [
                                                                                            Text(
                                                                                              index == 0
                                                                                                  ? 'Customers'
                                                                                                  : index == 1
                                                                                                      ? 'Items'
                                                                                                      : index == 2
                                                                                                          ? 'Tax'
                                                                                                          : 'Categories',
                                                                                              style: TextStyle(
                                                                                                color: Colors.white.withOpacity(0.6),
                                                                                                fontWeight: FontWeight.w500,
                                                                                                fontSize: 18,
                                                                                              ),
                                                                                            ),
                                                                                            const SizedBox(
                                                                                              height: 25,
                                                                                            ),
                                                                                            StreamBuilder(
                                                                                              stream: index == 0
                                                                                                  ? FirebaseFirestore.instance.collection('AllAdmins').doc(widget.Uid).collection('customer').snapshots()
                                                                                                  : index == 1
                                                                                                      ? FirebaseFirestore.instance.collection('AllAdmins').doc(widget.Uid).collection('foodItems').snapshots()
                                                                                                      : index == 2
                                                                                                          ? FirebaseFirestore.instance.collection('AllAdmins').doc(widget.Uid).collection('tax').snapshots()
                                                                                                          : FirebaseFirestore.instance.collection('AllAdmins').doc(widget.Uid).collection('departments').snapshots(),
                                                                                              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                                                                                if (snapshot.hasData) {
                                                                                                  return Text(
                                                                                                    snapshot.data!.docs.length.toString(),
                                                                                                    style: TextStyle(
                                                                                                      color: Colors.white,
                                                                                                      fontWeight: FontWeight.w500,
                                                                                                      fontSize: 18,
                                                                                                    ),
                                                                                                  );
                                                                                                } else {
                                                                                                  return const Text(
                                                                                                    '50',
                                                                                                    style: TextStyle(
                                                                                                      color: Colors.white,
                                                                                                      fontWeight: FontWeight.w500,
                                                                                                      fontSize: 18,
                                                                                                    ),
                                                                                                  );
                                                                                                }
                                                                                              },
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                        Container(
                                                                                          height: 60,
                                                                                          width: 60,
                                                                                          decoration: BoxDecoration(
                                                                                            color: Colors.white,
                                                                                            borderRadius: BorderRadius.circular(30),
                                                                                          ),
                                                                                          child: Icon(
                                                                                            index == 0
                                                                                                ? Icons.verified_user_sharp
                                                                                                : index == 1
                                                                                                    ? Icons.production_quantity_limits
                                                                                                    : index == 2
                                                                                                        ? Icons.currency_bitcoin
                                                                                                        : Icons.category,
                                                                                            color: index == 0
                                                                                                ? const Color(0XFFd0424e)
                                                                                                : index == 1
                                                                                                    ? const Color(0XFFf5a623)
                                                                                                    : index == 2
                                                                                                        ? const Color(0XFFd0424e)
                                                                                                        : const Color(0XFFf5a623),
                                                                                            size: 35,
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                const Padding(
                                                                  padding: EdgeInsets.symmetric(
                                                                      vertical:
                                                                          25,
                                                                      horizontal:
                                                                          40),
                                                                  child: Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .topLeft,
                                                                    child: Text(
                                                                      'Quick Actions',
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              'tabfont',
                                                                          color: Colors
                                                                              .black,
                                                                          fontWeight: FontWeight
                                                                              .w600,
                                                                          fontSize:
                                                                              21),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          40),
                                                                  child: Column(
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          IconButton(
                                                                            icon:
                                                                                Icon(Icons.arrow_back),
                                                                            onPressed:
                                                                                () {
                                                                              _scrollController2.animateTo(
                                                                                _scrollController2.offset - MediaQuery.of(context).size.width,
                                                                                duration: Duration(milliseconds: 500),
                                                                                curve: Curves.easeInOut,
                                                                              );
                                                                            },
                                                                          ),
                                                                          IconButton(
                                                                            icon:
                                                                                Icon(Icons.arrow_forward),
                                                                            onPressed:
                                                                                () {
                                                                              _scrollController2.animateTo(
                                                                                _scrollController2.offset + MediaQuery.of(context).size.width,
                                                                                duration: Duration(milliseconds: 500),
                                                                                curve: Curves.easeInOut,
                                                                              );
                                                                            },
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            132,
                                                                        child: ListView
                                                                            .builder(
                                                                          itemCount:
                                                                              4,
                                                                          scrollDirection:
                                                                              Axis.horizontal,
                                                                          controller:
                                                                              _scrollController2,
                                                                          itemBuilder:
                                                                              (context, index) {
                                                                            return Padding(
                                                                              padding: const EdgeInsets.only(right: 25, top: 1, bottom: 1, left: 1),
                                                                              child: InkWell(
                                                                                onTap: () {
                                                                                  //   setState(() {
                                                                                  //     index == 0
                                                                                  //         ? {
                                                                                  //             counter = 10,
                                                                                  //             dashboard = false,
                                                                                  //             allcategory = false,
                                                                                  //             allcustomers = false,
                                                                                  //             alltaxes = false,
                                                                                  //             allitems = false,
                                                                                  //             addcustomer = true,
                                                                                  //             additems = false,
                                                                                  //             addtax = false,
                                                                                  //             addcategory = false,
                                                                                  //             allreport = false,
                                                                                  //           }
                                                                                  //         : index == 1
                                                                                  //             ? {
                                                                                  //                 counter = 10,
                                                                                  //                 dashboard = false,
                                                                                  //                 allcategory = false,
                                                                                  //                 allcustomers = false,
                                                                                  //                 alltaxes = false,
                                                                                  //                 allitems = false,
                                                                                  //                 addcustomer = false,
                                                                                  //                 additems = true,
                                                                                  //                 addtax = false,
                                                                                  //                 addcategory = false,
                                                                                  //                 allreport = false,
                                                                                  //               }
                                                                                  //             : index == 2
                                                                                  //                 ? {
                                                                                  //                     counter = 10,
                                                                                  //                     dashboard = false,
                                                                                  //                     allcategory = false,
                                                                                  //                     allcustomers = false,
                                                                                  //                     alltaxes = false,
                                                                                  //                     allitems = false,
                                                                                  //                     addcustomer = false,
                                                                                  //                     additems = false,
                                                                                  //                     addtax = true,
                                                                                  //                     addcategory = false,
                                                                                  //                     allreport = false,
                                                                                  //                   }
                                                                                  //                 : {
                                                                                  //                     counter = 10,
                                                                                  //                     dashboard = false,
                                                                                  //                     allcategory = false,
                                                                                  //                     allcustomers = false,
                                                                                  //                     alltaxes = false,
                                                                                  //                     allitems = false,
                                                                                  //                     addcustomer = false,
                                                                                  //                     additems = false,
                                                                                  //                     addtax = false,
                                                                                  //                     addcategory = true,
                                                                                  //                     allreport = false,
                                                                                  //                   };
                                                                                  //   });
                                                                                },
                                                                                child: Container(
                                                                                  height: 130,
                                                                                  width: 285,
                                                                                  decoration: BoxDecoration(
                                                                                    color: Colors.white,
                                                                                    boxShadow: [
                                                                                      BoxShadow(color: Colors.grey, spreadRadius: 0.5, blurRadius: 0.5)
                                                                                    ],
                                                                                    borderRadius: BorderRadius.circular(8),
                                                                                  ),
                                                                                  child: Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                                    children: [
                                                                                      Column(
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                                        children: [
                                                                                          Text(
                                                                                            index == 0
                                                                                                ? 'Total Bill Amount'
                                                                                                : index == 1
                                                                                                    ? 'Total Bill Number'
                                                                                                    : index == 2
                                                                                                        ? 'Total Item Sale'
                                                                                                        : 'Today Total Item sale',
                                                                                            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 14),
                                                                                          ),
                                                                                          const SizedBox(
                                                                                            height: 25,
                                                                                          ),
                                                                                          Text(
                                                                                            '100000',
                                                                                            style: TextStyle(color: Colors.black.withOpacity(0.8), fontWeight: FontWeight.w600, fontSize: 16),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                      Container(
                                                                                        height: 60,
                                                                                        width: 60,
                                                                                        decoration: BoxDecoration(
                                                                                          color: index == 0
                                                                                              ? const Color(0XFFd0424e)
                                                                                              : index == 1
                                                                                                  ? const Color(0XFFf5a623)
                                                                                                  : index == 2
                                                                                                      ? const Color(0XFFd0424e)
                                                                                                      : const Color(0XFFf5a623),
                                                                                          borderRadius: BorderRadius.circular(30),
                                                                                        ),
                                                                                        child: index == 0
                                                                                            ? const Icon(
                                                                                                Icons.verified_user_sharp,
                                                                                                color: Colors.white,
                                                                                                size: 36,
                                                                                              )
                                                                                            : index == 1
                                                                                                ? const Icon(
                                                                                                    Icons.production_quantity_limits,
                                                                                                    color: Colors.white,
                                                                                                    size: 36,
                                                                                                  )
                                                                                                : index == 2
                                                                                                    ? const Icon(
                                                                                                        Icons.currency_bitcoin,
                                                                                                        color: Colors.white,
                                                                                                        size: 36,
                                                                                                      )
                                                                                                    : const Icon(
                                                                                                        Icons.category,
                                                                                                        color: Colors.white,
                                                                                                        size: 36,
                                                                                                      ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            );
                                                                          },
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                const Padding(
                                                                  padding: EdgeInsets.symmetric(
                                                                      vertical:
                                                                          25,
                                                                      horizontal:
                                                                          40),
                                                                  child: Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .topLeft,
                                                                    child: Text(
                                                                      'Food Items',
                                                                      style: TextStyle(
                                                                          fontFamily:
                                                                              'tabfont',
                                                                          color: Colors
                                                                              .black,
                                                                          fontWeight: FontWeight
                                                                              .w600,
                                                                          fontSize:
                                                                              21),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          40),
                                                                  child:
                                                                      SizedBox(
                                                                    height: 245,
                                                                    child: ListView.builder(
                                                                        itemCount: 15,
                                                                        scrollDirection: Axis.horizontal,
                                                                        itemBuilder: (context, index) {
                                                                          return Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(right: 21),
                                                                            child:
                                                                                Stack(
                                                                              children: [
                                                                                Padding(
                                                                                  padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 1),
                                                                                  child: Container(
                                                                                    height: 220,
                                                                                    decoration: const BoxDecoration(
                                                                                      //border: Border.all(color: primaryColor),
                                                                                      borderRadius: BorderRadius.all(Radius.circular(11)),
                                                                                      // color: Colors.white,
                                                                                    ),
                                                                                    child: Padding(
                                                                                      padding: const EdgeInsets.all(4.0),
                                                                                      child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                                                        Container(
                                                                                          height: 150,
                                                                                          width: 180,
                                                                                          decoration: const BoxDecoration(
                                                                                            //color: primaryColor.withOpacity(0.2),
                                                                                            //borderRadius: BorderRadius.circular(75),
                                                                                            image: DecorationImage(
                                                                                              image: NetworkImage('https://cdn.pixabay.com/photo/2014/11/05/15/57/salmon-518032_640.jpg'),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                        const Text(
                                                                                          'Veg Burger Delight',
                                                                                          textAlign: TextAlign.center,
                                                                                          maxLines: 2,
                                                                                          style: TextStyle(
                                                                                            // fontFamily: 'fontmain',
                                                                                            color: Colors.black,
                                                                                            fontWeight: FontWeight.w500,
                                                                                            //letterSpacing: 1.2,
                                                                                            fontSize: 15,
                                                                                          ),
                                                                                        ),
                                                                                        const Text(
                                                                                          "2211345",
                                                                                          textAlign: TextAlign.center,
                                                                                          // maxLines: 2,
                                                                                          style: TextStyle(
                                                                                            //fontFamily: 'fontmain',
                                                                                            color: Colors.grey,
                                                                                            fontWeight: FontWeight.w500,
                                                                                            //letterSpacing: 1.2,
                                                                                            fontSize: 13,
                                                                                          ),
                                                                                        ),
                                                                                        Text(
                                                                                          '₹89',
                                                                                          textAlign: TextAlign.center,
                                                                                          maxLines: 2,
                                                                                          style: TextStyle(
                                                                                            // fontFamily: 'fontmain',
                                                                                            color: Colors.black.withOpacity(0.5),
                                                                                            fontWeight: FontWeight.bold,
                                                                                            //letterSpacing: 1.2,
                                                                                            fontSize: 15,
                                                                                          ),
                                                                                        ),
                                                                                      ]),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          );
                                                                        }),
                                                                  ),
                                                                )
                                                              ],
                                                            )),
                ),
              ],
            ),
          );
        }
      }),
    );
  }

  int counter = 1;
  dashboardicon(int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: MaterialButton(
        onPressed: () {
          index == 1
              ? setState(() {
                  counter = index;
                  allcategory = false;
                  dashboard = true;
                  alltaxes = false;
                  allcustomers = false;
                  allitems = false;
                  addcustomer = false;
                  additems = false;
                  addtax = false;
                  addcategory = false;
                  allreport = false;
                })
              : index == 2
                  ? setState(() {
                      counter = index;
                      alltaxes = false;
                      dashboard = false;
                      allcategory = false;
                      allcustomers = true;
                      allitems = false;
                      addcustomer = false;
                      additems = false;
                      addtax = false;
                      addcategory = false;
                      allreport = false;
                    })
                  : index == 3
                      ? setState(() {
                          counter = index;
                          dashboard = false;
                          allcategory = true;
                          allcustomers = false;
                          alltaxes = false;
                          allitems = false;
                          addcustomer = false;
                          additems = false;
                          addtax = false;
                          addcategory = false;
                          allreport = false;
                        })
                      : index == 4
                          ? setState(() {
                              counter = index;
                              dashboard = false;
                              allcategory = false;
                              allcustomers = false;
                              alltaxes = true;
                              allitems = false;
                              addcustomer = false;
                              additems = false;
                              addtax = false;
                              addcategory = false;
                              allreport = false;
                            })
                          : index == 5
                              ? setState(() {
                                  counter = index;
                                  dashboard = false;
                                  allcategory = false;
                                  allcustomers = false;
                                  alltaxes = false;
                                  allitems = true;
                                  addcustomer = false;
                                  additems = false;
                                  addtax = false;
                                  addcategory = false;
                                  allreport = false;
                                })
                              : setState(() {
                                  counter = index;
                                  dashboard = false;
                                  allcategory = false;
                                  allcustomers = false;
                                  alltaxes = false;
                                  allitems = false;
                                  addcustomer = false;
                                  additems = false;
                                  addtax = false;
                                  addcategory = false;
                                  allreport = true;
                                });
        },
        color: counter == index
            ? const Color(0XFFac3749)
            : const Color(0XFFd0424e),
        hoverColor: const Color(0XFFac3749),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
          child: MediaQuery.of(context).size.width < 1000
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    index == 1
                        ? const Icon(
                            Icons.dashboard,
                            color: Colors.white,
                            size: 16,
                          )
                        : index == 2
                            ? const Icon(
                                Icons.verified_user_sharp,
                                color: Colors.white,
                                size: 16,
                              )
                            : index == 3
                                ? const Icon(
                                    Icons.category,
                                    color: Colors.white,
                                    size: 16,
                                  )
                                : index == 4
                                    ? const Icon(
                                        Icons.currency_bitcoin,
                                        color: Colors.white,
                                        size: 16,
                                      )
                                    : index == 5
                                        ? const Icon(
                                            Icons.production_quantity_limits,
                                            color: Colors.white,
                                            size: 16,
                                          )
                                        : const Icon(
                                            Icons.list,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                    Text(
                      index == 1
                          ? 'Dashboard'
                          : index == 2
                              ? 'Customer List'
                              : index == 3
                                  ? 'Category List'
                                  : index == 4
                                      ? 'Tax List'
                                      : index == 5
                                          ? 'All-Items'
                                          : 'All Repoprts',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: Colors.white),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    index == 1
                        ? const Icon(
                            Icons.dashboard,
                            color: Colors.white,
                          )
                        : index == 2
                            ? const Icon(
                                Icons.verified_user_sharp,
                                color: Colors.white,
                              )
                            : index == 3
                                ? const Icon(
                                    Icons.category,
                                    color: Colors.white,
                                  )
                                : index == 4
                                    ? const Icon(
                                        Icons.currency_bitcoin,
                                        color: Colors.white,
                                      )
                                    : index == 5
                                        ? const Icon(
                                            Icons.production_quantity_limits,
                                            color: Colors.white,
                                          )
                                        : const Icon(
                                            Icons.list,
                                            color: Colors.white,
                                          ),
                    SizedBox(
                      width: 100,
                      child: Text(
                        index == 1
                            ? 'Dashboard'
                            : index == 2
                                ? 'Customer List'
                                : index == 3
                                    ? 'Category List'
                                    : index == 4
                                        ? 'Tax List'
                                        : index == 5
                                            ? 'All-Items'
                                            : 'All Repoprts',
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
