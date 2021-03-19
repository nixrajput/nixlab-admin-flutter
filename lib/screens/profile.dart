import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nixlab_admin/helpers/timestamp_to_datetime.dart';
import 'package:nixlab_admin/providers/firebase_provider.dart';
import 'package:nixlab_admin/screens/login.dart';
import 'package:nixlab_admin/screens/privacy.dart';
import 'package:nixlab_admin/screens/settings.dart';
import 'package:nixlab_admin/screens/terms.dart';
import 'package:nixlab_admin/widgets/custom_app_bar.dart';
import 'package:nixlab_admin/widgets/custom_body_scroll_view.dart';
import 'package:nixlab_admin/widgets/custom_text_button.dart';
import 'package:nixlab_admin/widgets/custom_text_tile.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late FirebaseProvider _firebaseProvider;

  @override
  void initState() {
    super.initState();
    _firebaseProvider = Provider.of<FirebaseProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    final bodyWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(title: 'Profile'),
            CustomBodyScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10.0),
                  CircleAvatar(
                    radius: 60.0,
                    backgroundColor: Colors.grey.shade400,
                    child: ClipOval(
                      child: Image.network(
                        _firebaseProvider.userSnapshot.data()!['imgUrl'],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Card(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            '${_firebaseProvider.userSnapshot.data()!['fname']} '
                            '${_firebaseProvider.userSnapshot.data()!['lname']}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: bodyWidth * 0.05,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          CustomTextTile(
                            icon: Icons.email_outlined,
                            label:
                                _firebaseProvider.userSnapshot.data()!['email'],
                          ),
                          CustomTextTile(
                            icon: Icons.person_outlined,
                            label:
                                _firebaseProvider.userSnapshot.data()!['uname'],
                          ),
                          CustomTextTile(
                            icon: Icons.calendar_today_outlined,
                            label: dateTime(
                                _firebaseProvider.userSnapshot.data()!['dob']),
                          ),
                          CustomTextTile(
                            icon: Icons.schedule_outlined,
                            label: dateTime(_firebaseProvider.userSnapshot
                                .data()!['timestamp']),
                          ),
                          CustomTextButton(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => Settings()));
                            },
                            label: 'Settings',
                            icon: Icons.arrow_forward,
                          ),
                          CustomTextButton(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => TermsScreen()));
                            },
                            label: 'Terms & Conditions',
                            icon: Icons.arrow_forward,
                          ),
                          CustomTextButton(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => PrivacyScreen()));
                            },
                            label: 'Privacy Policy',
                            icon: Icons.arrow_forward,
                          ),
                          CustomTextButton(
                            onTap: () {
                              FirebaseAuth.instance.signOut().then((_) {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => LoginScreen()));
                              });
                            },
                            label: 'Logout',
                            icon: Icons.logout,
                          ),
                        ],
                      ),
                    ),
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
