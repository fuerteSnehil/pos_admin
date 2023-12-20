import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:pos_admin/constants/colors.dart';
import 'package:pos_admin/sceens/allDepartmentScreen.dart';
import 'package:pos_admin/widgets/cstmTextField.dart';
import 'package:pos_admin/widgets/myTextField.dart';

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
    try {
      // Get a reference to the admin collection
      CollectionReference adminCollection =
          FirebaseFirestore.instance.collection('AllAdmins');

      // Get a reference to the specific admin document
      DocumentReference adminDocument = adminCollection.doc(widget.docId);

      // Upload the image to Firebase Storage and get the download URL
      String imageUrl = await uploadImageToStorage(selectedIamge);

      // Add a new department to the subcollection 'departments' with the image URL
      await adminDocument.collection('departments').add({
        'createdAt': DateTime.now().toString(),
        'name': departmentNameController.text,
        'status': selectedRadio == 1 ? 'Active' : 'In-Active',
        'adminUid': widget.docId,
        'imageUrl': imageUrl, // Add the image URL to the department data
      });

      // Navigate to the department list screen after adding the department
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DepartmentListScreen(docId: widget.docId),
        ),
      );
    } catch (e) {
      // Handle errors here
      print('Error adding department: $e');
    }
  }

  File? selectedIamge;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'Add Department',
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
                height: MediaQuery.of(context).size.height / 3.5,
                child: Padding(
                  padding: const EdgeInsets.only(top: 60),
                  child: Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * .14,
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
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                height: MediaQuery.of(context).size.height / 20,
                width: double.infinity,
              ), //Container
            ], //<Widget>[]
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 44,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  MyTextField(
                    cstmLable: "Department Name",
                    controller: departmentNameController,
                    hintText: 'Enter department name here',
                  ),
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
                  )
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
                          builder: (context) =>
                              DepartmentListScreen(docId: widget.docId)));
                },
              ),
            ),
          )
        ],
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

  Future<String> uploadImageToStorage(File? image) async {
    try {
      if (image == null) {
        return ''; // Return an empty string if no image is selected
      }

      // Get a reference to the Firebase Storage
      final Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('department_images/${DateTime.now().millisecondsSinceEpoch}');

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
