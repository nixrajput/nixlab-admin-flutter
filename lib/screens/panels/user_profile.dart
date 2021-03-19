import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nixlab_admin/helpers/timestamp_to_datetime.dart';
import 'package:nixlab_admin/widgets/custom_app_bar.dart';
import 'package:nixlab_admin/widgets/custom_body_scroll_view.dart';
import 'package:nixlab_admin/widgets/custom_text_tile.dart';

class UserProfile extends StatefulWidget {
  final String imgUrl;
  final String firstName;
  final String lastName;
  final String email;
  final String userName;
  final Timestamp dateJoined;

  const UserProfile({
    Key? key,
    required this.userName,
    required this.imgUrl,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.dateJoined,
  }) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    final bodyWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(title: widget.firstName),
            CustomBodyScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10.0),
                  CircleAvatar(
                    radius: 80.0,
                    backgroundColor: Colors.grey.shade400,
                    child: ClipOval(
                      child: Image.network(
                        widget.imgUrl,
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
                            '${widget.firstName} '
                            '${widget.lastName}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: bodyWidth * 0.05,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          CustomTextTile(
                            icon: Icons.email_outlined,
                            label: widget.email,
                          ),
                          CustomTextTile(
                            icon: Icons.person_outlined,
                            label: widget.userName,
                          ),
                          CustomTextTile(
                            icon: Icons.schedule_outlined,
                            label: dateTime(widget.dateJoined),
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
