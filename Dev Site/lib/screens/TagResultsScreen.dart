import 'package:flutter/material.dart';
import 'package:flutter_application_4/models/campsite_model.dart';
import 'package:flutter_application_4/service/database.dart';
import 'package:flutter_application_4/screens/campsite_screen.dart';
import '../service/auth_service.dart';
import 'package:flutter_application_4/models/user_model.dart';

// ใช้ชุดสีของ Spotify
const kSpotifyBackground = Color(0xFF121212);
const kSpotifyAccent = Color(0xFF1DB954);
const kSpotifyTextPrimary = Color(0xFFFFFFFF);
const kSpotifyTextSecondary = Color(0xFFB3B3B3);
const kSpotifyHighlight = Color(0xFF282828);

class TagResultsScreen extends StatefulWidget {
  final String tag;
  final AuthService auth;
  final UserModel? user;
  final String? Exp;
  final bool isAnonymous;

  const TagResultsScreen(
      {super.key,
      required this.tag,
      required this.auth,
      required this.user,
      required this.Exp,
      required this.isAnonymous});

  @override
  _TagResultsScreenState createState() => _TagResultsScreenState();
}

class _TagResultsScreenState extends State<TagResultsScreen> {
  List<CampsiteModel> _campsites = [];

  @override
  void initState() {
    super.initState();
    _getCampsitesByTag();
  }

  Future<void> _getCampsitesByTag() async {
    try {
      List<CampsiteModel> campsites =
          await Database.instance.getCampsitesByTag([widget.tag]);
      setState(() {
        _campsites = campsites;
      });
    } catch (e) {
      print('Error getting campsites by tag: $e');
    }
  }

  void _navigateToCampsiteScreen(CampsiteModel campsite) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CampsiteScreen(
          campsite: campsite,
          auth: widget.auth,
          user: widget.user,
          Exp: widget.Exp,
          isAnonymous: widget.isAnonymous,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFFFFFFF)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          widget.tag,
          style: const TextStyle(
              fontSize: 22.0,
              color: kSpotifyTextPrimary,
              // fontWeight: FontWeight.bold,
              fontFamily: 'Itim'),
        ),
        backgroundColor: kSpotifyBackground,
      ),
      backgroundColor: kSpotifyBackground,
      body: ListView.builder(
        itemCount: _campsites.length,
        itemBuilder: (context, index) {
          CampsiteModel campsite = _campsites[index];
          return Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 4.0,
              horizontal: 8.0,
            ),
            child: InkWell(
              onTap: () {
                _navigateToCampsiteScreen(campsite);
              },
              child: Card(
                color: kSpotifyHighlight,
                margin: const EdgeInsets.all(4.0), // ลดระยะของการ์ด
                child: Padding(
                  padding: const EdgeInsets.all(8.0), // ลดระยะภายในการ์ด
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 120, // ลดขนาดของรูปภาพ
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          image: DecorationImage(
                            image: AssetImage(campsite.imageURL),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      if (index == 0)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 4.0),
                          child: Text(
                            '✨ แนะนำ',
                            style: TextStyle(
                              fontSize: 17.0,
                              color: kSpotifyAccent,
                              fontFamily: 'Itim',
                            ),
                          ),
                        ),
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 4.0,
                          horizontal: 8.0,
                        ),
                        title: Text(
                          campsite.name,
                          style: const TextStyle(
                            color: kSpotifyTextPrimary,
                            fontSize: 17.0,
                            fontFamily: 'Itim',
                          ),
                        ),
                        subtitle: Text(
                          'คะแนน: ${campsite.campscore}',
                          style: const TextStyle(
                            color: kSpotifyTextSecondary,
                            fontSize: 14.0,
                            fontFamily: 'Itim',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 9),
                        child: Text(
                          'แท็ก: #${campsite.tag.join(" #")}',
                          style: const TextStyle(
                            color: Colors.cyan,
                            fontFamily: 'Itim',
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
