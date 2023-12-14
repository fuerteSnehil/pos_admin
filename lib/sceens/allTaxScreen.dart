import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pos_admin/constants/colors.dart';

class TaxListScreen extends StatefulWidget {
  final String docId;

  const TaxListScreen({required this.docId, Key? key}) : super(key: key);

  @override
  State<TaxListScreen> createState() => _DepartmentListScreenState();
}

class _DepartmentListScreenState extends State<TaxListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          'Tax List',
          style: TextStyle(
            fontFamily: "tabfont",
          ),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('AllAdmins')
            .doc(widget.docId)
            .collection('tax')
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
                var tax = snapshot.data!.docs[index];
                return DepartmentListItem(
                  name: tax['name'],
                  status: tax['status'],
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
            SizedBox(width: 16.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
          ],
        ),
      ),
    );
  }
}
