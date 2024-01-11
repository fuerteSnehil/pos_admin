import 'package:cached_network_image/cached_network_image.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_network/image_network.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pos_admin/constants/colors.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';

class DepartmentListScreen extends StatefulWidget {
  final String docId;

  const DepartmentListScreen({required this.docId, Key? key}) : super(key: key);

  @override
  State<DepartmentListScreen> createState() => _DepartmentListScreenState();
}

class _DepartmentListScreenState extends State<DepartmentListScreen> {
  Future<void> _deleteDepartment(DocumentReference departmentReference) async {
    try {
      await departmentReference.delete();
    } catch (e) {
      // Handle errors here
      print('Error deleting department: $e');
    }
  }

  Future<void> deletedatawindow(String id) async {
    FirebaseFirestore.instance
        .collection('AllAdmins')
        .doc(widget.docId)
        .collection('departments')
        .doc(id)
        .delete();
  }

  String selectedcategory = '';

  @override
  Widget build(BuildContext context) {
    return MediaQuery.of(context).size.width < 600
        ? StreamBuilder(
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
          )
        : ListView(
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
                          padding: EdgeInsets.only(left: 40),
                          child: Text("Category's List",
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
              SizedBox(
                height: 15,
              ),
              Container(
                height: 300,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                  ),
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('AllAdmins')
                          .doc(widget.docId)
                          .collection('departments')
                          .orderBy('createdAt', descending: true)
                          .snapshots(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasData) {
                          return ResponsiveGridList(
                            horizontalGridSpacing: 6,
                            horizontalGridMargin: 0,
                            minItemWidth: 300,
                            minItemsPerRow: 2,
                            maxItemsPerRow: 7,
                            listViewBuilderOptions: ListViewBuilderOptions(
                                scrollDirection: Axis.horizontal),
                            children: List.generate(snapshot.data!.docs.length,
                                (index) {
                              var department = snapshot.data!.docs[index];
                              if (snapshot.hasData) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 21),
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedcategory = department['name'];
                                      });
                                    },
                                    child: Column(children: [
                                      Stack(
                                        children: [
                                          ImageNetwork(
                                            image: department['imageUrl'],
                                            imageCache:
                                                CachedNetworkImageProvider(
                                              department['imageUrl'],
                                            ),
                                            height: 200,
                                            width: 200,
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            fitWeb: BoxFitWeb.cover,
                                            onLoading: SizedBox(),
                                            onTap: () {
                                              setState(() {
                                                selectedcategory =
                                                    department['name'];
                                              });
                                            },
                                          ),
                                          Positioned(
                                            top: 1,
                                            right: 40,
                                            child: InkWell(
                                              onTap: () {
                                                _showDeleteConfirmationDialog(
                                                    context, department.id);
                                              },
                                              child: Container(
                                                height: 40,
                                                width: 40,
                                                decoration: BoxDecoration(
                                                  color: const Color(0XFFd0424e),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
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
                                      const SizedBox(
                                        height: 25,
                                      ),
                                      Text(
                                        department['name'],
                                        //textAlign: TextAlign.start,
                                        // maxLines: 2,
                                        style: const TextStyle(
                                          // fontFamily: 'fontmain',
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                          //letterSpacing: 1.2,
                                          fontSize: 19,
                                        ),
                                      ),
                                    ]),
                                  ),
                                );
                              } else {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                            }),
                          );
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      }),
                ),
              ),
              Container(
                height: 350,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 41, right: 41, bottom: 2, top: 2),
                  child: StreamBuilder(
                      stream: selectedcategory.isEmpty
                          ? FirebaseFirestore.instance
                              .collection('AllAdmins')
                              .doc(widget.docId)
                              .collection('foodItems')
                              .snapshots()
                          : FirebaseFirestore.instance
                              .collection('AllAdmins')
                              .doc(widget.docId)
                              .collection('foodItems')
                              .where('department', isEqualTo: selectedcategory)
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
                              listViewBuilderOptions: ListViewBuilderOptions(
                                  scrollDirection: Axis.horizontal),
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
                                        Container(
                                          height: 250,
                                          //width: 300,
                                          decoration: BoxDecoration(
                                              color: const Color(0XFFd0424e),
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
                                                  image: NetworkImage(
                                                      'https://img.lovepik.com/photo/50077/4812.jpg_wh860.jpg'),
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

  void _showDeleteConfirmationDialog(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Department"),
          content:
              const Text("Are you sure you want to delete this department?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Cancel
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                deletedatawindow(id); // Close the dialog
                //onDelete(); // Call the onDelete function to delete the department
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
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
                  placeholder: (BuildContext context, String url) =>
                      const Center(
                          child: CircularProgressIndicator(
                    color: primaryColor,
                  )),
                  errorWidget:
                      (BuildContext context, String url, dynamic error) =>
                          const Icon(Icons.error),
                ),
                decoration: const BoxDecoration(
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
                    style: const TextStyle(
                      fontSize: 17,
                      fontFamily: "tabfont",
                    ),
                  ),
                  Text(
                    status,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
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
                decoration: const BoxDecoration(
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
                    icon: const Icon(
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
          title: const Text("Delete Department"),
          content:
              const Text("Are you sure you want to delete this department?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Cancel
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                onDelete(); // Call the onDelete function to delete the department
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }
}
