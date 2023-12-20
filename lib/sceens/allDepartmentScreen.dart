import 'package:cached_network_image/cached_network_image.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pos_admin/constants/colors.dart';

class DepartmentListScreen extends StatefulWidget {
  final String docId;

  const DepartmentListScreen({required this.docId, Key? key}) : super(key: key);

  @override
  State<DepartmentListScreen> createState() => _DepartmentListScreenState();
}

// Function to delete a department from Firebase
Future<void> _deleteDepartment(DocumentReference departmentReference) async {
  try {
    await departmentReference.delete();
  } catch (e) {
    // Handle errors here
    print('Error deleting department: $e');
  }
}

class _DepartmentListScreenState extends State<DepartmentListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          'Department List',
          style: TextStyle(
            fontFamily: "tabfont",
          ),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('AllAdmins')
            .doc(widget.docId)
            .collection('departments')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No departments added yet.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var department = snapshot.data!.docs[index];
                return DepartmentListItem(
                  name: department['name'],
                  status: department['status'],
                  imagePath: department['imageUrl'],
                  onDelete: () => _deleteDepartment(department.reference),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class DepartmentListItem extends StatelessWidget {
  final String name;
  final String status;
  final String imagePath;
  final VoidCallback onDelete;

  const DepartmentListItem(
      {required this.name,
      required this.status,
      required this.imagePath,
      required this.onDelete,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              const BoxShadow(
                blurRadius: 4.0,
              ),
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 2,
              child: Container(
                child: CachedNetworkImage(
                  imageUrl: imagePath,
                  placeholder: (BuildContext context, String url) => Center(
                      child: const CircularProgressIndicator(
                    color: primaryColor,
                  )),
                  errorWidget:
                      (BuildContext context, String url, dynamic error) =>
                          const Icon(Icons.error),
                ),
                decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    bottomLeft: Radius.circular(20.0),
                  ),
                ),
                height: MediaQuery.of(context).size.height * .10,
                width: MediaQuery.of(context).size.width * .28,
                padding: const EdgeInsets.all(8.0),
              ),
            ),
            // SizedBox(width: 16.0),
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 17,
                      fontFamily: "tabfont",
                    ),
                  ),
                  Text(
                    status,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 9,
            ),
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20.0),
                    bottomRight: Radius.circular(20.0),
                  ),
                ),
                height: MediaQuery.of(context).size.height * .10,
                width: MediaQuery.of(context).size.width * .28,
                child: IconButton(
                    onPressed: () => _showDeleteConfirmationDialog(context),
                    icon: Icon(
                      CommunityMaterialIcons.delete,
                      color: white,
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to show a confirmation dialog before deleting
  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Department"),
          content: Text("Are you sure you want to delete this department?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Cancel
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                onDelete(); // Call the onDelete function to delete the department
              },
              child: Text("Delete"),
            ),
          ],
        );
      },
    );
  }
}
