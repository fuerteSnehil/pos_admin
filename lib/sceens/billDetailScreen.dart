import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pos_admin/constants/colors.dart';

class BillDetailsScreen extends StatefulWidget {
  final QueryDocumentSnapshot<Object?> billData;

  BillDetailsScreen({required this.billData});

  @override
  State<BillDetailsScreen> createState() => _BillDetailsScreenState();
}

class _BillDetailsScreenState extends State<BillDetailsScreen> {
  @override
  void initState() {
    // TODO: implement initState
    fetchCustomer();
    super.initState();
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool isLoading = false;

  Map<String, dynamic> userData = {};

  Future<void> fetchCustomer() async {
    String uid = '${widget.billData['userId']}';
    setState(() {
      isLoading = true;
    });
    try {
      final DocumentSnapshot myData =
          await firestore.collection('AllCustomer').doc(uid).get();
      if (myData.exists) {
        setState(() {
          userData = myData.data() as Map<String, dynamic>;
        });
      } else
        ('Customer not found');
    } catch (e) {
      print('Customer not found ${e}');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var itemsList = widget.billData['items'] as List<dynamic>;

    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: primaryColor,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'Bill Details',
          style: TextStyle(fontFamily: 'tabfont', color: white),
        ),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                                  '₹ ${widget.billData['subTotal']}',
                                  style: const TextStyle(
                                    color: white,
                                    fontFamily: "tabfont",
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                const Text(
                                  'Sub-total',
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
                                  '${userData['email']}',
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
                          Padding(
                            padding: const EdgeInsets.only(top: 40),
                            child: Lottie.asset(
                              "$lottiePath/user.json",
                              fit: BoxFit.fitHeight,
                              frameRate: FrameRate(90),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20, top: 50),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Customer Details',
                                  style: const TextStyle(
                                    fontSize: 17,
                                    color: white,
                                    fontFamily: "tabfont",
                                  ),
                                ),
                                Text(
                                  'Name :${userData['name']}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: white,
                                    fontFamily: "fontmain",
                                  ),
                                ),
                                Text(
                                  'Customer Code :${userData['customerCode']}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: white,
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
                SizedBox(
                  height: MediaQuery.of(context).size.height / 30,
                ),
                // Text('User ID: ${widget.billData['userId']}'),
                // Text('Subtotal: ${widget.billData['subTotal']}'),
                Column(
                  children: [
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: [
                                Expanded(
                                    flex: 3,
                                    child: Text(
                                      'Item Name',
                                      style: TextStyle(
                                          fontFamily: 'tabfont', fontSize: 17),
                                    )),
                                Expanded(
                                    flex: 2,
                                    child: Text(
                                      'Quantity',
                                      style: TextStyle(
                                          fontFamily: 'tabfont', fontSize: 17),
                                    )),
                                Expanded(
                                    child: Text(
                                  'Price',
                                  style: TextStyle(
                                      fontFamily: 'tabfont', fontSize: 17),
                                ))
                              ],
                            ),
                            ...itemsList.map<Widget>((item) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Expanded(
                                          flex: 3,
                                          child: Text(
                                            '${item['name']}',
                                            style: TextStyle(
                                                fontFamily: 'fontmain',
                                                fontSize: 16),
                                          )),
                                      Expanded(
                                          flex: 2,
                                          child: Text(
                                            '${item['quantity']}',
                                            style: TextStyle(
                                                fontFamily: 'fontmain',
                                                fontSize: 16),
                                          )),
                                      Expanded(
                                          child: Text(
                                        '${item['price']}',
                                        style: TextStyle(
                                            fontFamily: 'fontmain',
                                            fontSize: 16),
                                      ))
                                    ],
                                  )
                                  // Text(
                                  //     '${item['name']}  |  ${item['quantity']}  |  ${item['price']}'),
                                  // You can add more details if needed
                                ],
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
