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

  Future<void> _deleteItem(String itemId) async {
    try {
      await FirebaseFirestore.instance
          .collection('AllUsers')
          .doc(widget.documentId)
          .collection('foodItems')
          .doc(itemId)
          .delete();

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
            ));
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            var documents = snapshot.data!.docs;
            if (documents.isEmpty) {
              return Text('No data found.');
            }

            return ListView.builder(
              itemCount: documents.length,
              // separatorBuilder: (BuildContext context, int index) {
              //   return Divider(
              //     indent: 40,
              //     endIndent: 40,
              //   ); // Add a divider between items
              // },
              itemBuilder: (context, index) {
                var data = documents[index].data() as Map<String, dynamic>;
                String test = data['name'] ?? '';
                print("testing data is printing");
                print(test);
                return FoodItemWidget(
                  imagePath: data['imagePath'] ?? '',
                  name: data['name'] ?? '',
                  foodCode: data['foodCode'] ?? '',
                  price: data['price'] ?? '',
                  department: data['department'] ?? '',
                  tax: data['tax'] ?? '',
                  onDelete: () {
                    _deleteItem(documents[index].id);
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: MediaQuery.of(context).size.height * .15,
        decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              const BoxShadow(
                blurRadius: 4.0,
              ),
            ]),
        child: Row(
          children: [
            Container(
                decoration: const BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    bottomLeft: Radius.circular(20.0),
                  ),
                ),
                height: MediaQuery.of(context).size.height * .15,
                width: MediaQuery.of(context).size.width * .28,
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: NetworkImage(imagePath), fit: BoxFit.contain)),
                )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 19.0,
                      fontFamily: "tabfont",
                    ),
                  ),
                  Text(
                    'Code : $foodCode',
                    style: const TextStyle(
                        fontFamily: "fontmain",
                        fontSize: 15.0,
                        color: Colors.black54),
                  ),
                  Text(
                    'Price : $price',
                    style: const TextStyle(
                        fontFamily: "fontmain",
                        fontSize: 15.0,
                        color: Colors.black54),
                  ),
                  Text(
                    'Department : $department',
                    style: const TextStyle(
                        fontFamily: "fontmain",
                        fontSize: 15.0,
                        color: Colors.black54),
                  ),
                  Text(
                    'Tax : $tax',
                    style: const TextStyle(
                        fontFamily: "fontmain",
                        fontSize: 15.0,
                        color: Colors.black54),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
