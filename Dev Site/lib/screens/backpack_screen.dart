import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_4/models/campsite_model.dart';
import 'package:flutter_application_4/models/user_model.dart';
import 'package:flutter_application_4/screens/home_screen.dart';
import 'package:flutter_application_4/service/auth_service.dart';
import 'package:flutter_application_4/service/database.dart';

// Use Spotify color scheme
const kSpotifyBackground = Color(0xFF121212);
const kSpotifyAccent = Color(0xFF1DB954);
const kSpotifyTextPrimary = Color(0xFFFFFFFF);
const kSpotifyTextSecondary = Color(0xFFB3B3B3);
const kSpotifyHighlight = Color(0xFF282828);

class Backpack extends StatefulWidget {
  final double totalCost;
  final double enterFee;
  final double tentRental;
  final double house;
  final String? Exp;
  final double campingFee;
  final AuthService auth;
  final UserModel? user;
  final CampsiteModel campsite;

  const Backpack({
    super.key,
    required this.totalCost,
    required this.campsite,
    required this.enterFee,
    required this.tentRental,
    required this.house,
    required this.Exp,
    required this.campingFee,
    required this.auth,
    required this.user,
  });

  @override
  State<Backpack> createState() => _BackpackState();
}

class _BackpackState extends State<Backpack> {
  Database db = Database.instance;

  Future<void> _saveBackpack(String message) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('user')
            .doc(user.uid)
            .update({'backpack': message});

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('บันทึกข้อมูลสำเร็จ: $message'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('ไม่พบผู้ใช้'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('เกิดข้อผิดพลาดในการบันทึกข้อมูล: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSpotifyBackground,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kSpotifyTextPrimary),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'จัดสัมภาระ',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: kSpotifyBackground,
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              itemCount: 3,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(
                    top: 50.0,
                    bottom: 16.0,
                    left: 16.0,
                    right: 16.0,
                  ),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                      side: BorderSide(
                        color: index == 0 ? Colors.orange : Colors.blue,
                        width: 2.0,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16.0),
                      child: index == 0
                          ? Container(
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                      'images/Autumn-Orange-Background-for-Desktop.jpg'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.5),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      child: Text(
                                        'สำหรับมือใหม่',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall
                                            ?.copyWith(color: Colors.black),
                                      ),
                                    ),
                                    const SizedBox(height: 8.0),
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.all(8.0),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.5),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        child: ListView.builder(
                                          padding: EdgeInsets.zero,
                                          itemCount: widget
                                              .campsite.newbie_backpack.length,
                                          itemBuilder: (context, itemIndex) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 2.0),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Icon(
                                                    Icons.brightness_1,
                                                    size: 8,
                                                    color: Colors.black,
                                                  ),
                                                  const SizedBox(width: 4.0),
                                                  Expanded(
                                                    child: Text(
                                                      widget.campsite
                                                              .newbie_backpack[
                                                          itemIndex],
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium
                                                          ?.copyWith(
                                                              color:
                                                                  Colors.black),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16.0),
                                    ElevatedButton(
                                      onPressed: () {
                                        String message;
                                        if (index == 0) {
                                          message = "สำหรับมือใหม่";
                                        } else if (index == 1) {
                                          message = "สำหรับทั่วไป แบบ 1";
                                        } else {
                                          message = "สำหรับทั่วไป แบบ 2";
                                        }

                                        _saveBackpack(
                                            message); // บันทึกข้อมูลไปที่ Firebase

                                        // ตรวจสอบค่า Exp ก่อนส่งไปยัง HomeScreen
                                        String? expValue = widget.Exp;
                                        print(
                                            'Exp value before sending to HomeScreen: $expValue');

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => HomeScreen(
                                              auth: widget.auth,
                                              user: widget.user,
                                              Exp: expValue,
                                              totalCost: widget.totalCost,
                                              enterFee: widget.enterFee,
                                              tentRental: widget.tentRental,
                                              house: widget.house,
                                              campingFee: widget.campingFee,
                                              message: message,
                                              barindex: 3,
                                              campsite: widget.campsite,
                                            ),
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        'ยืนยัน',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          : Container(
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                      'images/artwork-digital-art-sky-clouds-hd-wallpaper-preview.jpg'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.5),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      child: Text(
                                        index == 1
                                            ? 'สำหรับทั่วไป แบบ 1'
                                            : 'สำหรับทั่วไป แบบ 2',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall
                                            ?.copyWith(color: Colors.black),
                                      ),
                                    ),
                                    const SizedBox(height: 8.0),
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.all(8.0),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.5),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        child: ListView.builder(
                                          padding: EdgeInsets.zero,
                                          itemCount: index == 1
                                              ? widget.campsite.common_backpack1
                                                  .length
                                              : widget.campsite.common_backpack2
                                                  .length,
                                          itemBuilder: (context, itemIndex) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 2.0),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Icon(Icons.brightness_1,
                                                      size: 8,
                                                      color: Colors.black),
                                                  const SizedBox(width: 4.0),
                                                  Expanded(
                                                    child: Text(
                                                      index == 1
                                                          ? widget.campsite
                                                                  .common_backpack1[
                                                              itemIndex]
                                                          : widget.campsite
                                                                  .common_backpack2[
                                                              itemIndex],
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium
                                                          ?.copyWith(
                                                              color:
                                                                  Colors.black),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16.0),
                                    ElevatedButton(
                                      onPressed: () {
                                        String message;
                                        if (index == 0) {
                                          message = "สำหรับมือใหม่";
                                        } else if (index == 1) {
                                          message = "สำหรับทั่วไป แบบ 1";
                                        } else {
                                          message = "สำหรับทั่วไป แบบ 2";
                                        }

                                        _saveBackpack(
                                            message); // บันทึกข้อมูลไปที่ Firebase

                                        // ตรวจสอบค่า Exp ก่อนส่งไปยัง HomeScreen
                                        String? expValue = widget.Exp;
                                        print(
                                            'Exp value before sending to HomeScreen: $expValue');

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => HomeScreen(
                                              auth: widget.auth,
                                              user: widget.user,
                                              Exp: expValue,
                                              totalCost: widget.totalCost,
                                              enterFee: widget.enterFee,
                                              tentRental: widget.tentRental,
                                              house: widget.house,
                                              campingFee: widget.campingFee,
                                              message: message,
                                              barindex: 3,
                                              campsite: widget.campsite,
                                            ),
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        'ยืนยัน',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
                side: const BorderSide(
                  color: Colors.green,
                  width: 2.0,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.black,
                  ),
                  height: 200, // กำหนดความสูงให้กับ Card นี้
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'ตราปั๋มที่ปลดล๊อก',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(color: Colors.white),
                        ),
                      ),
                      Center(
                        child: Image.asset(
                          'images/gear.png',
                          fit: BoxFit.cover,
                          height: 100, // กำหนดความสูงให้กับรูปภาพ
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
