import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pos_admin/constants/colors.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';

class TaxListScreen extends StatefulWidget {
  final String docId;

  const TaxListScreen({required this.docId, Key? key}) : super(key: key);

  @override
  State<TaxListScreen> createState() => _DepartmentListScreenState();
}

class _DepartmentListScreenState extends State<TaxListScreen> {
  @override
  Widget build(BuildContext context) {
    return MediaQuery.of(context).size.width < 600
        ? StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('AllAdmins')
                .doc(widget.docId)
                .collection('tax')
                .orderBy('createdAt', descending: true)
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('No departments added yet.'));
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var tax = snapshot.data!.docs[index];
                    return DepartmentListItem(
                      name: tax['name'],
                      status: tax['status'],
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
                          padding: EdgeInsets.only(left: 40),
                          child: Text("All Tax's List",
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
                  padding: const EdgeInsets.only(left: 41),
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('AllAdmins')
                          .doc(widget.docId)
                          .collection('tax')
                          .orderBy('createdAt', descending: true)
                          .snapshots(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasData) {
                          return ResponsiveGridList(
                            horizontalGridSpacing: 6,
                            horizontalGridMargin: 0,
                            minItemWidth: 270,
                            minItemsPerRow: 1,
                            maxItemsPerRow: 4,
                            listViewBuilderOptions: ListViewBuilderOptions(),
                            children: List.generate(snapshot.data!.docs.length,
                                (index) {
                              var tax = snapshot.data!.docs[index];

                              if (snapshot.hasData) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 21),
                                  child: Stack(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 2, horizontal: 1),
                                        child: Container(
                                          height: 250,
                                          decoration: const BoxDecoration(
                                            //border: Border.all(color: primaryColor),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(11)),
                                            // color: Colors.white,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    height: 180,
                                                    width: 300,
                                                    decoration: BoxDecoration(
                                                      //color: primaryColor.withOpacity(0.2),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      image:
                                                          const DecorationImage(
                                                              image:
                                                                  NetworkImage(
                                                                'https://premiatnc.com/vn/wp-content/uploads/2022/08/income-tax-in-Vietnam-for-foreigners-.jpeg',
                                                              ),
                                                              fit:
                                                                  BoxFit.cover),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        tax['name'],
                                                        textAlign:
                                                            TextAlign.start,
                                                        maxLines: 2,
                                                        style: const TextStyle(
                                                          // fontFamily: 'fontmain',
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          //letterSpacing: 1.2,
                                                          fontSize: 15,
                                                        ),
                                                      ),
                                                      Container(
                                                        padding:
                                                            EdgeInsets.all(4),
                                                        decoration: BoxDecoration(
                                                            color: const Color
                                                                .fromARGB(255,
                                                                28, 113, 31),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        6)),
                                                        child: Text(
                                                          tax['status'],
                                                          textAlign:
                                                              TextAlign.start,
                                                          // maxLines: 2,
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            //letterSpacing: 1.2,
                                                            fontSize: 13,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ]),
                                          ),
                                        ),
                                      ),
                                    ],
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
            ],
          );
  }
}

class DepartmentListItem extends StatelessWidget {
  final String name;
  final String status;

  const DepartmentListItem({required this.name, required this.status, Key? key})
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
          children: [
            Container(
              decoration: const BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  bottomLeft: Radius.circular(20.0),
                ),
              ),
              height: MediaQuery.of(context).size.height * .1,
              width: MediaQuery.of(context).size.width * .28,
              padding: const EdgeInsets.all(8.0),
              child: const CircleAvatar(
                backgroundColor: Colors.white,
                radius: 20.0,
                child: Icon(
                  Icons.currency_exchange,
                  size: 30,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(width: 16.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
          ],
        ),
      ),
    );
  }
}
