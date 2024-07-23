import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_application_4/models/campsite_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../service/database.dart';
import 'package:flutter_application_4/screens/campsite_screen.dart';
import 'package:flutter_application_4/Widgets/suggestion.dart';
import '../service/auth_service.dart';
import 'package:flutter_application_4/models/user_model.dart';

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
  const CampScreen({
    super.key,
    required this.auth,
    required this.user,
    required this.Exp,
    required this.isAnonymous,
  });

  @override
  State<CampScreen> createState() => _CampScreen();
}

class _CampScreen extends State<CampScreen> {
  Database db = Database.instance;
  final int _selectedIndex = 0;
  List<CampsiteModel> suggestedCampsites = [];
  CampsiteModel? topRecommendedCampsite;

  late StreamSubscription<DocumentSnapshot> _userTagStreamSubscription;

  @override
  void initState() {
    super.initState();
    _listenToUserTags();
  }

  void _listenToUserTags() {
    final uid = widget.auth.currentUser!.uid;
    _userTagStreamSubscription = FirebaseFirestore.instance
        .collection('user')
        .doc(uid)
        .snapshots()
        .listen((userDoc) async {
      List<String> userTags = List.from(userDoc.data()?['tag'] ?? []);
      if (userTags.isNotEmpty) {
        suggestedCampsites = await getSuggestedCampsites(userTags);
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _userTagStreamSubscription.cancel();
    super.dispose();
  }

  Future<List<CampsiteModel>> getSuggestedCampsites(
      List<String> userTags) async {
    QuerySnapshot campsiteSnapshot =
        await FirebaseFirestore.instance.collection('campsite').get();
    List<CampsiteModel> suggestedCampsites = [];
    int maxMatchCount = 0;

    for (QueryDocumentSnapshot doc in campsiteSnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      List<String> suggesTags = List.from(data['sugges_tag'] ?? []);
      int matchCount = suggesTags.where((tag) => userTags.contains(tag)).length;

      if (matchCount > maxMatchCount) {
        maxMatchCount = matchCount;
        suggestedCampsites = [CampsiteModel.fromDocument(doc)];
        topRecommendedCampsite = CampsiteModel.fromDocument(doc);
      } else if (matchCount == maxMatchCount) {
        suggestedCampsites.add(CampsiteModel.fromDocument(doc));
      }
    }
    return suggestedCampsites;
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
      backgroundColor: kSpotifyBackground,
      appBar: AppBar(
        backgroundColor: kSpotifyBackground,
        title: const Text(
          '🏕️ ยินดีต้อนรับสู่แคมป์',
          style: TextStyle(
            color: kSpotifyTextPrimary,
            fontSize: 20.0,
            fontFamily: 'Itim',
          ),
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: kSpotifyTextPrimary),
            onPressed: () {
              showSearch(
                context: context,
                delegate: CampsiteSearchDelegate(
                  auth: widget.auth,
                  user: widget.user,
                  Exp: widget.Exp,
                  isAnonymous: widget.isAnonymous,
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: IndexedStack(
          index: _selectedIndex,
          children: [
            StreamBuilder<List<CampsiteModel>>(
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
                final hasTopRecommendedCampsite =
                    topRecommendedCampsite != null;

                List<CampsiteModel> displayCampsites = [];

                if (hasTopRecommendedCampsite) {
                  // Add the top recommended campsite first
                  displayCampsites.add(topRecommendedCampsite!);
                  // Add the remaining campsites excluding the top recommended one
                  displayCampsites.addAll(campsites.where((campsite) =>
                      campsite.name != topRecommendedCampsite!.name));
                } else {
                  // Show all campsites as usual
                  displayCampsites = campsites;
                }

                return ListView.builder(
                  itemCount: displayCampsites.length,
                  itemBuilder: (context, index) {
                    final campsite = displayCampsites[index];
                    String recommendationText = '';

                    if (hasTopRecommendedCampsite && index == 0) {
                      recommendationText = '✨ แนะนำสำหรับคุณ';
                    } else if (topRecommendedCampsite == null && index == 0) {
                      recommendationText = '✨ แนะนำ';
                    }

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
                          margin: const EdgeInsets.all(4.0),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 120,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    image: DecorationImage(
                                      image: AssetImage(campsite.imageURL),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                if (recommendationText.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4.0),
                                    child: Text(
                                      recommendationText,
                                      style: const TextStyle(
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
      {required this.auth,
      required this.user,
      required this.Exp,
      required this.isAnonymous});

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
                  style: const TextStyle(
                      color: Colors.white, fontFamily: 'Itim', fontSize: 17),
                ),
                subtitle: Text(
                  'คะแนน: ${campsite.campscore}',
                  style: const TextStyle(
                      color: Colors.white, fontFamily: 'Itim', fontSize: 15),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CampsiteScreen(
                          campsite: campsite,
                          auth: auth,
                          user: user,
                          Exp: Exp,
                          isAnonymous: isAnonymous),
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
