import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../service/auth_service.dart';
import 'package:flutter_application_4/models/campsite_model.dart';
import 'package:flutter_application_4/screens/CampGuide.dart';
import 'package:flutter_application_4/Widgets/backpack.dart';
import 'package:flutter_application_4/Widgets/budget.dart';

const kSpotifyBackground = Color(0xFF121212);
const kSpotifyAccent = Color(0xFF1DB954);
const kSpotifyTextPrimary = Color(0xFFFFFFFF);
const kSpotifyTextSecondary = Color(0xFFB3B3B3);
const kSpotifyHighlight = Color(0xFF282828);

class AccountScreen extends StatefulWidget {
  final double totalCost;
  final double enterFee;
  final double tentRental;
  final double house;
  final double campingFee;
  final String message;
  final AuthService auth;
  final String user;
  final bool isAnonymous;
  final CampsiteModel? campsite;

  const AccountScreen(
      {super.key,
      required this.totalCost,
      required this.enterFee,
      required this.tentRental,
      required this.house,
      required this.campingFee,
      required this.message,
      required this.auth,
      required this.user,
      required this.isAnonymous,
      required this.campsite});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  List<String> selectedTags = [];
  final List<Map<String, String>> tagOptions = [
    {
      'tag': '#CampLover',
      'description': 'สำหรับผู้ที่หลงใหลในการตั้งแคมป์เป็นชีวิตจิตใจ'
    },
    {
      'tag': '#NatureExplorer',
      'description': 'สำหรับผู้ที่ชอบสำรวจธรรมชาติและสถานที่ใหม่ๆ'
    },
    {'tag': '#WildCook', 'description': 'สำหรับผู้ที่ชอบทำอาหารกลางแจ้ง'},
    {
      'tag': '#MountainClimber',
      'description': 'สำหรับผู้ที่ชอบปีนเขาและตั้งแคมป์บนภูเขา'
    },
    {'tag': '#BeachCamper', 'description': 'สำหรับผู้ที่ชอบตั้งแคมป์ที่ชายหาด'},
    {'tag': '#SoloCamper', 'description': 'สำหรับผู้ที่ชอบการตั้งแคมป์คนเดียว'},
    {
      'tag': '#FamilyCamper',
      'description': 'สำหรับผู้ที่ชอบตั้งแคมป์กับครอบครัว'
    },
    {
      'tag': '#EcoFriendlyCamper',
      'description':
          'สำหรับผู้ที่ใส่ใจเรื่องสิ่งแวดล้อมและการตั้งแคมป์แบบรักษ์โลก'
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadTags();
  }

  void _loadTags() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('user')
          .doc(widget.user)
          .get();
      if (snapshot.exists) {
        var userData = snapshot.data() as Map<String, dynamic>;
        if (userData.containsKey('tag')) {
          setState(() {
            selectedTags = List<String>.from(userData['tag']);
          });
        }
      }
    } catch (e) {
      print("Failed to load tags: $e");
    }
  }

  void _showTagSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text(
                  'เลือกแท็กที่เข้ากับคุณเพื่อให้ระบบสามารถแนะนำข้อมูลที่คุณสนใจได้มากขึ้น'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: tagOptions.map((tagOption) {
                    bool isSelected = selectedTags.contains(tagOption['tag']);
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            selectedTags.remove(tagOption['tag']);
                          } else if (selectedTags.length < 3) {
                            if (tagOption['tag'] != null) {
                              selectedTags
                                  .add(tagOption['tag']!); // Add non-null tag
                            }
                          }
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4.0),
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.green : Colors.blue,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tagOption['tag']!,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 16.0),
                            ),
                            if (isSelected)
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Text(
                                  tagOption['description']!,
                                  style: const TextStyle(
                                      color: Colors.white70, fontSize: 14.0),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              actions: [
                Text('${selectedTags.length}/3'),
                TextButton(
                  onPressed: () {
                    FirebaseFirestore.instance
                        .collection('user')
                        .doc(widget.user)
                        .update({'tag': selectedTags}).then((_) {
                      Navigator.of(context).pop();
                    }).catchError((error) {
                      print("Failed to update tags: $error");
                    });
                  },
                  child: const Text('ยืนยัน'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSpotifyBackground,
      appBar: AppBar(
        backgroundColor: kSpotifyBackground,
        title: const Text(
          '🧾 โปรไฟล์ของคุณ',
          style: TextStyle(
            color: kSpotifyTextPrimary,
            fontSize: 18.0,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
              size: 28,
            ),
            onPressed: () async {
              await widget.auth.logout();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const CampGuide()),
                (route) => false,
              );
            },
          )
        ],
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: widget.isAnonymous
            ? _buildAnonymousCard(context)
            : StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('user')
                    .doc(widget.user)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text(
                      'Error loading user data',
                      style: TextStyle(color: kSpotifyTextSecondary),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: kSpotifyAccent,
                      ),
                    );
                  }

                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return const Text(
                      'No user data found',
                      style: TextStyle(color: kSpotifyTextSecondary),
                    );
                  }

                  var userData = snapshot.data!.data() as Map<String, dynamic>;
                  var userName = userData['name'] ?? 'ไม่พบชื่อผู้ใช้';
                  var userTags = List<String>.from(userData['tag'] ?? []);

                  return ListView(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        constraints: const BoxConstraints(
                            minWidth: 0, maxWidth: double.infinity),
                        decoration: BoxDecoration(
                          color: kSpotifyAccent,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: const Text(
                          'บัตรชาวแคมป์',
                          style: TextStyle(color: Colors.white, fontSize: 18.0),
                        ),
                      ),
                      _buildUserCard(userName, userTags),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        constraints: const BoxConstraints(
                            minWidth: 0, maxWidth: double.infinity),
                        decoration: BoxDecoration(
                          color: kSpotifyAccent,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: const Text(
                          'สัมภาระของฉัน',
                          style: TextStyle(color: Colors.white, fontSize: 18.0),
                        ),
                      ),
                      Backpack(
                        campsite: widget.campsite,
                        backType: widget.message,
                        id: widget.user,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Budget(
                        auth: widget.auth,
                        user: widget.user,
                        campsite: widget.campsite,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  );
                }),
      ),
    );
  }

  Widget _buildUserCard(String userName, List<String> userTags) {
    return Card(
      color: kSpotifyHighlight,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: const Icon(
              Icons.account_circle,
              color: kSpotifyTextPrimary,
              size: 50,
            ),
            title: Text(
              'ชื่อผู้ใช้: $userName',
              style: const TextStyle(color: kSpotifyTextPrimary),
            ),
            subtitle: userTags.isEmpty
                ? GestureDetector(
                    onTap: () {
                      _showTagSelectionDialog();
                    },
                    child: const Text(
                      'กรุณากดที่นี้เพื่อเลือกแท็ก',
                      style: TextStyle(color: Colors.red, fontSize: 14.0),
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8.0),
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 4.0,
                        children: userTags.map((tag) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 4.0,
                              horizontal: 8.0,
                            ),
                            decoration: BoxDecoration(
                              color: kSpotifyAccent,
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Text(
                              tag,
                              style: const TextStyle(color: Colors.white),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 8.0),
                      GestureDetector(
                        onTap: () {
                          _showTagSelectionDialog();
                        },
                        child: const Text(
                          'แก้ไขแท็ก',
                          style: TextStyle(
                            color: kSpotifyAccent,
                            fontSize: 14.0,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnonymousCard(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: () {
              _showAnonymousWarning(context);
            },
            child: Card(
              color: kSpotifyHighlight.withOpacity(0.7),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: const BorderSide(color: kSpotifyAccent),
              ),
              elevation: 5,
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.lock,
                      color: Colors.white,
                      size: 50,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Anonymous User',
                      style: TextStyle(
                        color: kSpotifyTextPrimary,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'กรุณาลงชื่อเข้าใช้เพื่อเข้าถึงข้อมูลโปรไฟล์',
                      style: TextStyle(
                        color: kSpotifyTextSecondary,
                        fontSize: 16.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showAnonymousWarning(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'การเข้าถึงถูกจำกัด',
            style: TextStyle(color: kSpotifyTextPrimary),
          ),
          content: const Text(
            'ระบบการ์ดชาวแคมป์ให้บริการเฉพาะผู้ที่เข้าสู่ระบบด้วย Email/Password เท่านั้น.',
            style: TextStyle(color: kSpotifyTextSecondary),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK', style: TextStyle(color: kSpotifyAccent)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
          backgroundColor: kSpotifyBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: const BorderSide(color: kSpotifyAccent),
          ),
        );
      },
    );
  }
}
