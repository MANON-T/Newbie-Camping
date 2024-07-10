import 'package:flutter/material.dart';
import 'package:flutter_application_4/models/campsite_model.dart';
import '../service/database.dart';
import 'package:flutter_application_4/screens/campsite_screen.dart';
import 'package:flutter_application_4/Widgets/suggestion.dart';
import '../service/auth_service.dart';
import 'package:flutter_application_4/models/user_model.dart';

// ใช้ชุดสีของ Spotify
const kSpotifyBackground = Color(0xFF121212);
const kSpotifyAccent = Color(0xFF1DB954);
const kSpotifyTextPrimary = Color(0xFFFFFFFF);
const kSpotifyTextSecondary = Color(0xFFB3B3B3);
const kSpotifyHighlight = Color(0xFF282828);

class CampScreen extends StatefulWidget {
  final AuthService auth;
  final UserModel? user;
  final String? Exp;
  final bool isAnonymous;
  const CampScreen(
      {super.key,
      required this.auth,
      required this.user,
      required this.Exp,
      required this.isAnonymous});

  @override
  State<CampScreen> createState() => _CampScreen();
}

class _CampScreen extends State<CampScreen> {
  Database db = Database.instance;
  final int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
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
              isAnonymous: widget.isAnonymous)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSpotifyBackground,
      appBar: AppBar(
        backgroundColor: kSpotifyBackground,
        title: const Text(
          '🏕️ ยินดีต้อนรับสู่แคมป์',
          style: TextStyle(
            color: kSpotifyTextPrimary,
            fontSize: 18.0,
          ),
        ),
        automaticallyImplyLeading: false, // Set this to false
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: kSpotifyTextPrimary),
            onPressed: () {
              showSearch(
                  context: context,
                  delegate: CampsiteSearchDelegate(
                      auth: widget.auth, user: widget.user, Exp: widget.Exp , isAnonymous: widget.isAnonymous));
            },
          ),
        ],
      ),
      body: Center(
        child: IndexedStack(
          index: _selectedIndex,
          children: [
            StreamBuilder(
              stream: db.getAllCampsiteStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(color: kSpotifyAccent);
                } else if (snapshot.hasError) {
                  return Text(
                    'เกิดข้อผิดพลาด: ${snapshot.error}',
                    style: const TextStyle(color: kSpotifyTextPrimary),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text(
                    'ไม่มีข้อมูลแคมป์',
                    style: TextStyle(color: kSpotifyTextPrimary),
                  );
                }

                final campsites = snapshot.data!;
                return ListView.builder(
                  itemCount: campsites.length,
                  itemBuilder: (context, index) {
                    final campsite = campsites[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4.0,
                        horizontal: 8.0,
                      ),
                      child: Card(
                        color: kSpotifyHighlight,
                        margin: const EdgeInsets.all(4.0),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
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
                                      fontSize: 15.0,
                                      color: kSpotifyAccent,
                                      fontWeight: FontWeight.bold,
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
                                    fontSize: 14.0,
                                  ),
                                ),
                                subtitle: Text(
                                  'คะแนน: ${campsite.campscore}',
                                  style: const TextStyle(
                                    color: kSpotifyTextSecondary,
                                    fontSize: 12.0,
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      _navigateToCampsiteScreen(campsite);
                                    },
                                    child: const Text(
                                      'เพิ่มเติม',
                                      style: TextStyle(
                                        color: kSpotifyAccent,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CampsiteSearchDelegate extends SearchDelegate {
  final AuthService auth;
  final UserModel? user;
  final String? Exp;
  final bool isAnonymous;
  CampsiteSearchDelegate(
      {required this.auth, required this.user, required this.Exp, required this.isAnonymous});

  Database db = Database.instance;

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      primaryColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 18.0,
        ),
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: Colors.white, // cursor color
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(
            decorationThickness: 0.0000001, // input text underline
            color: Colors.white // input text color
            ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        hintStyle: TextStyle(color: Colors.grey),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.green),
        ),
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear, color: Colors.white),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back, color: Colors.white),
      onPressed: () {
        close(context, null);
      },
    );
  }

  // Method to build the Suggestion widget
  Widget buildSuggestionWidget(BuildContext context) {
    return Suggestion(
      auth: auth,
      user: user,
      Exp: Exp,
      isAnonymous: isAnonymous,
    ); // Use your Suggestion widget here
  }

  @override
  Widget buildResults(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder(
        future: db.searchCampsitesByName(query),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text(
                'เกิดข้อผิดพลาด',
                style: TextStyle(color: Colors.white),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'ไม่พบผลลัพธ์',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          final campsites = snapshot.data!;
          return ListView.builder(
            itemCount: campsites.length,
            itemBuilder: (context, index) {
              final campsite = campsites[index];
              return ListTile(
                title: Text(
                  campsite.name,
                  style: const TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  'คะแนน: ${campsite.campscore}',
                  style: const TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CampsiteScreen(
                          campsite: campsite, auth: auth, user: user, Exp: Exp , isAnonymous: isAnonymous),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        buildSuggestionWidget(context), // Display the Suggestion widget
        Container(
          height: 16,
          color: Colors.black,
        ), // Add some space between suggestion and results
        Expanded(
          child: buildResults(context), // Display the search results
        ),
      ],
    );
  }
}
