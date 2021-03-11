import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nixlab_admin/providers/firebase_provider.dart';
import 'package:nixlab_admin/widgets/loading_indicator.dart';
import 'package:provider/provider.dart';

class UsersPanel extends StatefulWidget {
  @override
  _UsersPanelState createState() => _UsersPanelState();
}

class _UsersPanelState extends State<UsersPanel> {
  late FirebaseProvider _firebaseProvider;

  @override
  void initState() {
    super.initState();
    _firebaseProvider = Provider.of<FirebaseProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    final bodyHeight = MediaQuery.of(context).size.height;
    final bodyWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _customAppBar(bodyWidth),
            _customBodyArea(bodyHeight, bodyWidth),
          ],
        ),
      ),
    );
  }

  Padding _customAppBar(double width) => Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 8.0,
        ),
        child: Row(
          children: [
            IconButton(
              padding: EdgeInsets.zero,
              icon: Icon(
                Icons.arrow_back,
                size: 40.0,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            const SizedBox(width: 8.0),
            Text(
              'Admin',
              style: TextStyle(
                fontSize: width * 0.08,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );

  Expanded _customBodyArea(double height, double width) => Expanded(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FutureBuilder<List<QueryDocumentSnapshot>>(
                  future: _firebaseProvider.getUsersData(),
                  builder: (ctx, snapshots) {
                    if (snapshots.hasError) {
                      return Text(snapshots.error.toString());
                    }

                    if (snapshots.connectionState == ConnectionState.done) {
                      final data = snapshots.data!;
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: data.length,
                        physics: ScrollPhysics(),
                        itemBuilder: (admin, i) => Container(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          decoration: BoxDecoration(
                              color: Theme.of(context).bottomAppBarColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16.0))),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(0.0),
                            leading: CircleAvatar(
                              radius: 40.0,
                              child: ClipOval(
                                child: Image.network(
                                  data[i]['imgUrl'],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            title: Text(
                              '${data[i]['fname']} ${data[i]['lname']}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                              ),
                            ),
                            subtitle: Text('${data[i]['designation']}'),
                          ),
                        ),
                      );
                    }

                    return LoadingIndicator();
                  },
                )
              ],
            ),
          ),
        ),
      );
}
