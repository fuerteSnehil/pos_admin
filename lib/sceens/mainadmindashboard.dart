import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pos_admin/sceens/addadmin.dart';
import 'package:pos_admin/sceens/adminDashboard.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';

class MainAdminDashboard extends StatefulWidget {
  const MainAdminDashboard({super.key});

  @override
  State<MainAdminDashboard> createState() => _MainAdminDashboardState();
}

class _MainAdminDashboardState extends State<MainAdminDashboard> {
  String search = '';
  bool addadmin = false;
  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).size.width);
    return MediaQuery.of(context).size.width < 600
        ? Scaffold(
            appBar: AppBar(),
          )
        : Scaffold(
            body: Container(
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
                        const SizedBox(
                          height: 30,
                        ),
                        dashboardicon(1),
                        dashboardicon(2),
                        dashboardicon(3),
                      ],
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width -
                          MediaQuery.of(context).size.width / 6,
                      height: MediaQuery.of(context).size.height,
                      child: addadmin
                          ? const AddAdmin()
                          : ListView(
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width -
                                      MediaQuery.of(context).size.width / 6,
                                  height: 55,
                                  decoration: BoxDecoration(
                                    color: Colors.white,

                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey.withOpacity(0.8),
                                          spreadRadius: 0.5,
                                          blurRadius: 0.5)
                                    ],
                                    // boxShadow: [
                                    //   BoxShadow(color: Colors.grey.withOpacity(0.3), spreadRadius: 1, blurRadius: 1)
                                    // ]
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(left: 40),
                                            child: Text('Hii Anil Sharma',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 21)),
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      const Padding(
                                        padding: EdgeInsets.only(right: 25),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'jbngcfh',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontFamily: "tabfont",
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext) {
                                                return Dialog(
                                                    // backgroundColor: Colors.amber.shade100,
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                20.0)), //this right here
                                                    child: SizedBox(
                                                      height: 200,
                                                      width: 300,
                                                      child: Center(
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: [
                                                            const Text(
                                                              "Are you sure ?",
                                                              style: TextStyle(
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceAround,
                                                              children: [
                                                                ElevatedButton(
                                                                  style: ElevatedButton.styleFrom(
                                                                      backgroundColor:
                                                                          const Color(
                                                                              0XFF26c589)),
                                                                  child: const Text(
                                                                      "Cancel",
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white)),
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                ),
                                                                ElevatedButton(
                                                                  style: ElevatedButton.styleFrom(
                                                                      backgroundColor:
                                                                          Colors
                                                                              .red),
                                                                  child:
                                                                      const Text(
                                                                    "Logout",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                  onPressed:
                                                                      () async {},
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
                                          icon: const Icon(
                                            Icons.logout,
                                            color: Colors.black,
                                          )),
                                      const SizedBox(
                                        width: 25,
                                      ),
                                    ],
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 25, horizontal: 40),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      'Quick Actions',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 21),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 40),
                                  child: SizedBox(
                                    height: 132,
                                    child: ListView.builder(
                                        itemCount: 4,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          return InkWell(
                                            onTap: () {},
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 25,
                                                  top: 1,
                                                  bottom: 1,
                                                  left: 1),
                                              child: Container(
                                                height: 130,
                                                width: 285,
                                                decoration: BoxDecoration(
                                                  color: index == 0
                                                      ? const Color(0XFFd0424e)
                                                      : index == 1
                                                          ? const Color(
                                                              0XFFf5a623)
                                                          : index == 2
                                                              ? const Color(
                                                                  0XFFd0424e)
                                                              : const Color(
                                                                  0XFFf5a623),
                                                  borderRadius:
                                                      BorderRadius.circular(8),

                                                  // boxShadow: [
                                                  //   BoxShadow(color: Colors.grey.withOpacity(0.3), spreadRadius: 1, blurRadius: 1)
                                                  // ]
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
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
                                                              color: Colors
                                                                  .white
                                                                  .withOpacity(
                                                                      0.6),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 18),
                                                        ),
                                                        const SizedBox(
                                                          height: 25,
                                                        ),
                                                        const Text(
                                                          '567',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 18),
                                                        ),
                                                      ],
                                                    ),
                                                    Container(
                                                        height: 60,
                                                        width: 60,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(30),
                                                        ),
                                                        child: Icon(
                                                          index == 0
                                                              ? Icons
                                                                  .verified_user_sharp
                                                              : index == 1
                                                                  ? Icons
                                                                      .production_quantity_limits
                                                                  : index == 2
                                                                      ? Icons
                                                                          .currency_bitcoin
                                                                      : Icons
                                                                          .category,
                                                          color: index == 0
                                                              ? const Color(
                                                                  0XFFd0424e)
                                                              : index == 1
                                                                  ? const Color(
                                                                      0XFFf5a623)
                                                                  : index == 2
                                                                      ? const Color(
                                                                          0XFFd0424e)
                                                                      : const Color(
                                                                          0XFFf5a623),
                                                          size: 35,
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 25, horizontal: 40),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'All Admins',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 21),
                                      ),
                                      Container(
                                        height: 45,
                                        width: 290,
                                        decoration: BoxDecoration(
                                            color: Colors.grey.withOpacity(0.1),
                                            border:
                                                Border.all(color: Colors.grey),
                                            // boxShadow: [
                                            //   BoxShadow(
                                            //       color: Colors.grey.withOpacity(0.1),
                                            //       spreadRadius: 0.4,
                                            //       blurRadius: 0.4)
                                            // ],
                                            borderRadius:
                                                BorderRadius.circular(21)),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 21, right: 11, bottom: 6),
                                          child: TextField(
                                            onChanged: (value) {
                                              search = value;
                                              setState(() {});
                                            },
                                            inputFormatters: [
                                              LengthLimitingTextInputFormatter(
                                                  10),
                                              //FilteringTextInputFormatter.digitsOnly,
                                            ],
                                            // controller: phone,
                                            decoration: const InputDecoration(
                                                suffixIcon: Icon(
                                                  Icons.search,
                                                  color: Colors.grey,
                                                ),
                                                border: InputBorder.none,
                                                hintText: "search here....",
                                                hintStyle: TextStyle(
                                                    color: Colors.grey)),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 2,
                                  child: StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection('AllAdmins')
                                          .snapshots(),
                                      builder: (context,
                                          AsyncSnapshot<QuerySnapshot>
                                              streamSnapshot) {
                                        if (streamSnapshot.hasData) {
                                          return ResponsiveGridList(
                                              horizontalGridSpacing: 6,
                                              horizontalGridMargin: 0,
                                              minItemWidth: 450,
                                              minItemsPerRow: 1,
                                              maxItemsPerRow: 1,
                                              listViewBuilderOptions:
                                                  ListViewBuilderOptions(),
                                              children: List.generate(
                                                  streamSnapshot.data!.docs
                                                      .length, (index) {
                                                final DocumentSnapshot
                                                    documentSnapshot =
                                                    streamSnapshot
                                                        .data!.docs[index];
                                                //ids.add();
                                                if (documentSnapshot['name']
                                                    .toString()
                                                    .toLowerCase()
                                                    .contains(search)) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 40,
                                                            right: 40,
                                                            top: 5),
                                                    child: InkWell(
                                                      onTap: () {
                                                        Navigator.of(context)
                                                            .push(
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                AdminDashboard(
                                                              Uid:
                                                                  documentSnapshot[
                                                                      'uID'],
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      child: Container(
                                                        height: 55,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width -
                                                            MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                6,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(9),
                                                          boxShadow: [
                                                            BoxShadow(
                                                                color: Colors
                                                                    .grey
                                                                    .withOpacity(
                                                                        0.5),
                                                                spreadRadius:
                                                                    0.5,
                                                                blurRadius: 0.5)
                                                          ],
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                          children: [
                                                            MediaQuery.of(context)
                                                                        .size
                                                                        .width <
                                                                    780
                                                                ? const SizedBox(
                                                                    width: 0,
                                                                  )
                                                                : Container(
                                                                    height: 40,
                                                                    width: 40,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: const Color(
                                                                          0XFFd0424e),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              20),
                                                                    ),
                                                                    child:
                                                                        const Icon(
                                                                      Icons
                                                                          .person,
                                                                      size: 32,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                            SizedBox(
                                                              width: 120,
                                                              child: Text(
                                                                documentSnapshot[
                                                                    'name'],
                                                                //textAlign: TextAlign.center,
                                                                //maxLines: 2,
                                                                style:
                                                                    const TextStyle(
                                                                  // fontFamily: 'fontmain',
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  //letterSpacing: 1.2,
                                                                  fontSize: 16,
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              // color: Colors.amber,
                                                              width: 125,
                                                              child: Text(
                                                                documentSnapshot[
                                                                    'phone'],
                                                                style:
                                                                    const TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize: 16,
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 90,
                                                              height: 20,
                                                              //color: Colors.amber,
                                                              child: Text(
                                                                documentSnapshot[
                                                                    'createdAt'],
                                                                //textAlign: TextAlign.center,
                                                                //maxLines: 2,
                                                                style:
                                                                    const TextStyle(
                                                                  // fontFamily: 'fontmain',
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  //letterSpacing: 1.2,
                                                                  fontSize: 16,
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              //color: Colors.amber,
                                                              width: 100,
                                                              child:
                                                                  GestureDetector(
                                                                onTap: () {
                                                                  handleRadioValueChange(
                                                                      2);
                                                                },
                                                                child: Row(
                                                                  children: [
                                                                    Radio(
                                                                      activeColor:
                                                                          const Color(
                                                                              0XFFac3749),
                                                                      value: 2,
                                                                      groupValue:
                                                                          selectedRadio,
                                                                      onChanged:
                                                                          handleRadioValueChange,
                                                                    ),
                                                                    const Text(
                                                                      'Active',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              17,
                                                                          fontFamily:
                                                                              'fontmain',
                                                                          fontWeight:
                                                                              FontWeight.w600),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                } else {
                                                  return SizedBox(
                                                    height: 0,
                                                  );
                                                }
                                              }));
                                        } else {
                                          return const Center(
                                              child:
                                                  CircularProgressIndicator());
                                        }
                                      }),
                                ),
                              ],
                            )),
                ),
              ],
            ),
          ));
  }

  int counter = 1;
  dashboardicon(int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: MaterialButton(
        onPressed: () {
          setState(() {
            index == 1
                ? {counter = 1, addadmin = false}
                : {counter = 2, addadmin = true};
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
                              ? 'Add Admin'
                              : 'settings',
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
                                ? 'Add Admin'
                                : 'settings',
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

  int selectedRadio = 2;

  void handleRadioValueChange(int? value) {
    if (value != null) {
      setState(() {
        selectedRadio = value;
      });
    }
  }
}
