import 'package:flutter/material.dart';
import 'package:nixlab_admin/constants/colors.dart';
import 'package:nixlab_admin/providers/firebase_provider.dart';
import 'package:nixlab_admin/screens/panels/admin.dart';
import 'package:nixlab_admin/screens/panels/downloads.dart';
import 'package:nixlab_admin/screens/panels/projects.dart';
import 'package:nixlab_admin/screens/panels/users.dart';
import 'package:nixlab_admin/screens/profile.dart';
import 'package:nixlab_admin/widgets/grid_menu_button.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
          horizontal: 16.0,
          vertical: 8.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  'Nix',
                  style: TextStyle(
                    color: secondColor,
                    fontSize: width * 0.08,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Lab',
                  style: TextStyle(
                    fontSize: width * 0.08,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => ProfileScreen()));
              },
              child: CircleAvatar(
                backgroundColor: Colors.grey.shade400,
                child: ClipOval(
                  child: Image.network(
                    _firebaseProvider.userSnapshot.data()!['imgUrl'],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            )
          ],
        ),
      );

  Expanded _customBodyArea(double height, double width) => Expanded(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                SizedBox(height: 20.0),
                Text(
                  'Welcome, ${_firebaseProvider.userSnapshot.data()!['fname']}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: width * 0.05,
                  ),
                ),
                SizedBox(height: 28.0),
                GridView(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 1.0,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                    crossAxisCount: 2,
                  ),
                  children: [
                    GridMenuButton(
                      icon: Icons.admin_panel_settings,
                      label: 'Admin',
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => AdminPanel()));
                      },
                    ),
                    GridMenuButton(
                      icon: Icons.group,
                      label: 'Users',
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => UsersPanel()));
                      },
                    ),
                    GridMenuButton(
                      icon: Icons.folder,
                      label: 'Projects',
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => ProjectPanel()));
                      },
                    ),
                    GridMenuButton(
                      icon: Icons.cloud_download,
                      label: 'Downloads',
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => DownloadPanel()));
                      },
                    ),
                    GridMenuButton(
                      icon: Icons.feedback,
                      label: 'Feedback',
                      onTap: () {},
                    ),
                    GridMenuButton(
                      icon: Icons.report,
                      label: 'Contact Forms',
                      onTap: () {},
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      );
}
