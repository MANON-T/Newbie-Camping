import 'package:flutter/material.dart';
import 'package:flutter_application_4/models/campsite_model.dart';
import 'package:flutter_application_4/screens/backpack_screen.dart';
import '../service/auth_service.dart';
import 'package:flutter_application_4/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

// Use Spotify color scheme
const kSpotifyBackground = Color(0xFF121212);
const kSpotifyAccent = Color(0xFF1DB954);
const kSpotifyTextPrimary = Color(0xFFFFFFFF);
const kSpotifyTextSecondary = Color(0xFFB3B3B3);
const kSpotifyHighlight = Color(0xFF282828);

class PackYourBags extends StatefulWidget {
  final CampsiteModel campsite;
  final AuthService auth;
  final UserModel? user;
  final String? Exp;
  final bool isAnonymous;

  const PackYourBags(
      {super.key,
      required this.campsite,
      required this.auth,
      required this.user,
      required this.Exp,
      required this.isAnonymous});

  @override
  _PackYourBagsState createState() => _PackYourBagsState();
}

class _PackYourBagsState extends State<PackYourBags> {
  // Add counters for adults, children, cars, tents, and houses
  int _adultCount = 0;
  int _childrenCount = 0;
  int _carCount = 0;
  bool _campingChecked = false;
  bool _houseChecked = false;
  bool _rentTentChecked = false;
  String? _tentSize;
  String? _houseSize;
  int _nightCount = 1;

  Future<void> _saveBudget(
      String campsiteName,
      double totalCost,
      double enterFee,
      double tentRental,
      double house,
      double campingFee) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('user')
            .doc(user.uid)
            .update({
          'campsite': campsiteName,
          'totalCost': totalCost,
          'enterFee': enterFee,
          'tentRental': tentRental,
          'house': house,
          'campingFee': campingFee
        });

        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text('บันทึกข้อมูลค่าใช้จ่ายสำเร็จ: $campsiteName'),
        //     backgroundColor: Colors.green,
        //   ),
        // );
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

  final List<String> _tentSizes = [
    "แบบเล็ก (2 คน)",
    "แบบกลาง (4 คน)",
    "แบบใหญ่ (6 คน)"
  ];
  final List<String> _houseSizes = [
    "แบบเล็ก (2-3 คน)",
    "แบบกลาง (4-6 คน)",
    "แบบใหญ่ (8-10 คน)"
  ];

  void _increment(int type) {
    setState(() {
      if (type == 1) {
        _adultCount++;
      } else if (type == 2) {
        _childrenCount++;
      } else if (type == 3) {
        _carCount++;
      } else if (type == 4) {
        _nightCount++;
      }
    });
  }

  void _decrement(int type) {
    setState(() {
      if (type == 1 && _adultCount > 0) {
        _adultCount--;
      } else if (type == 2 && _childrenCount > 0) {
        _childrenCount--;
      } else if (type == 3 && _carCount > 0) {
        _carCount--;
      } else if (type == 4 && _nightCount > 1) {
        _nightCount--;
      }
    });
  }

  Widget _buildCounter(String label, int count, int type) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: kSpotifyTextPrimary,
              fontSize: 18.0,
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove, color: kSpotifyAccent),
                onPressed: () => _decrement(type),
              ),
              Text(
                '$count',
                style: const TextStyle(
                  color: kSpotifyTextPrimary,
                  fontSize: 18.0,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add, color: kSpotifyAccent),
                onPressed: () => _increment(type),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getDetailsText(int type) {
    switch (type) {
      case 1:
        return 'ค่าบริการต่อผู้ใหญ่: ${widget.campsite.adultEntryFee} บาท';
      case 2:
        return 'ค่าบริการต่อเด็ก: ${widget.campsite.childEntryFee} บาท';
      case 3:
        return 'ค่าบริการต่อรถยนต์: ${widget.campsite.parkingFee} บาท';
      default:
        return '';
    }
  }

  double _enterFeeCalculate() {
    return (_adultCount * widget.campsite.adultEntryFee) +
        (_childrenCount * widget.campsite.childEntryFee) +
        (_carCount * widget.campsite.parkingFee);
  }

  double _calculateTentRentalCost() {
    if (!_campingChecked || !_rentTentChecked || _tentSize == null) return 0.0;

    switch (_tentSize) {
      case "แบบเล็ก (2 คน)":
        return widget.campsite.tent_rental[0] * _nightCount;
      case "แบบกลาง (4 คน)":
        return widget.campsite.tent_rental[1] * _nightCount;
      case "แบบใหญ่ (6 คน)":
        return widget.campsite.tent_rental[2] * _nightCount;
      default:
        return 0.0;
    }
  }

  double _calculateHouseCost() {
    if (!_houseChecked || _houseSize == null) return 0.0;

    switch (_houseSize) {
      case "แบบเล็ก (2-3 คน)":
        return widget.campsite.house[0] * _nightCount;
      case "แบบกลาง (4-6 คน)":
        return widget.campsite.house[1] * _nightCount;
      case "แบบใหญ่ (8-10 คน)":
        return widget.campsite.house[2] * _nightCount;
      default:
        return 0.0;
    }
  }

  double _calculateCampingFee() {
    return _campingChecked ? widget.campsite.campingFee * _nightCount : 0.0;
  }

  double _calculateTotalCost() {
    return _enterFeeCalculate() +
        _calculateTentRentalCost() +
        _calculateHouseCost() +
        _calculateCampingFee();
  }

  @override
  Widget build(BuildContext context) {
    // Filter tent rental and house costs that are not zero
    final availableTentSizes = _tentSizes
        .asMap()
        .entries
        .where((entry) => widget.campsite.tent_rental[entry.key] != 0)
        .map((entry) => entry.value)
        .toList();

    final availableHouseSizes = _houseSizes
        .asMap()
        .entries
        .where((entry) => widget.campsite.house[entry.key] != 0)
        .map((entry) => entry.value)
        .toList();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: kSpotifyBackground,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kSpotifyTextPrimary),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: kSpotifyBackground,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "คำนวนค่าใช้จ่าย",
              style: TextStyle(
                color: kSpotifyTextPrimary,
                fontSize: 18.0,
              ),
            ),
            Text(
              'รวม: ${_calculateTotalCost().toStringAsFixed(2)} บาท',
              style: const TextStyle(
                color: kSpotifyTextPrimary,
                fontSize: 16.0,
              ),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                color: kSpotifyHighlight,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: const BorderSide(color: kSpotifyAccent, width: 1.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Text(
                            'ค่าเข้า ',
                            style: TextStyle(
                              color: kSpotifyTextPrimary,
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '💰',
                            style: TextStyle(
                              fontSize: 24.0,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        _getDetailsText(1), // "ค่าบริการต่อผู้ใหญ่"
                        style: const TextStyle(
                          color: kSpotifyTextSecondary,
                          fontSize: 14.0,
                        ),
                      ),
                      Text(
                        _getDetailsText(2), // "ค่าบริการต่อเด็ก"
                        style: const TextStyle(
                          color: kSpotifyTextSecondary,
                          fontSize: 14.0,
                        ),
                      ),
                      Text(
                        _getDetailsText(3), // "ค่าบริการต่อรถยนต์"
                        style: const TextStyle(
                          color: kSpotifyTextSecondary,
                          fontSize: 14.0,
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      const Divider(color: kSpotifyTextSecondary),
                      _buildCounter("ผู้ใหญ่", _adultCount, 1),
                      _buildCounter("เด็ก", _childrenCount, 2),
                      _buildCounter("รถยนต์", _carCount, 3),
                      const SizedBox(height: 20.0),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: kSpotifyHighlight,
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(color: kSpotifyAccent),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'จำนวนคืน',
                              style: TextStyle(
                                color: kSpotifyTextPrimary,
                                fontSize: 18.0,
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove,
                                      color: kSpotifyAccent),
                                  onPressed: () => _decrement(4),
                                ),
                                Text(
                                  '$_nightCount คืน',
                                  style: const TextStyle(
                                    color: kSpotifyTextPrimary,
                                    fontSize: 18.0,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add,
                                      color: kSpotifyAccent),
                                  onPressed: () => _increment(4),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Card(
                color: kSpotifyHighlight,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: const BorderSide(color: kSpotifyAccent, width: 1.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Text(
                            'ค่าที่พัก ',
                            style: TextStyle(
                              color: kSpotifyTextPrimary,
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '🏕️',
                            style: TextStyle(
                              fontSize: 24.0,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        'ค่าบริการกางเต็นท์: ${widget.campsite.campingFee} บาท/คืน',
                        style: const TextStyle(
                          color: kSpotifyTextSecondary,
                          fontSize: 14.0,
                        ),
                      ),
                      Text(
                        'เช่าเต็นท์: ${widget.campsite.tentService ? "ให้บริการ" : "ไม่มีบริการ"}',
                        style: const TextStyle(
                          color: kSpotifyTextSecondary,
                          fontSize: 14.0,
                        ),
                      ),
                      Text(
                        'บ้านพัก: ${widget.campsite.accommodationAvailable ? "ให้บริการ" : "ไม่มีบริการ"}',
                        style: const TextStyle(
                          color: kSpotifyTextSecondary,
                          fontSize: 14.0,
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      const Divider(color: kSpotifyTextSecondary),
                      CheckboxListTile(
                        title: const Text(
                          'ตั้งแคมป์',
                          style: TextStyle(
                            color: kSpotifyTextPrimary,
                            fontSize: 18.0,
                          ),
                        ),
                        value: _campingChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            _campingChecked = value ?? false;
                            if (!_campingChecked) {
                              _rentTentChecked = false;
                              _tentSize = null;
                            }
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                        activeColor: kSpotifyAccent,
                      ),
                      if (_campingChecked)
                        CheckboxListTile(
                          title: const Text(
                            'ต้องการเช่าเต็นท์',
                            style: TextStyle(
                              color: kSpotifyTextPrimary,
                              fontSize: 18.0,
                            ),
                          ),
                          value: _rentTentChecked,
                          onChanged: _campingChecked
                              ? (bool? value) {
                                  setState(() {
                                    _rentTentChecked = value ?? false;
                                    if (!_rentTentChecked) {
                                      _tentSize = null;
                                    }
                                  });
                                }
                              : null,
                          controlAffinity: ListTileControlAffinity.leading,
                          activeColor: kSpotifyAccent,
                        ),
                      if (_campingChecked &&
                          _rentTentChecked &&
                          widget.campsite.tentService)
                        DropdownButton<String>(
                          value: _tentSize,
                          onChanged: (String? newValue) {
                            setState(() {
                              _tentSize = newValue;
                            });
                          },
                          hint: const Text(
                            "เลือกขนาดเต็นท์",
                            style: TextStyle(
                              color: kSpotifyTextSecondary,
                              fontSize: 16.0,
                            ),
                          ),
                          items: availableTentSizes.map((String size) {
                            return DropdownMenuItem<String>(
                              value: size,
                              child: Text(
                                size,
                                style:
                                    const TextStyle(color: kSpotifyTextPrimary),
                              ),
                            );
                          }).toList(),
                          dropdownColor: kSpotifyHighlight,
                          iconEnabledColor: kSpotifyAccent,
                        ),
                      CheckboxListTile(
                        title: const Text(
                          'บ้านพัก',
                          style: TextStyle(
                            color: kSpotifyTextPrimary,
                            fontSize: 18.0,
                          ),
                        ),
                        value: _houseChecked,
                        onChanged: widget.campsite.accommodationAvailable
                            ? (value) {
                                setState(() {
                                  _houseChecked = value ?? false;
                                });
                              }
                            : null,
                        controlAffinity: ListTileControlAffinity.leading,
                        activeColor: kSpotifyAccent,
                      ),
                      if (_houseChecked &&
                          widget.campsite.accommodationAvailable)
                        DropdownButton<String>(
                          value: _houseSize,
                          onChanged: (String? newValue) {
                            setState(() {
                              _houseSize = newValue;
                            });
                          },
                          hint: const Text(
                            "เลือกขนาดบ้าน",
                            style: TextStyle(
                              color: kSpotifyTextSecondary,
                              fontSize: 16.0,
                            ),
                          ),
                          items: availableHouseSizes.map((String size) {
                            return DropdownMenuItem<String>(
                              value: size,
                              child: Text(
                                size,
                                style:
                                    const TextStyle(color: kSpotifyTextPrimary),
                              ),
                            );
                          }).toList(),
                          dropdownColor: kSpotifyHighlight,
                          iconEnabledColor: kSpotifyAccent,
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Card(
                color: kSpotifyHighlight,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: const BorderSide(color: kSpotifyAccent, width: 1.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Text(
                            'รายละเอียด ',
                            style: TextStyle(
                              color: kSpotifyTextPrimary,
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '📝',
                            style: TextStyle(
                              fontSize: 24.0,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        'จำนวนผู้ใหญ่: $_adultCount คน',
                        style: const TextStyle(
                          color: kSpotifyTextSecondary,
                          fontSize: 16.0,
                        ),
                      ),
                      Text(
                        'จำนวนเด็ก: $_childrenCount คน',
                        style: const TextStyle(
                          color: kSpotifyTextSecondary,
                          fontSize: 16.0,
                        ),
                      ),
                      Text(
                        'จำนวนรถยนต์: $_carCount คัน',
                        style: const TextStyle(
                          color: kSpotifyTextSecondary,
                          fontSize: 16.0,
                        ),
                      ),
                      const Divider(color: kSpotifyTextSecondary),
                      Text(
                        'จำนวนคืน: $_nightCount คืน',
                        style: const TextStyle(
                          color: kSpotifyTextSecondary,
                          fontSize: 16.0,
                        ),
                      ),
                      if (_campingChecked)
                        Text(
                          'กางเต็นท์: ${widget.campsite.campingFee * _nightCount} บาท',
                          style: const TextStyle(
                            color: kSpotifyTextSecondary,
                            fontSize: 16.0,
                          ),
                        ),
                      if (_campingChecked &&
                          _rentTentChecked &&
                          _tentSize != null)
                        Text(
                          'เช่าเต็นท์ ($_tentSize): ${_calculateTentRentalCost().toStringAsFixed(2)} บาท',
                          style: const TextStyle(
                            color: kSpotifyTextSecondary,
                            fontSize: 16.0,
                          ),
                        ),
                      if (_houseChecked && _houseSize != null)
                        Text(
                          'เช่าบ้าน ($_houseSize): ${_calculateHouseCost().toStringAsFixed(2)} บาท',
                          style: const TextStyle(
                            color: kSpotifyTextSecondary,
                            fontSize: 16.0,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              if (!widget.isAnonymous)
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      _saveBudget(
                          widget.campsite.name,
                          _calculateTotalCost(),
                          _enterFeeCalculate(),
                          _calculateTentRentalCost(),
                          _calculateHouseCost(),
                          _calculateCampingFee());
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Backpack(
                                  Exp: widget.Exp,
                                  totalCost: _calculateTotalCost(),
                                  enterFee: _enterFeeCalculate(),
                                  tentRental: _calculateTentRentalCost(),
                                  house: _calculateHouseCost(),
                                  campingFee: _calculateCampingFee(),
                                  campsite: widget.campsite,
                                  auth: widget.auth,
                                  user: widget.user,
                                )),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          kSpotifyAccent, // เปลี่ยนสีพื้นหลังของปุ่มเป็นสีเขียว
                    ),
                    child: const Text(
                      'จัดสัมภาระ',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
