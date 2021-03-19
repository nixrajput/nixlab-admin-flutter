import 'package:flutter/material.dart';
import 'package:nixlab_admin/widgets/custom_app_bar.dart';
import 'package:nixlab_admin/widgets/custom_body_scroll_view.dart';

class ProjectPanel extends StatefulWidget {
  @override
  _ProjectPanelState createState() => _ProjectPanelState();
}

class _ProjectPanelState extends State<ProjectPanel> {
  @override
  Widget build(BuildContext context) {
    final bodyHeight = MediaQuery.of(context).size.height;
    final bodyWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(title: 'Projects'),
            CustomBodyScrollView(
                child: Column(
              children: [
                const SizedBox(height: 10.0),
                Text('Projects'),
              ],
            ))
          ],
        ),
      ),
    );
  }
}
