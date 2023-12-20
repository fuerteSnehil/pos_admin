import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pos_admin/constants/colors.dart';

class AllFoodsScreen extends StatefulWidget {
  final String documentId;

  AllFoodsScreen({required this.documentId});

  @override
  State<AllFoodsScreen> createState() => _AllFoodsScreenState();
}

class _AllFoodsScreenState extends State<AllFoodsScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> _deleteItem(DocumentReference docReference) async {
    try {
      await docReference.delete();

      Fluttertoast.showToast(
        msg: 'Item deleted successfully!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } catch (e) {
      print('Error deleting item: $e');
      Fluttertoast.showToast(
        msg: 'Error deleting item. Please try again!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          'Food Details',
          style: TextStyle(
            fontFamily: "tabfont",
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('AllAdmins')
            .doc(widget.documentId)
            .collection('foodItems')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            var documents = snapshot.data!.docs;
            if (documents.isEmpty) {
              return Text('No data found.');
            }

            return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, index) {
                var data = documents[index].data() as Map<String, dynamic>;
                return FoodItemWidget(
                  imagePath: data['imagePath'] ?? '',
                  name: data['name'] ?? '',
                  foodCode: data['foodCode'] ?? '',
                  price: data['price'] ?? '',
                  department: data['department'] ?? '',
                  tax: data['tax'] ?? '',
                  onDelete: () {
                    _deleteItem(documents[index].reference);
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}

class FoodItemWidget extends StatelessWidget {
  final String imagePath;
  final String name;
  final String foodCode;
  final String price;
  final String department;
  final String tax;
  final VoidCallback onDelete;

  const FoodItemWidget({
    required this.imagePath,
    required this.name,
    required this.foodCode,
    required this.price,
    required this.department,
    required this.onDelete,
    required this.tax,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: MediaQuery.of(context).size.height / 6,
            decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                const BoxShadow(
                  blurRadius: 4.0,
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        bottomLeft: Radius.circular(20.0),
                      ),
                    ),
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
                    // height: MediaQuery.of(context).size.height * .15,
                    // width: MediaQuery.of(context).size.width * .27),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 17.0,
                          fontFamily: "tabfont",
                        ),
                      ),
                      Text(
                        'Code: $foodCode',
                        style: const TextStyle(
                          fontFamily: "fontmain",
                          fontSize: 15.0,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        'Price: $price',
                        style: const TextStyle(
                          fontFamily: "fontmain",
                          fontSize: 15.0,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        'Department: $department',
                        style: const TextStyle(
                          fontFamily: "fontmain",
                          fontSize: 15.0,
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        'Tax: $tax',
                        style: const TextStyle(
                          fontFamily: "fontmain",
                          fontSize: 15.0,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 12,
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20.0),
                        bottomRight: Radius.circular(20.0),
                      ),
                    ),
                    height: MediaQuery.of(context).size.height / 6,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: white,
                        ),
                        onPressed: () {
                          _showDeleteConfirmationDialog(context);
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Function to show a confirmation dialog before deleting
  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Item"),
          content: Text("Are you sure you want to delete this item?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cancel
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                onDelete(); // Call the onDelete function to delete the item
              },
              child: Text("Delete"),
            ),
          ],
        );
      },
    );
  }
}
