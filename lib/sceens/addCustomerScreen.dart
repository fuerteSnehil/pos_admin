import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'dart:io';
import 'package:flutter/material.dart';

import 'package:pos_admin/constants/colors.dart';
import 'package:pos_admin/sceens/allCustomerScreen.dart';
import 'package:pos_admin/widgets/myTextField.dart';

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
          backgroundColor: primaryColor,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            'Add Customers',
            style: TextStyle(
              color: white,
              fontFamily: "tabfont",
            ),
          ),
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
                  height: MediaQuery.of(context).size.height / 4,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Image.asset(
                      "$imagesPath/customer.gif",
                      scale: 1,
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
                  height: MediaQuery.of(context).size.height / 30,
                  width: double.infinity,
                ), //Container
              ], //<Widget>[]
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  color: white,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 4, right: 4, top: 8),
                    child: Column(children: [
                      MyTextField(
                        controller: customerCodeController,
                        hintText: "Enter customer code here",
                        cstmLable: 'Customer Code',
                        keyboardType: TextInputType.number,
                      ),
                      MyTextField(
                          controller: customerNameController,
                          hintText: 'Enter customer name here',
                          cstmLable: 'Customer Name'),
                      MyTextField(
                        controller: customerPhoneController,
                        hintText: 'Enter customer phone No here',
                        cstmLable: 'Phone-No',
                        keyboardType: TextInputType.number,
                      ),
                      MyTextField(
                          keyboardType: TextInputType.emailAddress,
                          controller: customerEmailController,
                          hintText: 'Enter customer e-mail here',
                          cstmLable: 'E-Mail')
                    ]),
                  ),
                ),
              ),
            ),
            Center(
              child: TextButton(
                  onPressed: () {
                    final String CustomerName = customerNameController.text;
                    final String CustomerCode = customerCodeController.text;
                    final String CustomerPhone = customerPhoneController.text;
                    final String CustomerEmail = customerEmailController.text;
                    addCustomer(CustomerName, CustomerPhone, CustomerCode,
                        CustomerEmail);
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height / 19,
                    decoration: BoxDecoration(
                        // border: Border.all(color: Colors.black, width: 2),
                        borderRadius: BorderRadius.circular(30),
                        color: primaryColor),
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          MdiIcons.check,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 50,
                        ),
                        Text(
                          'SUBMIT',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: "tabfont",
                          ),
                        ),
                      ],
                    ),
                  )),
            ),
          ],
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
