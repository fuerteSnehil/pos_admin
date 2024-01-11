import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pos_admin/constants/colors.dart';
import 'package:pos_admin/sceens/allDepartmentScreen.dart';
import 'package:pos_admin/widgets/cstmTextField.dart';

class AddUnitScreen extends StatefulWidget {
  final String docId;

  const AddUnitScreen({required this.docId, Key? key}) : super(key: key);

  @override
  State<AddUnitScreen> createState() => _AddDepartmentState();
}

class _AddDepartmentState extends State<AddUnitScreen> {
  final TextEditingController unitNameController = TextEditingController();
  final TextEditingController remarkController = TextEditingController();
  int selectedRadio = 1;

  void handleRadioValueChange(int? value) {
    if (value != null) {
      setState(() {
        selectedRadio = value;
      });
    }
  }

  Future<void> addUnits() async {
    // Get a reference to the admin collection
    CollectionReference adminCollection =
        FirebaseFirestore.instance.collection('AllAdmins');

    // Get a reference to the specific admin document
    DocumentReference adminDocument = adminCollection.doc(widget.docId);

    // Add a new department to the subcollection 'departments'
    await adminDocument.collection('units').add({
      'createdAt': DateTime.now().toString(),
      'name': unitNameController.text,
      'remark': remarkController.text,
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
          'Add Units',
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
                '$imagesPath/unit.gif',
                scale: 3,
              ),
              CustomTextField(
                controller: unitNameController,
                hintText: 'Enter Unit Name',
              ),
              CustomTextField(
                controller: remarkController,
                hintText: 'Enter Remark',
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {
                      handleRadioValueChange(1);
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * .1,
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
                            style: TextStyle(fontSize: 20),
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
                            style: TextStyle(fontSize: 20),
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
                                letterSpacing: 1.3,
                              ),
                            ),
                          ],
                        ),
                        onPressed: () async {
                          // Call the function to add department
                          await addUnits();
                          Fluttertoast.showToast(
                            msg: 'unit added successfully',
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
