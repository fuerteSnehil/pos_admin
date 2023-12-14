import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'dart:io';
import 'package:flutter/material.dart';

import 'package:pos_admin/constants/colors.dart';
import 'package:pos_admin/sceens/allCustomerScreen.dart';

class AddCustomerScreen extends StatefulWidget {
  final String uid;
  AddCustomerScreen({required this.uid, super.key});

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
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            'Add Customers',
            style: TextStyle(
              fontFamily: "tabfont",
            ),
          ),
        ),
        body: SingleChildScrollView(
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
                  padding: const EdgeInsets.only(left: 8, right: 8, bottom: 1),
                  child: TextField(
                    maxLength: 5,
                    keyboardType: TextInputType.phone,
                    style: TextStyle(
                        fontSize: 17,
                        color: primaryColor,
                        fontWeight: FontWeight.bold),
                    controller: customerCodeController,
                    cursorColor: primaryColor,
                    decoration: InputDecoration(
                      hintText: 'Customer Code',
                      hintStyle: TextStyle(fontWeight: FontWeight.w400),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: const BorderSide(color: Colors.black38),
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
                  padding: const EdgeInsets.only(left: 8, right: 8, bottom: 6),
                  child: TextField(
                    style: TextStyle(
                        fontSize: 17,
                        color: primaryColor,
                        fontWeight: FontWeight.bold),
                    controller: customerNameController,
                    cursorColor: primaryColor,
                    decoration: InputDecoration(
                      hintText: 'Customer Name',
                      hintStyle: TextStyle(fontWeight: FontWeight.w400),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: const BorderSide(color: Colors.black38),
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
                    style: TextStyle(
                        fontSize: 17,
                        color: primaryColor,
                        fontWeight: FontWeight.bold),
                    controller: customerPhoneController,
                    cursorColor: primaryColor,
                    decoration: InputDecoration(
                      hintText: 'Mobile No',
                      hintStyle: TextStyle(fontWeight: FontWeight.w400),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: const BorderSide(color: Colors.black38),
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
                  padding: const EdgeInsets.only(left: 8, right: 8, bottom: 10),
                  child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(
                        fontSize: 17,
                        color: primaryColor,
                        fontWeight: FontWeight.bold),
                    controller: customerEmailController,
                    cursorColor: primaryColor,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      hintStyle: TextStyle(fontWeight: FontWeight.w400),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: const BorderSide(color: Colors.black38),
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
                        final String CustomerName = customerNameController.text;
                        final String CustomerCode = customerCodeController.text;
                        final String CustomerPhone =
                            customerPhoneController.text;
                        final String CustomerEmail =
                            customerEmailController.text;
                        addCustomer(CustomerName, CustomerPhone, CustomerCode,
                            CustomerEmail);
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
                          title: Center(
                            child: const Text(
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
        ),
      ),
    );
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
        final DocumentReference vendorDoc = vendorsCollection.doc('+91${phoneNumber}');

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

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AllCustomerScreen(
                      adminUid: widget.uid,
                    )));
        print('Customer added successfully');
      } catch (e) {
        print('Error adding vendor: $e');
      }
    } else {
      print('Admin user not authenticated');
    }
  }
}
