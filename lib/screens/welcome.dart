import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nixlab_admin/constants/colors.dart';
import 'package:nixlab_admin/providers/firebase_provider.dart';
import 'package:nixlab_admin/screens/home.dart';
import 'package:nixlab_admin/screens/login.dart';
import 'package:nixlab_admin/widgets/loading_indicator.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:version/version.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  late FirebaseProvider _firebaseProvider;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  var _isLoading = false;
  bool _hasUpdate = false;
  bool _hasError = false;
  var _message;
  var _downloadUrl;
  var _latVer;
  var _latBuildNo;
  List<dynamic> _changelog = [];
  PackageInfo _packageInfo = PackageInfo(
    appName: 'UNKNOWN',
    packageName: 'UNKNOWN',
    version: 'UNKNOWN',
    buildNumber: 'UNKNOWN',
  );
  var user = FirebaseAuth.instance.currentUser;

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }

    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    _checkAppVersion();
    _firebaseProvider = Provider.of<FirebaseProvider>(context, listen: false);
    if (user != null) _firebaseProvider.getUserInfo(user!.uid);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
        break;
      case ConnectivityResult.mobile:
        break;
      case ConnectivityResult.none:
        final snackBar = SnackBar(
          duration: Duration(seconds: 2),
          content: Text('No connection available.'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        break;
      default:
        final snackBar = SnackBar(
          duration: Duration(seconds: 2),
          content: Text('No connection available'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        break;
    }
  }

  Future<void> _checkAppVersion() async {
    setState(() {
      _isLoading = true;
    });
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      setState(() {
        _packageInfo = packageInfo;
      });

      try {
        await _firebaseProvider.getAppInfo().then((appInfoSnapshot) {
          if (appInfoSnapshot.exists) {
            print(appInfoSnapshot);
            final String latVer = appInfoSnapshot.data()!['version'];
            final int latBuildNo = appInfoSnapshot.data()!['build_no'];
            int major = int.parse(_packageInfo.version.substring(0, 1));
            int minor = int.parse(_packageInfo.version.substring(2, 3));
            int patch = int.parse(
                _packageInfo.version.substring(4, _packageInfo.version.length));
            int currBuildNo = int.parse(_packageInfo.buildNumber);
            final Version currVer = Version(major, minor, patch);
            final Version latVersion = Version.parse(latVer);

            if (latVersion > currVer || latBuildNo > currBuildNo) {
              setState(() {
                _hasUpdate = true;
                _hasError = false;
                _downloadUrl = appInfoSnapshot.data()!['url'].toString();
                _changelog = appInfoSnapshot.data()!['changelog'];
                _latVer = latVersion;
                _latBuildNo = latBuildNo;
              });
            } else {
              setState(() {
                _hasUpdate = false;
                _hasError = false;
              });
            }
          } else {
            setState(() {
              _hasError = true;
              _message = 'Data is empty!';
              _isLoading = false;
            });
          }
        });
      } on Exception catch (ex) {
        setState(() {
          _hasError = true;
          _message = ex.toString();
          _isLoading = false;
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } on Exception catch (e) {
      setState(() {
        _hasError = true;
        _message = e.toString();
        _isLoading = false;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }

    if (!_isLoading && !_hasUpdate && !_hasError) if (user != null)
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final bodyHeight = MediaQuery.of(context).size.height;
    final bodyWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: bodyWidth,
            height: bodyHeight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: bodyHeight * 0.1),
                Image.asset(
                  'assets/images/logo.png',
                  height: 100.0,
                ),
                SizedBox(height: bodyHeight * 0.2),
                _bodyArea(bodyWidth, bodyHeight)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _bodyArea(double width, double height) {
    if (_isLoading && !_hasError && !_hasUpdate) {
      return Expanded(child: _loadingScreen(height));
    }
    if (_hasError && !_hasUpdate && !_isLoading) {
      return Expanded(child: _errorScreen(width, height));
    }
    if (_hasUpdate && !_hasError && !_isLoading) {
      return Expanded(child: _updateScreen(height));
    }
    return Expanded(child: _welcomeScreen(width, height));
  }

  Column _loadingScreen(double height) => Column(
        children: [
          SizedBox(height: height * 0.2),
          LoadingIndicator(),
        ],
      );

  Widget _errorScreen(double width, double height) => Container(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'An error occurred.',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (_message != null) SizedBox(height: height * 0.05),
              if (_message != null)
                Text(
                  _message,
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              SizedBox(height: height * 0.2),
              TextButton(
                onPressed: _checkAppVersion,
                style: ButtonStyle(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Retry',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4.0),
                    Icon(Icons.arrow_forward),
                  ],
                ),
              )
            ],
          ),
        ),
      );

  Widget _welcomeScreen(double width, double height) => Container(
        height: height,
        child: Column(
          children: [
            const SizedBox(height: 20.0),
            Text(
              'Welcome To NixLab',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: width * 0.09,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            Text(
              'Code To Innovate',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: width * 0.04,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: height * 0.2),
            TextButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => LoginScreen()));
              },
              style: ButtonStyle(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Next'.toUpperCase(),
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4.0),
                  Icon(Icons.arrow_forward_ios),
                ],
              ),
            )
          ],
        ),
      );

  Widget _updateScreen(bodyHeight) => Container(
        height: bodyHeight,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 20.0,
                horizontal: 16.0,
              ),
              decoration: BoxDecoration(
                  color: Theme.of(context).bottomAppBarColor,
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      offset: Offset(0.0, 0.0),
                      blurRadius: 16.0,
                    ),
                  ]),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'A newer version is available.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  Text(
                    '${'Version'} : $_latVer ($_latBuildNo)',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Divider(color: Theme.of(context).accentColor),
                  Text(
                    'Changelog',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: secondColor,
                    ),
                  ),
                  if (_changelog.isNotEmpty)
                    ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(8.0),
                      itemCount: _changelog.length,
                      itemBuilder: (ctx, index) => Text(
                        '• ${_changelog[index]}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  SizedBox(height: 40.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        elevation: 0.0,
                        primary: Theme.of(context).scaffoldBackgroundColor,
                        padding: EdgeInsets.symmetric(
                          vertical: 12.0,
                          horizontal: 40.0,
                        ),
                        side: BorderSide(color: Theme.of(context).accentColor),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(32.0)))),
                    onPressed: () async {
                      final url = _downloadUrl;
                      if (await canLaunch(url)) {
                        await launch(url);
                      }
                    },
                    child: Text(
                      'Update',
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      );
}
