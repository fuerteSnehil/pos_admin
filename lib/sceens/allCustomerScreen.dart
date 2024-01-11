import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:pos_admin/constants/colors.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';
//import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class AllCustomerScreen extends StatefulWidget {
  final String adminUid;

  AllCustomerScreen({required this.adminUid});

  @override
  State<AllCustomerScreen> createState() => _AllCustomerScreenState();
}

class _AllCustomerScreenState extends State<AllCustomerScreen> {
  List ids = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).size.width);
    return MediaQuery.of(context).size.width < 600
        ? StreamBuilder<QuerySnapshot>(
            stream: _firestore
                .collection('AllAdmins')
                .doc(widget.adminUid)
                .collection('customer')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              var customers = snapshot.data!.docs;
              List<Widget> customerWidgets = [];
              for (var customer in customers) {
                var customerData = customer.data() as Map<String, dynamic>;
                var customerId = customer.id;
                var customerName = customerData['name'];
                var customerPhone = customerData['phoneNumber'];
                var customerCode = customerData['customerCode'];
                var customerEmail = customerData['email'];

                var customerWidget = Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: MediaQuery.of(context).size.width * .3,
                    decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        const BoxShadow(
                          blurRadius: 4.0,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.0),
                              bottomLeft: Radius.circular(20.0),
                            ),
                          ),
                          height: MediaQuery.of(context).size.width * .3,
                          width: MediaQuery.of(context).size.width * .28,
                          padding: const EdgeInsets.all(8.0),
                          child: const CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 20.0,
                            backgroundImage:
                                AssetImage('$imagesPath/account.gif'),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8, top: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                customerName,
                                style: const TextStyle(
                                  fontSize: 19.0,
                                  fontFamily: "tabfont",
                                ),
                              ),
                              Text(
                                "Customer Code: $customerCode",
                                style: const TextStyle(
                                    fontFamily: "fontmain",
                                    fontSize: 15.0,
                                    color: Colors.black54),
                              ),
                              Text(
                                "Phone No: $customerPhone",
                                style: const TextStyle(
                                    fontFamily: "fontmain",
                                    fontSize: 15.0,
                                    color: Colors.black54),
                              ),
                              Text(
                                customerEmail,
                                style: const TextStyle(
                                    fontFamily: "fontmain",
                                    fontSize: 15.0,
                                    color: Colors.black54),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                          ),
                          onPressed: () {
                            // Show a confirmation dialog before deleting
                            _showDeleteConfirmationDialog(context, customerId);
                          },
                        ),
                      ],
                    ),
                  ),
                );

                customerWidgets.add(customerWidget);
              }

              return ListView(
                children: customerWidgets,
              );
            },
          )
        : SizedBox(
            child: Column(
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
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 40),
                          child: Text("customer's List",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 21)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                child: Container(
                  height: 55,
                  width: MediaQuery.of(context).size.width -
                      MediaQuery.of(context).size.width / 6,
                  decoration: BoxDecoration(
                    color: const Color(0XFFd0424e),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      MediaQuery.of(context).size.width < 700
                          ? const SizedBox(
                              width: 0,
                            )
                          : Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Icon(
                                Icons.person,
                                size: 32,
                                color: Color(0XFFd0424e),
                              ),
                            ),
                      const SizedBox(
                        width: 120,
                        child: Text(
                          'Name',
                          //textAlign: TextAlign.center,
                          //maxLines: 2,
                          style: TextStyle(
                            // fontFamily: 'fontmain',
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            //letterSpacing: 1.2,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 140,
                        child: Text(
                          'Phonenumber',
                          //textAlign: TextAlign.center,
                          //maxLines: 2,
                          style: TextStyle(
                            // fontFamily: 'fontmain',
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            //letterSpacing: 1.2,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 120,
                        height: 20,
                        child: Text(
                          'Joining Date',
                          //textAlign: TextAlign.center,
                          //maxLines: 2,
                          style: TextStyle(
                            // fontFamily: 'fontmain',
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            //letterSpacing: 1.2,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: const Color(0XFFd0424e),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        // child: const Icon(
                        //   Icons.delete,
                        //   size: 32,
                        //   color: Colors.white,
                        // ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 40, top: 21, right: 40),
                  child: StreamBuilder(
                      stream: _firestore
                          .collection('AllAdmins')
                          .doc(widget.adminUid)
                          .collection('customer')
                          .snapshots(),
                      builder: (context,
                          AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                        if (streamSnapshot.hasData) {
                          return ResponsiveGridList(
                              horizontalGridSpacing: 6,
                              horizontalGridMargin: 0,
                              minItemWidth: 450,
                              minItemsPerRow: 1,
                              maxItemsPerRow: 1,
                              listViewBuilderOptions: ListViewBuilderOptions(),
                              children: List.generate(
                                  streamSnapshot.data!.docs.length, (index) {
                                final DocumentSnapshot documentSnapshot =
                                    streamSnapshot.data!.docs[index];
                                //ids.add();
                                return Container(
                                  height: 55,
                                  width: MediaQuery.of(context).size.width -
                                      MediaQuery.of(context).size.width / 6,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(9),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 0.5,
                                          blurRadius: 0.5)
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      MediaQuery.of(context).size.width < 700
                                          ? const SizedBox(
                                              width: 0,
                                            )
                                          : Container(
                                              height: 40,
                                              width: 40,
                                              decoration: BoxDecoration(
                                                color: const Color(0XFFd0424e),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: const Icon(
                                                Icons.person,
                                                size: 32,
                                                color: Colors.white,
                                              ),
                                            ),
                                      SizedBox(
                                        width: 120,
                                        child: Text(
                                          documentSnapshot['name'],
                                          //textAlign: TextAlign.center,
                                          //maxLines: 2,
                                          style: const TextStyle(
                                            // fontFamily: 'fontmain',
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                            //letterSpacing: 1.2,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 140,
                                        child: Text(
                                          documentSnapshot['phoneNumber'],
                                          //textAlign: TextAlign.center,
                                          //maxLines: 2,
                                          style: const TextStyle(
                                            // fontFamily: 'fontmain',
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w500,
                                            //letterSpacing: 1.2,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 120,
                                        height: 20,
                                        child: Text(
                                          documentSnapshot['createdAt'],
                                          //textAlign: TextAlign.center,
                                          //maxLines: 2,
                                          style: const TextStyle(
                                            // fontFamily: 'fontmain',
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                            //letterSpacing: 1.2,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          _showDeleteConfirmationDialog(
                                              context, documentSnapshot.id);
                                        },
                                        child: Container(
                                          height: 40,
                                          width: 40,
                                          decoration: BoxDecoration(
                                            color: const Color(0XFFd0424e),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: const Icon(
                                            Icons.delete,
                                            size: 32,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }));
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      }),
                ),
              ),
            ],
          ));
  }

  // return GestureDetector(
  //                               onTap: () {},
  //                               child: Padding(
  //                                 padding: const EdgeInsets.only(
  //                                     right: 27, top: 1),
  //                                 child: Container(
  //                                   height: 180,
  //                                   width: 400,
  //                                   decoration: BoxDecoration(
  //                                     color: Color(0XFFf5a623),
  //                                     borderRadius:
  //                                         BorderRadius.circular(15),
  //                                     // boxShadow: [
  //                                     //   BoxShadow(
  //                                     //       color: Colors.black
  //                                     //           .withOpacity(0.5),
  //                                     //       spreadRadius: 0.5,
  //                                     //       blurRadius: 0.5)
  //                                     // ],
  //                                   ),
  //                                   child: Padding(
  //                                     padding: const EdgeInsets.only(
  //                                         right: 12, bottom: 8, left: 13),
  //                                     child: Row(
  //                                       //crossAxisAlignment: CrossAxisAlignment.center,
  //                                       mainAxisAlignment:
  //                                           MainAxisAlignment.spaceBetween,
  //                                       children: [
  //                                         SizedBox(
  //                                           height: 160,
  //                                           width: 130,
  //                                           child: Stack(
  //                                             children: [
  //                                               Container(
  //                                                 height: 140,
  //                                                 width: 130,
  //                                                 decoration: BoxDecoration(
  //                                                   color: Colors.blue
  //                                                       .withOpacity(0.2),
  //                                                   borderRadius:
  //                                                       BorderRadius
  //                                                           .circular(15),
  //                                                   image:
  //                                                       const DecorationImage(
  //                                                           image:
  //                                                               NetworkImage(
  //                                                             'https://www.shutterstock.com/image-vector/young-smiling-man-cartoon-character-600nw-2165502893.jpg',
  //                                                           ),
  //                                                           fit: BoxFit
  //                                                               .cover),
  //                                                 ),
  //                                               ),
  //                                               Positioned(
  //                                                 bottom: 5,
  //                                                 right: 30,
  //                                                 child: InkWell(
  //                                                   onTap: () {
  //                                                     _showDeleteConfirmationDialog(
  //                                                         context,
  //                                                         documentSnapshot
  //                                                             .id);
  //                                                   },
  //                                                   child: Container(
  //                                                     height: 30,
  //                                                     width: 70,
  //                                                     decoration: BoxDecoration(
  //                                                         // border: Border.all(
  //                                                         //     color: Colors
  //                                                         //         .black),
  //                                                         color:
  //                                                             Color(0XFFd0424e),
  //                                                         borderRadius:
  //                                                             BorderRadius
  //                                                                 .circular(
  //                                                                     6)),
  //                                                     child: const Padding(
  //                                                       padding:
  //                                                           EdgeInsets.only(
  //                                                               left: 5,
  //                                                               right: 5,
  //                                                               bottom: 1),
  //                                                       child: Center(
  //                                                         child: Text(
  //                                                           "Delete",
  //                                                           style: TextStyle(
  //                                                               fontFamily:
  //                                                                   'tabfont',
  //                                                               color: Colors
  //                                                                   .white,
  //                                                               fontSize:
  //                                                                   14),
  //                                                         ),
  //                                                       ),
  //                                                     ),
  //                                                   ),
  //                                                 ),
  //                                               ),
  //                                             ],
  //                                           ),
  //                                         ),
  //                                         Container(
  //                                           //color: Colors.amber,
  //                                           width: 170,
  //                                           height: 300,
  //                                           // color: Colors.amber,
  //                                           child: Column(
  //                                             mainAxisAlignment:
  //                                                 MainAxisAlignment
  //                                                     .spaceAround,
  //                                             crossAxisAlignment:
  //                                                 CrossAxisAlignment.end,
  //                                             children: [
  //                                               const SizedBox(
  //                                                 height: 21,
  //                                               ),
  //                                               Container(
  //                                                 padding: const EdgeInsets
  //                                                     .symmetric(
  //                                                     horizontal: 6,
  //                                                     vertical: 5),
  //                                                 decoration: BoxDecoration(
  //                                                     borderRadius:
  //                                                         BorderRadius
  //                                                             .circular(7),
  //                                                     color: Colors.black
  //                                                         .withOpacity(
  //                                                             0.6)),
  //                                                 child: Text(
  //                                                   documentSnapshot[
  //                                                       'name'],
  //                                                   textAlign:
  //                                                       TextAlign.center,
  //                                                   maxLines: 2,
  //                                                   style: const TextStyle(
  //                                                     // fontFamily: 'fontmain',
  //                                                     color: Colors.white,
  //                                                     fontWeight:
  //                                                         FontWeight.w500,
  //                                                     //letterSpacing: 1.2,
  //                                                     fontSize: 13,
  //                                                   ),
  //                                                 ),
  //                                               ),
  //                                               const SizedBox(
  //                                                 height: 8,
  //                                               ),
  //                                               Text(
  //                                                 documentSnapshot[
  //                                                     'customerCode'],
  //                                                 maxLines: 2,
  //                                                 style: const TextStyle(
  //                                                   // fontFamily: 'fontmain',
  //                                                   color: Colors.white,
  //                                                   fontWeight:
  //                                                       FontWeight.w500,
  //                                                   //letterSpacing: 1.2,
  //                                                   fontSize: 14,
  //                                                 ),
  //                                               ),
  //                                               const SizedBox(
  //                                                 height: 8,
  //                                               ),
  //                                               Text(
  //                                                 "  30 ratings",
  //                                                 textAlign:
  //                                                     TextAlign.center,
  //                                                 maxLines: 2,
  //                                                 style: TextStyle(
  //                                                   // fontFamily: 'fontmain',
  //                                                   color: Colors.white
  //                                                       .withOpacity(0.8),
  //                                                   fontWeight:
  //                                                       FontWeight.w400,
  //                                                   //letterSpacing: 1.2,
  //                                                   fontSize: 13,
  //                                                 ),
  //                                               ),
  //                                               const SizedBox(
  //                                                 height: 8,
  //                                               ),
  //                                               Text(
  //                                                 documentSnapshot[
  //                                                     'phoneNumber'],
  //                                                 style: const TextStyle(
  //                                                   // fontFamily: 'fontmain',
  //                                                   color: Colors.white,
  //                                                   fontWeight:
  //                                                       FontWeight.w600,
  //                                                   //letterSpacing: 1.2,
  //                                                   fontSize: 13,
  //                                                 ),
  //                                               ),
  //                                               const SizedBox(
  //                                                 height: 8,
  //                                               ),
  //                                               SizedBox(
  //                                                 width: 180,
  //                                                 height: 30,
  //                                                 child: Text(
  //                                                   documentSnapshot[
  //                                                       'email'],
  //                                                   maxLines: 3,
  //                                                   style: const TextStyle(
  //                                                     // fontFamily: 'fontmain',
  //                                                     color: Colors.white,
  //                                                     fontWeight:
  //                                                         FontWeight.w400,
  //                                                     //letterSpacing: 1.2,
  //                                                     fontSize: 13,
  //                                                   ),
  //                                                   textAlign:
  //                                                       TextAlign.end,
  //                                                 ),
  //                                               ),
  //                                             ],
  //                                           ),
  //                                         ),
  //                                       ],
  //                                     ),
  //                                   ),
  //                                 ),
  //                               ));

  void _showDeleteConfirmationDialog(
      BuildContext context, String customerId) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Customer"),
          content: const Text("Are you sure you want to delete this customer?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cancel
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(true); // Return true when delete is confirmed
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    ).then((result) {
      if (result == true) {
        _deleteCustomer(customerId);
      }
    });
  }

  Future<void> _deleteCustomer(String customerId) async {
    try {
      await _firestore
          .collection('AllAdmins')
          .doc(widget.adminUid)
          .collection('customer')
          .doc(customerId)
          .delete();
    } catch (e) {
      // Handle errors here
      print('Error deleting customer: $e');
    }
  }
}
