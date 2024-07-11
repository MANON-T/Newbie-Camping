import 'package:flutter/material.dart';
import 'package:flutter_application_4/models/campsite_model.dart';
import 'package:flutter_application_4/screens/Pack_your_bags.dart';
import '../service/auth_service.dart';
import 'package:flutter_application_4/models/user_model.dart';
import 'package:flutter_application_4/screens/map_screen.dart';

// Use Spotify color scheme
const kSpotifyBackground = Color(0xFF121212);
const kSpotifyAccent = Color(0xFF1DB954);
const kSpotifyTextPrimary = Color(0xFFFFFFFF);
const kSpotifyTextSecondary = Color(0xFFB3B3B3);
const kSpotifyHighlight = Color(0xFF282828);

class CampsiteScreen extends StatefulWidget {
  final CampsiteModel campsite;
  final AuthService auth;
  final UserModel? user;
  final String? Exp;
  final bool isAnonymous;

  const CampsiteScreen(
      {super.key,
      required this.campsite,
      required this.auth,
      required this.user,
      required this.Exp,
      required this.isAnonymous});

  @override
  _CampsiteScreenState createState() => _CampsiteScreenState();
}

class _CampsiteScreenState extends State<CampsiteScreen> {
  bool _isImageExpanded = false;

  // Function to show warning dialog
  void showWarningDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: kSpotifyHighlight,
          title: const Text(
            "สิ่งที่ไม่ควรทำในสถานที่ตั้งแคมป์",
            style: TextStyle(
              color: kSpotifyTextPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: widget.campsite.warning
                  .map((warning) => Text(
                        '- $warning',
                        style: const TextStyle(
                          color: kSpotifyTextSecondary,
                          fontSize: 15.0,
                        ),
                      ))
                  .toList(),
            ),
          ),
          actions: [
            TextButton(
              child: const Text(
                "ปิด",
                style: TextStyle(
                  color: kSpotifyAccent,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _navigateToPackYourBags(CampsiteModel campsite) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PackYourBags(
          campsite: campsite,
          auth: widget.auth,
          user: widget.user,
          Exp: widget.Exp,
          isAnonymous: widget.isAnonymous,
        ),
      ),
    );
  }

  void _navigateToMap(CampsiteModel campsite) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapScreen(campsite: campsite),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFFFFFFF)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: const Color(0xFF121212),
        title: Text(
          widget.campsite.name,
          style: const TextStyle(
            color: Color(0xFFFFFFFF),
            fontSize: 18.0,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _isImageExpanded = !_isImageExpanded;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: _isImageExpanded ? 400 : 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                image: DecorationImage(
                  image: AssetImage(widget.campsite.imageURL),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          const Text(
            'ค่าบริการ 🪙',
            style: TextStyle(
              color: Color(0xFFFFFFFF),
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            "ค่าเข้าผู้ใหญ่: ${widget.campsite.adultEntryFee} บาท",
            style: const TextStyle(
              color: Color(0xFFB3B3B3),
              fontSize: 15.0,
            ),
          ),
          Text(
            "ค่าเข้าเด็ก: ${widget.campsite.childEntryFee} บาท",
            style: const TextStyle(
              color: Color(0xFFB3B3B3),
              fontSize: 15.0,
            ),
          ),
          Text(
            "รถยนต์: ${widget.campsite.parkingFee} บาท/คัน",
            style: const TextStyle(
              color: Color(0xFFB3B3B3),
              fontSize: 15.0,
            ),
          ),
          const SizedBox(height: 16.0),
          const Text(
            'ค่ากางเต้น ⛺',
            style: TextStyle(
              color: Color(0xFFFFFFFF),
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            "เริ่มต้น: ${widget.campsite.campingFee} บาท/คืน",
            style: const TextStyle(
              color: Color(0xFFB3B3B3),
              fontSize: 15.0,
            ),
          ),
          const SizedBox(height: 16.0),
          const Text(
            'การบริการ 🐕‍🦺',
            style: TextStyle(
              color: Color(0xFFFFFFFF),
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          Row(
            children: [
              const Text(
                'มีที่พัก:',
                style: TextStyle(
                  color: Color(0xFFB3B3B3),
                  fontSize: 15.0,
                ),
              ),
              const SizedBox(width: 0.0),
              Checkbox(
                value: widget.campsite.accommodationAvailable,
                onChanged: (value) {
                  // Handle the checkbox change
                },
              ),
              const Text(
                'มีเต็นท์ให้บริการ:',
                style: TextStyle(
                  color: Color(0xFFB3B3B3),
                  fontSize: 15.0,
                ),
              ),
              const SizedBox(width: 0.0),
              Checkbox(
                value: widget.campsite.tentService,
                onChanged: (value) {
                  // Handle the checkbox change
                },
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          const Text(
            'กิจกรรม 🎭',
            style: TextStyle(
              color: Color(0xFFFFFFFF),
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          if (widget.campsite.activities.isEmpty)
            const Text(
              'ไม่พบข้อมูล',
              style: TextStyle(
                color: Color(0xFFB3B3B3),
                fontSize: 15.0,
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.campsite.activities.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(
                    '- ${widget.campsite.activities[index]}',
                    style: const TextStyle(
                      color: Color(0xFFB3B3B3),
                      fontSize: 15.0,
                    ),
                  ),
                );
              },
            ),
          const SizedBox(height: 16.0),
          const Text(
            'ห้องน้ำ 🧼',
            style: TextStyle(
              color: Color(0xFFFFFFFF),
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              const Text(
                'ห้องน้ำสะอาด 🛁:',
                style: TextStyle(
                  color: Color(0xFFB3B3B3),
                  fontSize: 15.0,
                ),
              ),
              const SizedBox(width: 0.0),
              Checkbox(
                value: widget.campsite.cleanRestrooms,
                onChanged: (value) {
                  // Handle the checkbox change
                },
              ),
              const Text(
                'แยกชายหญิง 🚻:',
                style: TextStyle(
                  color: Color(0xFFB3B3B3),
                  fontSize: 15.0,
                ),
              ),
              const SizedBox(width: 0.0),
              Checkbox(
                value: widget.campsite.genderSeparatedRestrooms,
                onChanged: (value) {
                  // Handle the checkbox change
                },
              ),
            ],
          ),
          const Text(
            'สัญญานมือถือ 📶',
            style: TextStyle(
              color: Color(0xFFFFFFFF),
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          if (widget.campsite.phoneSignal.isEmpty)
            const Text(
              'ไม่พบข้อมูล',
              style: TextStyle(
                color: Color(0xFFB3B3B3),
                fontSize: 15.0,
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.campsite.phoneSignal.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(
                    widget.campsite.phoneSignal[index],
                    style: const TextStyle(
                      color: Color(0xFFB3B3B3),
                      fontSize: 15.0,
                    ),
                  ),
                );
              },
            ),
          const SizedBox(height: 16.0),
          const Text(
            'ไฟฟ้าต่อพ่วง 🔌',
            style: TextStyle(
              color: Color(0xFFFFFFFF),
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              const Text(
                'ไฟฟ้าต่อพ่วง 🔌:',
                style: TextStyle(
                  color: Color(0xFFB3B3B3),
                  fontSize: 15.0,
                ),
              ),
              const SizedBox(width: 0.0),
              Checkbox(
                value: widget.campsite.powerAccess,
                onChanged: (value) {
                  // Handle the checkbox change
                },
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          const Text(
            'รูปภาพสถานที่ 📷',
            style: TextStyle(
              color: Color(0xFFFFFFFF),
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          if (widget.campsite.campimage.isEmpty)
            const Text(
              'ไม่พบข้อมูล',
              style: TextStyle(
                color: Color(0xFFB3B3B3),
                fontSize: 15.0,
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.campsite.campimage.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: _isImageExpanded ? 400 : 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      image: DecorationImage(
                        image: AssetImage(widget.campsite.campimage[index]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            )
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFF121212),
        shape: const CircularNotchedRectangle(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon:
                    const Icon(Icons.warning_outlined, color: Colors.redAccent),
                onPressed: showWarningDialog,
              ),
              const Spacer(), // Spacer for spacing
              FloatingActionButton.extended(
                onPressed: () {
                  // Navigate to "Pack Your Bags" screen
                  _navigateToPackYourBags(widget.campsite);
                },
                icon: const Icon(Icons.shopping_bag, color: Color(0xFFFFFFFF)),
                label: const Text(
                  'เตรียมความพร้อม',
                  style: TextStyle(
                    color: Color(0xFFFFFFFF),
                  ),
                ),
                backgroundColor: kSpotifyAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.0),
                ),
              ),
              const Spacer(), // Spacer for spacing
              IconButton(
                icon: const Icon(Icons.send, color: Color(0xFFFFFFFF)),
                onPressed: () {
                  _navigateToMap(widget.campsite);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
