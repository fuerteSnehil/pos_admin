import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pos_admin/constants/colors.dart';
import 'package:pos_admin/sceens/allDepartmentScreen.dart';
import 'package:pos_admin/widgets/cstmTextField.dart';

class AddDepartmentScreen extends StatefulWidget {
  final String docId;

  const AddDepartmentScreen({required this.docId, Key? key}) : super(key: key);

  @override
  State<AddDepartmentScreen> createState() => _AddDepartmentState();
}

class _AddDepartmentState extends State<AddDepartmentScreen> {
  final TextEditingController departmentNameController =
      TextEditingController();
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
    await adminDocument.collection('departments').add({
      'createdAt': DateTime.now().toString(),
      'name': departmentNameController.text,
      'status': selectedRadio == 1 ? 'Active' : 'In-Active',
      'adminUid':widget.docId,
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
          'Add Department',
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
                '$imagesPath/department.gif',
                scale: 1.3,
              ),
              CustomTextField(
                controller: departmentNameController,
                hintText: 'Enter Department Name',
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
                          await addDepartment();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DepartmentListScreen(
                                      docId: widget.docId)));
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
