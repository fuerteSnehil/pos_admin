import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pos_admin/constants/colors.dart';
import 'package:pos_admin/sceens/addCustomerScreen.dart';
import 'package:pos_admin/sceens/allDepartmentScreen.dart';
import 'package:pos_admin/sceens/allTaxScreen.dart';
import 'package:pos_admin/widgets/cstmTextField.dart';
import 'package:pos_admin/widgets/utils.dart';

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
    return MediaQuery.of(context).size.width < 600
        ? SingleChildScrollView(
            child: Container(
              color: white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Image.asset(
                    '$imagesPath/tax.gif',
                    scale: 5,
                  ),
                  CustomTextField(
                    controller: TaxNameController,
                    hintText: 'Tax Name',
                  ),
                  CustomTextField(
                    controller: GstController,
                    hintText: 'Total GST in %',
                  ),
                  CustomTextField(
                    controller: CgstController,
                    hintText: 'CGST in %',
                  ),
                  CustomTextField(
                    controller: SgstContrller,
                    hintText: 'SGST in %',
                  ),
                  CustomTextField(
                    controller: IgstController,
                    hintText: 'IGST in %',
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
                            child: const Row(
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
          )
        : ListView(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width -
                    MediaQuery.of(context).size.width / 6,
                height: 55,
                //color: Colors.red,
                child: const Center(
                  child: Text(
                    'Add Tax here',
                    style: TextStyle(
                        fontFamily: 'tabfont',
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 23),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    color: Color(0XFFeeeeee),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 5,
                            ),
                            Container(
                                height: 200,
                                width: 350,
                                // decoration: BoxDecoration(
                                //     color: Colors.white,
                                //     border: Border.all(color: Colors.blue)),
                                child: Image.asset(
                                  '$imagesPath/tax.gif',
                                  fit: BoxFit.contain,
                                )),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 41),
                          child: Row(
                            children: [
                              info("Tax Name", "Enter tax name here", context,
                                  TaxNameController),
                              SizedBox(
                                width: 19,
                              ),
                              info("Total GST in %", "enter gst %age here",
                                  context, GstController),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 41),
                          child: Row(
                            children: [
                              info("Total CGST in %", "enter cgst %age here",
                                  context, CgstController),
                              SizedBox(
                                width: 19,
                              ),
                              info("Total SGST in %", "enter sgst %age here",
                                  context, SgstContrller),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 41),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              info("Total IGST in %", "enter igst %age here",
                                  context, IgstController),
                              SizedBox(
                                width: 19,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width: 100,
                                  child: GestureDetector(
                                    onTap: () {
                                      handleRadioValueChange(1);
                                    },
                                    child: Row(
                                      children: [
                                        Radio(
                                          activeColor: Color(0XFFac3749),
                                          value: 1,
                                          groupValue: selectedRadio,
                                          onChanged: handleRadioValueChange,
                                        ),
                                        const Text(
                                          'Active',
                                          style: TextStyle(
                                              fontSize: 17,
                                              fontFamily: 'fontmain',
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 19,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width: 150,
                                  child: GestureDetector(
                                    onTap: () {
                                      handleRadioValueChange(2);
                                    },
                                    child: Row(
                                      children: [
                                        Radio(
                                          activeColor: Color(0XFFac3749),
                                          value: 2,
                                          groupValue: selectedRadio,
                                          onChanged: handleRadioValueChange,
                                        ),
                                        const Text(
                                          'In-Active',
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'fontmain',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 25),
                              child: Container(
                                height: 50,
                                width: MediaQuery.of(context).size.width / 3.5,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Color(0XFFac3749)),
                                child: MaterialButton(
                                  onPressed: () {
                                    if (TaxNameController.text.isNotEmpty &&
                                        GstController.text.isNotEmpty &&
                                        CgstController.text.isNotEmpty &&
                                        SgstContrller.text.isNotEmpty &&
                                        IgstController.text.isNotEmpty) {
                                      addDepartment();
                                      Fluttertoast.showToast(
                                        msg: 'Tax added successfully',
                                        // backgroundColor: Colors.green,
                                      );
                                    } else {
                                      showSnackBar(context,
                                          'Please,Fill All the fields');
                                    }
                                  },
                                  height: 38,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(0)),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 0, vertical: 8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Submit Information',
                                          style: TextStyle(
                                              fontFamily: 'tabfont',
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          );
  }
}
