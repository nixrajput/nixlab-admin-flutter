import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nixlab_admin/providers/firebase_provider.dart';
import 'package:nixlab_admin/widgets/custom_app_bar.dart';
import 'package:nixlab_admin/widgets/custom_body_scroll_view.dart';
import 'package:nixlab_admin/widgets/loading_indicator.dart';
import 'package:provider/provider.dart';

class DownloadPanel extends StatefulWidget {
  @override
  _DownloadPanelState createState() => _DownloadPanelState();
}

class _DownloadPanelState extends State<DownloadPanel> {
  late FirebaseProvider _firebaseProvider;

  @override
  void initState() {
    super.initState();
    _firebaseProvider = Provider.of<FirebaseProvider>(context, listen: false);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(title: 'Downloads'),
            CustomBodyScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 10.0),
                  FutureBuilder<List<QueryDocumentSnapshot>>(
                      future: _firebaseProvider.getDownloads(),
                      builder: (ctx, snapshots) {
                        if (snapshots.hasError) {
                          return Text(snapshots.error.toString());
                        }
                        if (snapshots.connectionState == ConnectionState.done) {
                          final data = snapshots.data!;
                          return GridView.builder(
                              physics: ScrollPhysics(),
                              itemCount: data.length,
                              shrinkWrap: true,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                mainAxisSpacing: 8.0,
                                crossAxisCount: 3,
                                childAspectRatio: 1.0,
                                crossAxisSpacing: 8.0,
                              ),
                              itemBuilder: (_, i) => Container(
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                        color:
                                            Theme.of(context).bottomAppBarColor,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0))),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Flexible(
                                          child: Image.network(
                                            data[i]['imgUrl'],
                                          ),
                                        ),
                                        Text(
                                          data[i]['title'],
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '${data[i]['size'].toString()} MB',
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),);
                        }
                        return LoadingIndicator();
                      },),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
