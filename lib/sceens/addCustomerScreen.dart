import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'dart:io';
import 'package:flutter/material.dart';

import 'package:pos_admin/constants/colors.dart';
import 'package:pos_admin/sceens/allCustomerScreen.dart';
import 'package:pos_admin/widgets/utils.dart';

class AddCustomerScreen extends StatefulWidget {
  final String uid;
  const AddCustomerScreen({required this.uid, super.key});

  @override
  State<AddCustomerScreen> createState() => _AddItemScreenState();
}

final TextEditingController customerNameController = TextEditingController();
final TextEditingController customerCodeController = TextEditingController();
final TextEditingController customerPhoneController = TextEditingController();
final TextEditingController customerEmailController = TextEditingController();

class _AddItemScreenState extends State<AddCustomerScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  File? selectedIamge;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          // Clear the text fields when back button is pressed
          customerNameController.clear();
          customerCodeController.clear();
          customerPhoneController.clear();
          customerEmailController.clear();
          return true; // Allow the screen to be popped
        },
        child: MediaQuery.of(context).size.width < 600
            ? SingleChildScrollView(
                child: Container(
                  color: white,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 4, right: 4),
                    child: Column(children: [
                      Image.asset(
                        "$imagesPath/customer.gif",
                        scale: 2,
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 8, right: 8, bottom: 1),
                        child: TextField(
                          maxLength: 5,
                          keyboardType: TextInputType.phone,
                          style: const TextStyle(
                              fontSize: 17,
                              color: primaryColor,
                              fontWeight: FontWeight.bold),
                          controller: customerCodeController,
                          cursorColor: primaryColor,
                          decoration: InputDecoration(
                            hintText: 'Customer Code',
                            hintStyle:
                                const TextStyle(fontWeight: FontWeight.w400),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide:
                                  const BorderSide(color: Colors.black38),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: const BorderSide(color: primaryColor),
                            ),
                            focusColor: primaryColor,
                            hoverColor: primaryColor,
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 8, right: 8, bottom: 6),
                        child: TextField(
                          style: const TextStyle(
                              fontSize: 17,
                              color: primaryColor,
                              fontWeight: FontWeight.bold),
                          controller: customerNameController,
                          cursorColor: primaryColor,
                          decoration: InputDecoration(
                            hintText: 'Customer Name',
                            hintStyle:
                                const TextStyle(fontWeight: FontWeight.w400),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide:
                                  const BorderSide(color: Colors.black38),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: const BorderSide(color: primaryColor),
                            ),
                            focusColor: primaryColor,
                            hoverColor: primaryColor,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 8, right: 8, top: 15, bottom: 1),
                        child: TextField(
                          maxLength: 10,
                          keyboardType: TextInputType.phone,
                          style: const TextStyle(
                              fontSize: 17,
                              color: primaryColor,
                              fontWeight: FontWeight.bold),
                          controller: customerPhoneController,
                          cursorColor: primaryColor,
                          decoration: InputDecoration(
                            hintText: 'Mobile No',
                            hintStyle:
                                const TextStyle(fontWeight: FontWeight.w400),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide:
                                  const BorderSide(color: Colors.black38),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: const BorderSide(color: primaryColor),
                            ),
                            focusColor: primaryColor,
                            hoverColor: primaryColor,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 8, right: 8, bottom: 10),
                        child: TextField(
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(
                              fontSize: 17,
                              color: primaryColor,
                              fontWeight: FontWeight.bold),
                          controller: customerEmailController,
                          cursorColor: primaryColor,
                          decoration: InputDecoration(
                            hintText: 'Email',
                            hintStyle:
                                const TextStyle(fontWeight: FontWeight.w400),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide:
                                  const BorderSide(color: Colors.black38),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: const BorderSide(color: primaryColor),
                            ),
                            focusColor: primaryColor,
                            hoverColor: primaryColor,
                          ),
                        ),
                      ),
                      Center(
                        child: TextButton(
                            onPressed: () {
                              final String CustomerName =
                                  customerNameController.text;
                              final String CustomerCode =
                                  customerCodeController.text;
                              final String CustomerPhone =
                                  customerPhoneController.text;
                              final String CustomerEmail =
                                  customerEmailController.text;
                              addCustomer(CustomerName, CustomerPhone,
                                  CustomerCode, CustomerEmail);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  // border: Border.all(color: Colors.black, width: 2),
                                  borderRadius: BorderRadius.circular(30),
                                  color: primaryColor),
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: ListTile(
                                leading: Icon(
                                  MdiIcons.check,
                                  color: Colors.white,
                                ),
                                title: const Center(
                                  child: Text(
                                    'Continue',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "tabfont",
                                    ),
                                  ),
                                ),
                              ),
                            )),
                      ),
                    ]),
                  ),
                ),
              )
            : ListView(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width -
                        MediaQuery.of(context).size.width / 6,
                    height: 55,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      // boxShadow: [
                      //   BoxShadow(
                      //       color: Colors.grey.withOpacity(0.8),
                      //       spreadRadius: 0.5,
                      //       blurRadius: 0.5)
                      // ],
                    ),
                    child: const Center(
                      child: Text('Add Customer Details here',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 23)),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height - 120,
                        width: MediaQuery.of(context).size.width / 3.1,
                        color: Colors.grey.withOpacity(0.2),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            info("Customer code", "Enter code here", context,
                                customerCodeController),
                            info("Customer name", "enter customer name here",
                                context, customerNameController),
                            info("Mobile number", "Enter mobile number",
                                context, customerPhoneController),
                            info("Email", "enter email here", context,
                                customerEmailController),
                            Container(
                              height: 51,
                              width: MediaQuery.of(context).size.width / 3.5,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: const Color(0XFFac3749)),
                              child: MaterialButton(
                                onPressed: () {
                                  final String CustomerName =
                                      customerNameController.text;
                                  final String CustomerCode =
                                      customerCodeController.text;
                                  final String CustomerPhone =
                                      customerPhoneController.text;
                                  final String CustomerEmail =
                                      customerEmailController.text;
                                  if (CustomerName.isNotEmpty &&
                                      CustomerEmail.isNotEmpty &&
                                      CustomerCode.isNotEmpty &&
                                      CustomerPhone.isNotEmpty) {
                                    addCustomer(CustomerName, CustomerPhone,
                                        CustomerCode, CustomerEmail);
                                  } else {
                                    showSnackBar(
                                        context, "Please provide all details");
                                  }
                                },
                                height: 50,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6)),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Add customer',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ));
  }

  Future<void> addCustomer(
      String name, String phoneNumber, String code, String email) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? adminUser = auth.currentUser;

    if (adminUser != null) {
      // final adminId = adminUser.uid;
      final CollectionReference adminsCollection =
          FirebaseFirestore.instance.collection('AllAdmins');

      try {
        // Create a document with the admin's phone number as its ID within the AllAdmin collection
        final DocumentReference adminDoc = adminsCollection.doc(widget.uid);

        final CollectionReference vendorsCollection =
            FirebaseFirestore.instance.collection('AllCustomer');

        // Create a document with the vendor's phone number as its ID within the vendors collection
        final DocumentReference vendorDoc =
            vendorsCollection.doc('+91${phoneNumber}');

        final vendorData = {
          'createdAt': DateTime.now().toString(),
          'name': name,
          'phoneNumber': '+91${phoneNumber}',
          'adminUid': widget.uid,
          'customerCode': code,
          'email': email,
        };

        // Set the data for the vendor document within the vendors collection
        await vendorDoc.set(vendorData);

        // Now, the vendor data is stored in both the Vendor collection and the subcollection
        final vendorId = vendorDoc.id;

        // Store the vendor data in the subcollection within the admin's document as well
        final vendorSubcollection = adminDoc.collection('customer');
        await vendorSubcollection.doc(vendorId).set(vendorData);

        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => AllCustomerScreen(
        //               adminUid: widget.uid,
        //             )));
        print('Customer added successfully');
      } catch (e) {
        print('Error adding vendor: $e');
      }
    } else {
      print('Admin user not authenticated');
    }
  }
}

info(String name, String name2, BuildContext context, control) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(name,
            style: const TextStyle(
                fontFamily: 'fontmain',
                fontWeight: FontWeight.w700,
                fontSize: 17.0,
                color: Colors.black)),
        const SizedBox(
          height: 11,
        ),
        Container(
          height: 50,
          width: MediaQuery.of(context).size.width / 3.5,
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.6),
                    spreadRadius: 0.4,
                    blurRadius: 0.4)
              ],
              borderRadius: BorderRadius.circular(6)),
          child: Padding(
            padding: const EdgeInsets.only(left: 11),
            child: TextField(
              controller: control,
              decoration: const InputDecoration(border: InputBorder.none),
            ),
          ),
        ),
      ],
    ),
  );
}
