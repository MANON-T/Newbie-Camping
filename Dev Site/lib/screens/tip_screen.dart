import 'package:flutter/material.dart';
import 'package:flutter_application_4/models/tip_model.dart';
import '../service/database.dart';

// ใช้ชุดสีของ Spotify
const kSpotifyBackground = Color(0xFF121212);
const kSpotifyAccent = Color(0xFF1DB954);
const kSpotifyTextPrimary = Color(0xFFFFFFFF);
const kSpotifyTextSecondary = Color(0xFFB3B3B3);
const kSpotifyHighlight = Color(0xFF282828);

class TipScreen extends StatefulWidget {
  const TipScreen({super.key});

  @override
  State<TipScreen> createState() => _TipScreen();
}

class _TipScreen extends State<TipScreen> {
  Database db = Database.instance;
  final int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSpotifyBackground,
      appBar: AppBar(
        backgroundColor: kSpotifyBackground,
        title: const Text(
          '🥴 เกล็ดความรู้สำหรับคุณ',
          style: TextStyle(
              color: kSpotifyTextPrimary, fontSize: 20.0, fontFamily: 'Itim'),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: IndexedStack(
          index: _selectedIndex,
          children: [
            StreamBuilder<List<TipModel>>(
              stream: db.getallTipStream(),
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
                    'ไม่มีข้อมูลทิป',
                    style: TextStyle(color: kSpotifyTextPrimary),
                  );
                }

                final tips = snapshot.data!;
                return ListView.builder(
                  itemCount: tips.length,
                  itemBuilder: (context, index) {
                    final tip = tips[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 8.0),
                      child: Card(
                        color: kSpotifyHighlight,
                        margin: const EdgeInsets.all(4.0),
                        child: InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text(
                                  tip.topic,
                                  style: const TextStyle(fontFamily: 'Itim'),
                                ),
                                content: SizedBox(
                                  width: double.maxFinite,
                                  child: SingleChildScrollView(
                                    child: Text(
                                      tip.description,
                                      style: const TextStyle(fontFamily: 'Itim',fontSize: 16),
                                    ),
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('ปิด',style: TextStyle(fontFamily: 'Itim',fontSize: 17),),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      8.0), // กำหนดความมนของขอบ
                                  child: SizedBox(
                                    width: 400.0, // กำหนดความกว้างของรูปภาพ
                                    height: 200.0, // กำหนดความสูงของรูปภาพ
                                    child: Image.asset(
                                      tip.imageURL,
                                      fit: BoxFit
                                          .cover, // ปรับขนาดรูปภาพให้พอดีกับขนาดที่กำหนด
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                Text(
                                  tip.topic,
                                  style: const TextStyle(
                                    color: kSpotifyTextPrimary,
                                    fontSize: 22.0,
                                    fontFamily: 'Itim',
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
