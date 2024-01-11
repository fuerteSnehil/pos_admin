import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pos_admin/constants/colors.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_network/image_network.dart';
//import 'package:cached_network_image/cached_network_image.dart';
import 'dart:ui' as ui;
//import 'package:flutter_rating_bar/flutter_rating_bar.dart';

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
          .collection('AllAdmins')
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

  Future<void> deletewindowitem(String id) async {
    await FirebaseFirestore.instance
        .collection('AllAdmins')
        .doc(widget.documentId)
        .collection('foodItems')
        .doc(id)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery.of(context).size.width < 600
        ? StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('AllAdmins')
                .doc(widget.documentId)
                .collection('foodItems')
                .orderBy('createdAt', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator(
                  color: primaryColor,
                ));
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                var documents = snapshot.data!.docs;
                if (documents.isEmpty) {
                  return const Text('No data found.');
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
          )
        : Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width -
                    MediaQuery.of(context).size.width / 6,
                height: 55,
                decoration: BoxDecoration(
                  color: Colors.white,

                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.8),
                        spreadRadius: 0.5,
                        blurRadius: 0.5)
                  ],
                  // boxShadow: [
                  //   BoxShadow(color: Colors.grey.withOpacity(0.3), spreadRadius: 1, blurRadius: 1)
                  // ]
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 80),
                          child: Text("All Product's List",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 21)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 41, right: 41, bottom: 2, top: 2),
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('AllAdmins')
                          .doc(widget.documentId)
                          .collection('foodItems')
                          .orderBy('createdAt', descending: true)
                          .snapshots(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasData) {
                          return ResponsiveGridList(
                              horizontalGridSpacing: 46,
                              horizontalGridMargin: 10,
                              verticalGridSpacing: 41,
                              minItemWidth: 300,
                              minItemsPerRow: 1,
                              maxItemsPerRow: 3,
                              listViewBuilderOptions: ListViewBuilderOptions(),
                              children: List.generate(
                                  snapshot.data!.docs.length, (index) {
                                //  final DocumentSnapshot documentSnapshot =
                                //     streamSnapshot.data!.docs[index];
                                final DocumentSnapshot food =
                                    snapshot.data!.docs[index];
                                return Container(
                                  height: 350,
                                  width: 300,
                                  color: Colors.white,
                                  // decoration: BoxDecoration(
                                  //   color: Colors.white,
                                  //   borderRadius: BorderRadius.circular(15),
                                  //   boxShadow: [
                                  //     BoxShadow(
                                  //         color: Colors.grey.withOpacity(0.8),
                                  //         spreadRadius: 0.5,
                                  //         blurRadius: 0.5)
                                  //   ],
                                  // ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 18, right: 15, left: 15),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Stack(
                                          children: [
                                            Container(
                                              height: 250,
                                              //width: 300,
                                              decoration: BoxDecoration(
                                                  color:
                                                      const Color(0XFFd0424e),
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Colors.grey
                                                            .withOpacity(0.8),
                                                        spreadRadius: 0.5,
                                                        blurRadius: 0.5)
                                                  ],
                                                  image: const DecorationImage(
                                                      image: AssetImage('assets/images/food22.jpg'),
                                                      fit: BoxFit.cover)),
                                              // child: ImageNetwork(
                                              //   image: food['imagePath'],
                                              //   imageCache:
                                              //       CachedNetworkImageProvider(
                                              //     food['imagePath'],
                                              //   ),
                                              //   height: 250,
                                              //  width: 300,
                                              //   fitWeb: BoxFitWeb.cover,
                                              //   borderRadius:
                                              //       BorderRadius.circular(15),
                                              //   onLoading:
                                              //       const CircularProgressIndicator(
                                              //           color: Color(0XFFd0424e)),
                                              // ),
                                            ),
                                            Positioned(
                                              top: 1,
                                              right: 1,
                                              child: InkWell(
                                                onTap: () {
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: const Text(
                                                            "Delete Item"),
                                                        content: const Text(
                                                            "Are you sure you want to delete this item?"),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop(); // Cancel
                                                            },
                                                            child: const Text(
                                                                "Cancel"),
                                                          ),
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              deletewindowitem(
                                                                  food.id);
                                                            },
                                                            child: const Text(
                                                                "Delete"),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                },
                                                child: Container(
                                                  height: 40,
                                                  width: 40,
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: Color(0XFFd0424e),
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topRight:
                                                                Radius.circular(
                                                                    15)),
                                                  ),
                                                  child: const Icon(
                                                    Icons.delete,
                                                    size: 32,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              food['name'],
                                              //textAlign: TextAlign.center,
                                              //maxLines: 2,
                                              style: const TextStyle(
                                                // fontFamily: 'fontmain',
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500,
                                                //letterSpacing: 1.2,
                                                fontSize: 16,
                                              ),
                                            ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 3,
                                                      vertical: 2),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(7),
                                                  color: const Color.fromARGB(
                                                      255, 31, 120, 34)),
                                              child: const Row(
                                                children: [
                                                  Text(
                                                    '4.0 ',
                                                    textAlign: TextAlign.center,
                                                    // maxLines: 2,
                                                    style: TextStyle(
                                                      // fontFamily: 'fontmain',
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      //letterSpacing: 1.2,
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                  Icon(
                                                    Icons.star,
                                                    size: 15,
                                                    color: Colors.white,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              food['description'],
                                              //textAlign: TextAlign.center,
                                              //maxLines: 2,
                                              style: const TextStyle(
                                                // fontFamily: 'fontmain',
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w400,
                                                //letterSpacing: 1.2,
                                                fontSize: 15,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                const Text(
                                                  "Rs ",
                                                  //textAlign: TextAlign.center,
                                                  //maxLines: 2,
                                                  style: TextStyle(
                                                    // fontFamily: 'fontmain',
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.w400,
                                                    //letterSpacing: 1.2,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                                Text(
                                                  food['price'],
                                                  //textAlign: TextAlign.center,
                                                  //maxLines: 2,
                                                  style: const TextStyle(
                                                    // fontFamily: 'fontmain',
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.w400,
                                                    //letterSpacing: 1.2,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                                const Text(
                                                  ' for one',
                                                  //textAlign: TextAlign.center,
                                                  //maxLines: 2,
                                                  style: TextStyle(
                                                    // fontFamily: 'fontmain',
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.w400,
                                                    //letterSpacing: 1.2,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              food['foodCode'],
                                              textAlign: TextAlign.end,
                                              //maxLines: 2,
                                              style: TextStyle(
                                                // fontFamily: 'fontmain',
                                                color: Colors.black
                                                    .withOpacity(0.8),
                                                fontWeight: FontWeight.w400,
                                                //letterSpacing: 1.2,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }));
                        }
                        return const Center(child: CircularProgressIndicator());
                      }),
                ),
              ),
            ],
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
                    decoration: const BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        bottomLeft: Radius.circular(20.0),
                      ),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: imagePath,
                      placeholder: (BuildContext context, String url) =>
                          const Center(
                              child: CircularProgressIndicator(
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
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(
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
          title: const Text("Delete Item"),
          content: const Text("Are you sure you want to delete this item?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cancel
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                onDelete(); // Call the onDelete function to delete the item
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }
}
