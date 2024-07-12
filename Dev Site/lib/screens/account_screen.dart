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
                  // var userEmail = userData['email'] ?? 'ไม่พบอีเมลผู้ใช้';
                  var userTags =
                      List<String>.from(userData['tag'] ?? []); // ดึงข้อมูล tag

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
                          'สรุปค่าใช้จ่าย',
                          style: TextStyle(color: Colors.white, fontSize: 18.0),
                        ),
                      ),
                      Budget(
                        auth: widget.auth,
                        user: widget.user,
                        // campingFee: widget.campingFee,
                        // house: widget.house,
                        campsite: widget.campsite,
                        // enterFee: widget.enterFee,
                        // tentRental: widget.tentRental,
                        // totalCost: widget.totalCost
                      )
                    ],
                  );
                },
              ),
      ),
    );
  }

  Widget _buildUserCard(String userName, List<String> userTags) {
    return Card(
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: const BorderSide(color: kSpotifyAccent),
      ),
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.23,
        decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage('images/game-card-wallpaper-preview.jpg'),
            fit: BoxFit.cover,
          ),
          color: Colors.black54,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.person,
                    color: kSpotifyAccent,
                    size: 24.0,
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () => _showFullId(context, widget.user),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Text(
                        'ID: ${widget.user}',
                        style: const TextStyle(
                          color: kSpotifyBackground,
                          fontSize: 18.0,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Divider(color: kSpotifyTextSecondary),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(
                    Icons.account_circle,
                    color: kSpotifyAccent,
                    size: 24.0,
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: GestureDetector(
                      onTap: () => _showEditNameDialog(context, userName),
                      child: Text(
                        userName,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Flexible(
                child: Row(
                  children: [
                    const Icon(
                      Icons.tag,
                      color: kSpotifyAccent,
                      size: 24.0,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          // shrinkWrap: true,
                          child: Row(
                            children: [
                              for (var i = 0; i < userTags.length; i++)
                                Container(
                                  margin: const EdgeInsets.only(right: 8.0),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4.0, horizontal: 8.0),
                                  decoration: BoxDecoration(
                                    color: getTagColor(
                                        i), // Use getTagColor function to get the color
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: Text(
                                    userTags[i],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color getTagColor(int index) {
  List<Color> colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.purple,
    Colors.orange,
    Colors.pink,
    Colors.teal,
    Colors.indigo,
    Colors.lime,
  ];
  
  return colors[index % colors.length]; // Use the modulo operator to wrap around the list of colors
}

  void _showEditNameDialog(BuildContext context, String currentName) {
    final TextEditingController nameController =
        TextEditingController(text: currentName);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'แก้ไขชื่อผู้ใช้',
            style: TextStyle(color: kSpotifyTextPrimary),
          ),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'ชื่อผู้ใช้ใหม่',
              labelStyle: TextStyle(color: kSpotifyTextSecondary),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: kSpotifyAccent),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: kSpotifyAccent),
              ),
            ),
            style: const TextStyle(color: kSpotifyTextPrimary),
          ),
          actions: <Widget>[
            TextButton(
              child:
                  const Text('ยกเลิก', style: TextStyle(color: kSpotifyAccent)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child:
                  const Text('ยืนยัน', style: TextStyle(color: kSpotifyAccent)),
              onPressed: () async {
                String newName = nameController.text.trim();
                if (newName.isNotEmpty) {
                  await FirebaseFirestore.instance
                      .collection('user')
                      .doc(widget.user)
                      .update({'name': newName});
                  Navigator.of(context).pop();
                }
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

  void _showFullId(BuildContext context, String userId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'User ID',
            style: TextStyle(color: kSpotifyTextPrimary),
          ),
          content: Text(
            userId,
            style: const TextStyle(color: kSpotifyTextSecondary),
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
