import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:msh_checkbox/msh_checkbox.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:pos_admin/constants/colors.dart';
import 'package:pos_admin/sceens/allFoodScreen.dart';
import 'package:pos_admin/screen.dart';
import 'package:pos_admin/widgets/checkBox.dart';
import 'package:pos_admin/widgets/dropDown.dart';
import 'package:pos_admin/widgets/myTextField.dart';
import 'package:pos_admin/widgets/utils.dart';

class AddItemScreen extends StatefulWidget {
  final String uid;
  AddItemScreen({required this.uid, super.key});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

final TextEditingController foodNameController = TextEditingController();
final TextEditingController foodPriceController = TextEditingController();
final TextEditingController foodCodeController = TextEditingController();
final TextEditingController foodStockController = TextEditingController();
final TextEditingController foodDescriptionController = TextEditingController();

class _AddItemScreenState extends State<AddItemScreen> {
  bool isChecked = false;
  bool isLoading = true;
  bool isUploading = false;
  String selectedOption1 = '';
  String selectedOption2 = '';
  String selectedOption3 = '';
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  File? selectedIamge;
  List<String> activeDepartments = [];
  List<String> activeTax = [];
  List<String> activeUnits = [];

  @override
  void initState() {
    super.initState();
    initializeValues();
  }

  void initializeValues() async {
    await fetchActiveDepartments();
    await fetchActiveTax();
    await fetchActiveUnit();

    setState(() {
      selectedOption1 =
          activeDepartments.isNotEmpty ? activeDepartments[0] : '';
      selectedOption2 = activeTax.isNotEmpty ? activeTax[0] : '';
      selectedOption3 = activeUnits.isNotEmpty ? activeUnits[0] : '';
      isLoading = false;
    });

    print('testing Status');
    print(selectedOption1);
    print(selectedOption2);
    print(selectedOption3);
  }

  // Method to fetch active departments
  Future<void> fetchActiveDepartments() async {
    try {
      // Get a reference to the "departments" subcollection
      CollectionReference departmentsCollection = _firestore
          .collection('AllAdmins')
          .doc(widget.uid)
          .collection('departments');

      // Get documents from the "departments" subcollection
      QuerySnapshot querySnapshot = await departmentsCollection.get();

      // Clear the list before adding new names
      activeDepartments.clear();

      // Loop through documents and add names to the list if status is "Active"
      querySnapshot.docs.forEach((doc) {
        var department = doc.data() as Map<String, dynamic>;
        if (department['status'] == 'Active') {
          activeDepartments.add(department['name']);
        }
      });

      // Print the list of active departments (for testing)
      print('Active Departments: $activeDepartments');
    } catch (e) {
      print('Error fetching active departments: $e');
    }
  }

  // Method to fetch active Tax
  Future<void> fetchActiveTax() async {
    try {
      CollectionReference taxCollection =
          _firestore.collection('AllAdmins').doc(widget.uid).collection('tax');

      QuerySnapshot querySnapshot = await taxCollection.get();

      activeTax.clear();

      querySnapshot.docs.forEach((doc) {
        var department = doc.data() as Map<String, dynamic>;
        if (department['status'] == 'Active') {
          activeTax.add(department['name']);
        }
      });

      print('Active Tax: $activeTax');
    } catch (e) {
      print('Error fetching active Tax: $e');
    }
  }

// Method to fetch active units
  Future<void> fetchActiveUnit() async {
    try {
      CollectionReference unitCollection = _firestore
          .collection('AllAdmins')
          .doc(widget.uid)
          .collection('units');
      QuerySnapshot querySnapshot = await unitCollection.get();
      activeUnits.clear();
      querySnapshot.docs.forEach((doc) {
        var department = doc.data() as Map<String, dynamic>;
        if (department['status'] == 'Active') {
          activeUnits.add(department['name']);
        }
      });
      print('Active units: $activeUnits');
    } catch (e) {
      print('Error fetching active units: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Clear the text fields when back button is pressed
        foodNameController.clear();
        foodCodeController.clear();
        foodPriceController.clear();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: const Text(
            'Add Food Items',
            style: TextStyle(
              color: white,
              fontFamily: "tabfont",
            ),
          ),
        ),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                color: primaryColor,
              ))
            : Column(
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
                          padding: const EdgeInsets.only(top: 40),
                          child: Column(
                            children: [
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * .14,
                                width: MediaQuery.of(context).size.width * .6,
                                child: selectedIamge != null
                                    ? Image.file(selectedIamge!)
                                    : Lottie.asset(
                                        "$lottiePath/food2.json",
                                        fit: BoxFit.fitHeight,
                                        frameRate: FrameRate(90),
                                      ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  ElevatedButton(
                                    onPressed: () async {
                                      pickImageFromGallery();
                                    },
                                    child: const Text(
                                      'Gallery',
                                      style: TextStyle(
                                        color: primaryColor,
                                        fontFamily: "tabfont",
                                      ),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      pickImageFromCamera();
                                    },
                                    child: const Text(
                                      'Camera',
                                      style: TextStyle(
                                        color: primaryColor,
                                        fontFamily: "tabfont",
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
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
                  // SizedBox(
                  //   height: MediaQuery.of(context).size.height / 44,
                  // ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 4, right: 4, top: 16),
                        child: Column(children: [
                          MyTextField(
                            controller: foodNameController,
                            hintText: 'Enter item name here',
                            cstmLable: 'Item Name',
                          ),
                          MyTextField(
                            controller: foodCodeController,
                            hintText: 'Enter item code here',
                            cstmLable: 'Item Code',
                            keyboardType: TextInputType.number,
                          ),
                          MyTextField(
                              keyboardType: TextInputType.number,
                              controller: foodPriceController,
                              hintText: 'Enter item price here',
                              cstmLable: "Item Price"),
                          MyTextField(
                              keyboardType: TextInputType.number,
                              controller: foodStockController,
                              hintText: "Enter item stocks here",
                              cstmLable: 'Item Stock'),
                          MyTextField(
                              controller: foodDescriptionController,
                              hintText: 'Enter item description ',
                              cstmLable: 'Item Description'),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Form(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Select Department',
                                    style: TextStyle(
                                        letterSpacing: 1.3,
                                        fontSize: 14,
                                        fontFamily: 'fontmain',
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height /
                                        180,
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * .9,
                                    height:
                                        MediaQuery.of(context).size.height / 16,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: DropdownButtonFormField<String>(
                                      isExpanded:
                                          true, // Set to true to allow the dropdown to take the full width
                                      value: selectedOption1,
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          selectedOption1 = newValue!;
                                        });
                                      },
                                      items: activeDepartments
                                          .map<DropdownMenuItem<String>>(
                                        (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(
                                              value,
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  letterSpacing: 1,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          );
                                        },
                                      ).toList(),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 12,
                                        ),
                                        hintStyle: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          color: Colors.grey.shade500,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  const Text(
                                    'Select Tax',
                                    style: TextStyle(
                                        letterSpacing: 1.3,
                                        fontSize: 14,
                                        fontFamily: 'fontmain',
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height /
                                        180,
                                  ),
                                  Container(
                                    height:
                                        MediaQuery.of(context).size.height / 16,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: DropdownButtonFormField<String>(
                                      isExpanded: true,
                                      value: selectedOption2,
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          selectedOption2 = newValue!;
                                        });
                                      },
                                      items: activeTax
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(
                                            value,
                                            style: TextStyle(
                                                fontSize: 17,
                                                letterSpacing: 1,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        );
                                      }).toList(),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 12),
                                        hintStyle: TextStyle(
                                            fontWeight: FontWeight.w300,
                                            color: Colors.grey.shade500),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  const Text(
                                    'Select Units',
                                    style: TextStyle(
                                        letterSpacing: 1.3,
                                        fontSize: 14,
                                        fontFamily: 'fontmain',
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height /
                                        180,
                                  ),
                                  Container(
                                    height:
                                        MediaQuery.of(context).size.height / 16,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: DropdownButtonFormField<String>(
                                      value: selectedOption3,
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          selectedOption3 = newValue!;
                                        });
                                      },
                                      items: activeUnits
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(
                                            value,
                                            style: TextStyle(
                                                fontSize: 17,
                                                letterSpacing: 1,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        );
                                      }).toList(),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 12),
                                        hintStyle: TextStyle(
                                            fontWeight: FontWeight.w300,
                                            color: Colors.grey.shade500),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isChecked = !isChecked;
                                  print(isChecked);
                                });
                              },
                              child: Container(
                                width: double.infinity,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    MSHCheckbox(
                                      size: 30,
                                      value: isChecked,
                                      colorConfig: MSHColorConfig
                                          .fromCheckedUncheckedDisabled(
                                        checkedColor: primaryColor,
                                      ),
                                      style: MSHCheckboxStyle.stroke,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          isChecked = value ?? false;
                                          print(isChecked);
                                        });
                                      },
                                    ),
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      child: Text(
                                        'Is Hot',
                                        style: TextStyle(
                                          fontSize: 17,
                                          color: black,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'fontmain',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ]),
                      ),
                    ),
                  ),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        final String FoodName = foodNameController.text;
                        final String FoodCode = foodCodeController.text;
                        final String FoodPrice = foodPriceController.text;
                        final String Stocks = foodStockController.text;
                        final String Description =
                            foodDescriptionController.text;
                        final bool IsHot = isChecked;

                        if (isUploading) {
                          return; // If already uploading, do nothing
                        }

                        setState(() {
                          isUploading = true; // Set uploading state to true
                        });

                        createSubcollection(
                          context,
                          FoodName,
                          FoodCode,
                          FoodPrice,
                          Stocks,
                          Description,
                          IsHot,
                          widget.uid,
                        ).then((_) {
                          // After data is uploaded, set uploading state to false
                          setState(() {
                            isUploading = false;
                            isLoading = false;
                          });
                        });
                      },
                      child: Container(
                          height: MediaQuery.of(context).size.height / 19,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: primaryColor,
                          ),
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              isUploading
                                  ? const CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    )
                                  : Icon(
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
                          )),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Future pickImageFromGallery() async {
    final returnImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnImage == null) return;
    setState(() {
      selectedIamge = File(returnImage!.path);
    });
  }

  Future pickImageFromCamera() async {
    final returnImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (returnImage == null) return;
    setState(() {
      selectedIamge = File(returnImage!.path);
    });
  }

  //Uploading Food data on firebase
  Future<void> createSubcollection(
    BuildContext context,
    String FoodName,
    String FoodCode,
    String FoodPrice,
    String FoodStock,
    String foodDescription,
    bool IsHot,
    String phoneNo,
  ) async {
    if (FoodName.isEmpty || FoodCode.isEmpty || FoodPrice.isEmpty) {
      showSnackBar(context, "Please provide all details");
      return;
    }

    try {
      User? user = _auth.currentUser;

      if (user != null) {
        // final String uid = user.uid;
        String imagePath = await uploadImageToStorage(selectedIamge);
        CollectionReference foodCollection = _firestore
            .collection('AllAdmins')
            .doc(widget.uid)
            .collection('foodItems');

        await foodCollection.add({
          'name': FoodName,
          'foodCode': FoodCode,
          'price': FoodPrice,
          'uid': phoneNo,
          'imagePath': imagePath,
          'department': selectedOption1,
          'tax': selectedOption2,
          'stocks': FoodStock,
          'description': foodDescription,
          'createdAt': DateTime.now().toString(),
          'isHot': IsHot,
        });

        print('Subcollection document created successfully.');

        print("testing admin id ${widget.uid}");
        Fluttertoast.showToast(
          msg: 'Item added successfully',
        );
        foodNameController.clear();
        foodCodeController.clear();
        foodPriceController.clear();
        foodDescriptionController.clear();
        foodStockController.clear();
        setState(() {
          isLoading = true;
        });
      } else {
        print('User is not logged in.');
      }
    } catch (e) {
      print('Error creating subcollection document: $e');
    }
  }

  Future<String> uploadImageToStorage(File? image) async {
    try {
      if (image == null) {
        return ''; // Return an empty string if no image is selected
      }

      // Get a reference to the Firebase Storage
      final Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('food_images/${DateTime.now().millisecondsSinceEpoch}');

      // Upload the image to Firebase Storage
      await storageReference.putFile(image);

      // Get the download URL of the uploaded image
      String downloadURL = await storageReference.getDownloadURL();
      print('Image uploaded successfully. Download URL: $downloadURL');

      return downloadURL;
    } catch (e) {
      print('Error uploading image to storage: $e');
      return '';
    }
  }
}
