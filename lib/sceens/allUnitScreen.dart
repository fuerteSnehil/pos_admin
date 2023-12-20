import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pos_admin/constants/colors.dart';

class AllUnitScreen extends StatefulWidget {
  final String uid;
  const AllUnitScreen({required this.uid, super.key});

  @override
  State<AllUnitScreen> createState() => _AllUnitScreenState();
}

class _AllUnitScreenState extends State<AllUnitScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: Text(
              'Unit List',
              style: TextStyle(fontFamily: 'tabfont'),
            )),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('AllAdmins')
                .doc(widget.uid)
                .collection('units')
                .orderBy('createdAt', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(color: primaryColor),
                );
              } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(child: Text("NO data Found"));
              } else {
                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var myData = snapshot.data!.docs[index];
                      return UnitListItem(
                          name: myData['name'],
                          status: myData['status'],
                          remark: myData['remark']);
                    });
              }
            }));
  }
}

class UnitListItem extends StatelessWidget {
  final String name;
  final String status;
  final String remark;

  const UnitListItem(
      {required this.name,
      required this.status,
      required this.remark,
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
                Text(
                  remark,
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
