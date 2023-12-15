import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pos_admin/constants/colors.dart';
import 'package:pos_admin/sceens/allDepartmentScreen.dart';
import 'package:pos_admin/sceens/allTaxScreen.dart';
import 'package:pos_admin/widgets/cstmTextField.dart';
import 'package:pos_admin/widgets/myTextField.dart';

class AddTaxScreen extends StatefulWidget {
  final String docId;

  const AddTaxScreen({required this.docId, Key? key}) : super(key: key);

  @override
  State<AddTaxScreen> createState() => _AddDepartmentState();
}

class _AddDepartmentState extends State<AddTaxScreen> {
  final TextEditingController TaxNameController = TextEditingController();
  final TextEditingController GstController = TextEditingController();
  final TextEditingController CgstController = TextEditingController();
  final TextEditingController SgstContrller = TextEditingController();
  final TextEditingController IgstController = TextEditingController();
  int selectedRadio = 1;

  void handleRadioValueChange(int? value) {
    if (value != null) {
      setState(() {
        selectedRadio = value;
      });
    }
  }

  Future<void> addDepartment() async {
    // Get a reference to the admin collection
    CollectionReference adminCollection =
        FirebaseFirestore.instance.collection('AllAdmins');

    // Get a reference to the specific admin document
    DocumentReference adminDocument = adminCollection.doc(widget.docId);

    // Add a new department to the subcollection 'departments'
    await adminDocument.collection('tax').add({
      'createdAt': DateTime.now().toString(),
      'name': TaxNameController.text,
      'totalGst': GstController.text,
      'cGst': CgstController.text,
      'sGst': SgstContrller.text,
      'status': selectedRadio == 1 ? 'Active' : 'In-Active',
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'Tax Settings',
          style: TextStyle(
            fontFamily: "tabfont",
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Image.asset(
                '$imagesPath/tax.gif',
                scale: 5,
              ),
              MyTextField(
                controller: TaxNameController,
                hintText: 'Enter tax name here',
                cstmLable: 'Tax Name',
              ),
              MyTextField(
                controller: GstController,
                hintText: 'Enter total GST in % here',
                cstmLable: 'GST In %',
              ),
              MyTextField(
                cstmLable: 'CGST In %',
                controller: CgstController,
                hintText: 'Enter CGST in % here',
              ),
              MyTextField(
                cstmLable: 'SGST In %',
                controller: SgstContrller,
                hintText: 'Enter SGST in % here',
              ),
              MyTextField(
                cstmLable: 'IGST In %',
                controller: IgstController,
                hintText: 'Enter IGST in % here',
              ),
              Column(
                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {
                      handleRadioValueChange(1);
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height / 20,
                      color: Colors.white,
                      width: double.infinity,
                      child: Row(
                        children: [
                          Radio(
                            activeColor: primaryColor,
                            value: 1,
                            groupValue: selectedRadio,
                            onChanged: handleRadioValueChange,
                          ),
                          const Text(
                            'Active',
                            style: TextStyle(
                                fontSize: 17,
                                fontFamily: 'fontmain',
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      handleRadioValueChange(2);
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height / 20,
                      color: Colors.white,
                      width: double.infinity,
                      child: Row(
                        children: [
                          Radio(
                            activeColor: primaryColor,
                            value: 2,
                            groupValue: selectedRadio,
                            onChanged: handleRadioValueChange,
                          ),
                          const Text(
                            'In-Active',
                            style: TextStyle(
                                fontSize: 17,
                                fontFamily: 'fontmain',
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          backgroundColor: primaryColor,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'SUBMIT',
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.white,
                                fontFamily: "tabfont",
                                letterSpacing: 1.3,
                              ),
                            ),
                          ],
                        ),
                        onPressed: () async {
                          // Call the function to add department
                          await addDepartment();
                          Fluttertoast.showToast(
                            backgroundColor: green,
                            msg: 'Tax added successfully',
                            // backgroundColor: Colors.green,
                          );
                        },
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
