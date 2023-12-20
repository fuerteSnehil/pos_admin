import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lottie/lottie.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pos_admin/constants/colors.dart';
import 'package:pos_admin/sceens/billDetailScreen.dart';

class OverAllReport extends StatefulWidget {
  @override
  _OverAllReportState createState() => _OverAllReportState();
}

class _OverAllReportState extends State<OverAllReport> {
  // final CollectionReference billsCollection =
  //     FirebaseFirestore.instance.collection('Bills');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: primaryColor,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('Overall Report',
            style: TextStyle(fontFamily: 'tabfont', color: white)),
      ),
      body: Column(
        children: [
          Stack(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                  ),
                  color: black,
                ),
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 3.5,
                child: Padding(
                  padding: const EdgeInsets.only(top: 22),
                  child: Lottie.asset(
                    "$lottiePath/bill.json",
                    fit: BoxFit.fitHeight,
                    frameRate: FrameRate(90),
                  ),
                ),
              ), //Container
              //Container
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                  ),
                  color: primaryColor,
                ),
                height: MediaQuery.of(context).size.height / 20,
                width: double.infinity,
              ), //Container
            ], //<Widget>[]
          ),
          // SizedBox(
          //   height: MediaQuery.of(context).size.height / 80,
          // ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('Bills').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: CircularProgressIndicator(
                    color: primaryColor,
                  ));
                }

                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Text('No data available');
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var billData = snapshot.data!.docs[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      BillDetailsScreen(billData: billData)));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Container(
                            height: MediaQuery.of(context).size.height / 6,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: green)),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              10,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              4,
                                          decoration: BoxDecoration(
                                              border: Border.all(color: green),
                                              shape: BoxShape.circle,
                                              color: Colors.green.shade100),
                                          child: Center(
                                            child: Lottie.asset(
                                              "$lottiePath/bill2.json",
                                              fit: BoxFit.fitHeight,
                                              frameRate: FrameRate(90),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              100,
                                        ),
                                        Text(
                                          'Bill-${index + 1}',
                                          style: TextStyle(
                                              fontFamily: 'tabfont',
                                              fontSize: 17),
                                        )
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        RichText(
                                          text: TextSpan(
                                            text: 'User ID: ',
                                            style: TextStyle(
                                                fontFamily: 'fontmain',
                                                color: black,
                                                fontSize: 14),
                                            children: <TextSpan>[
                                              TextSpan(
                                                text: '${billData['userId']}',
                                                style: TextStyle(
                                                  color: black,
                                                  fontFamily:
                                                      'fontmain', // Customize the color
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              120,
                                        ),
                                        Text(
                                          'Tap here to see more information',
                                          style: TextStyle(
                                              color: grey,
                                              fontFamily: 'fontmain'),
                                        )
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color:
                                            Color.fromARGB(255, 129, 191, 202),
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(19.0),
                                          bottomRight: Radius.circular(19.0),
                                        ),
                                      ),
                                      height:
                                          MediaQuery.of(context).size.height /
                                              6,
                                      child: Icon(
                                        Icons.arrow_forward_ios,
                                        color: white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
