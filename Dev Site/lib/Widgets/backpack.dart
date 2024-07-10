import 'package:flutter/material.dart';
import 'package:flutter_application_4/models/campsite_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ใช้ชุดสีของ Spotify
const kSpotifyBackground = Color(0xFF121212);
const kSpotifyAccent = Color(0xFF1DB954);
const kSpotifyTextPrimary = Color(0xFFFFFFFF);
const kSpotifyTextSecondary = Color(0xFFB3B3B3);
const kSpotifyHighlight = Color(0xFF282828);

class Backpack extends StatefulWidget {
  final CampsiteModel? campsite;
  final String backType;
  final String id;

  const Backpack({
    super.key,
    required this.campsite,
    required this.backType,
    required this.id,
  });

  @override
  State<Backpack> createState() => _BackpackState();
}

class _BackpackState extends State<Backpack> {
  String backpackStatus = "กำลังโหลด...";

  @override
  void initState() {
    super.initState();
    _loadBackpackStatus();
  }

  Future<void> _loadBackpackStatus() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('user')
          .doc(widget.id)
          .get();

      String backpack = snapshot.data()?['backpack'] ?? '';

      if (backpack.isEmpty) {
        setState(() {
          backpackStatus = "ยังไม่ได้จัดสัมภาระ";
        });
      } else {
        setState(() {
          backpackStatus = backpack;
        });
      }
    } catch (e) {
      setState(() {
        backpackStatus = "เกิดข้อผิดพลาดในการโหลดข้อมูล";
      });
    }
  }

  List<String> _getBackpackItems() {
    if (widget.campsite == null) {
      return [];
    }

    switch (backpackStatus) {
      case "สำหรับมือใหม่":
        return widget.campsite!.newbie_backpack ?? [];
      case "สำหรับทั่วไป แบบ 1":
        return widget.campsite!.common_backpack1 ?? [];
      case "สำหรับทั่วไป แบบ 2":
        return widget.campsite!.common_backpack2 ?? [];
      case "ยังไม่ได้จัดสัมภาระ":
        return ["ยังไม่ได้จัดสัมภาระ"];
      default:
        return [backpackStatus];
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> backpackItems = _getBackpackItems();
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          color: kSpotifyBackground,
          border: Border.all(color: kSpotifyAccent, width: 2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                backpackStatus,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: kSpotifyTextPrimary,
                ),
              ),
              const SizedBox(height: 16),
              ...backpackItems.map((item) => ListTile(
                    leading:
                        const Icon(Icons.check, color: kSpotifyTextPrimary),
                    title: Text(
                      item,
                      style: const TextStyle(color: kSpotifyTextSecondary),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
