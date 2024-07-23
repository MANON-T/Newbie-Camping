import 'package:flutter/material.dart';
import 'package:flutter_application_4/models/tip_model.dart';

// ใช้ชุดสีของ Spotify
const kSpotifyBackground = Color(0xFF121212);
const kSpotifyAccent = Color(0xFF1DB954);
const kSpotifyTextPrimary = Color(0xFFFFFFFF);
const kSpotifyTextSecondary = Color(0xFFB3B3B3);
const kSpotifyHighlight = Color(0xFF282828);

class TipReadScreen extends StatefulWidget {
  final TipModel tipModel;
  const TipReadScreen({super.key, required this.tipModel});

  @override
  State<TipReadScreen> createState() => _TipReadScreenState();
}

class _TipReadScreenState extends State<TipReadScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kSpotifyBackground,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFFFFFFFF)),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: kSpotifyBackground,
          title: Text(
            widget.tipModel.topic,
            style: const TextStyle(
                color: kSpotifyTextPrimary, fontSize: 20.0, fontFamily: 'Itim'),
          ),
        ),
        body: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0), // กำหนดความมนของขอบ
              child: SizedBox(
                width: 400.0, // กำหนดความกว้างของรูปภาพ
                height: 200.0, // กำหนดความสูงของรูปภาพ
                child: Image.asset(
                  widget.tipModel.imageURL,
                  fit: BoxFit.cover, // ปรับขนาดรูปภาพให้พอดีกับขนาดที่กำหนด
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Divider(),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  widget.tipModel.description,
                  style: const TextStyle(
                      color: kSpotifyTextPrimary,
                      fontSize: 20.0,
                      fontFamily: 'Itim'),
                ),
              ),
            ),
          ],
        ));
  }
}
