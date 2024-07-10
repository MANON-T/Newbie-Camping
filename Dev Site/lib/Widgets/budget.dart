import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../service/auth_service.dart';
import 'package:flutter_application_4/models/campsite_model.dart';

class Budget extends StatefulWidget {
  final double totalCost;
  final double enterFee;
  final double tentRental;
  final double house;
  final double campingFee;
  final AuthService auth;
  final String user;
  final CampsiteModel? campsite;

  const Budget({
    super.key,
    required this.auth,
    required this.user,
    required this.campingFee,
    required this.house,
    required this.campsite,
    required this.enterFee,
    required this.tentRental,
    required this.totalCost,
  });

  @override
  State<Budget> createState() => _BudgetState();
}

class _BudgetState extends State<Budget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        color: Colors.black, // เปลี่ยนพื้นหลังเป็นสีดำ
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Campsite: ${widget.campsite?.name ?? 'Not selected'}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // สีของข้อความเป็นสีขาว
                ),
              ),
              const SizedBox(height: 20),
              AspectRatio(
                aspectRatio: 1.3,
                child: BarChart(
                  BarChartData(
                    barGroups: [
                      BarChartGroupData(
                        x: 0,
                        barRods: [
                          BarChartRodData(
                            toY: widget.totalCost,
                            color: Colors.blue,
                            width: 20,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ],
                        showingTooltipIndicators: [0],
                      ),
                      BarChartGroupData(
                        x: 1,
                        barRods: [
                          BarChartRodData(
                            toY: widget.enterFee,
                            color: Colors.orange,
                            width: 20,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ],
                        showingTooltipIndicators: [0],
                      ),
                      BarChartGroupData(
                        x: 2,
                        barRods: [
                          BarChartRodData(
                            toY: widget.tentRental,
                            color: Colors.green,
                            width: 20,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ],
                        showingTooltipIndicators: [0],
                      ),
                      BarChartGroupData(
                        x: 3,
                        barRods: [
                          BarChartRodData(
                            toY: widget.house,
                            color: Colors.red,
                            width: 20,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ],
                        showingTooltipIndicators: [0],
                      ),
                      BarChartGroupData(
                        x: 4,
                        barRods: [
                          BarChartRodData(
                            toY: widget.campingFee,
                            color: Colors.purple,
                            width: 20,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ],
                        showingTooltipIndicators: [0],
                      ),
                    ],
                    titlesData: const FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ค่าใช้จ่ายรวม: ฿${widget.totalCost.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.blue,
                    ),
                  ),
                  Text(
                    'ค่าเข้ารวม: ฿${widget.enterFee.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.orange,
                    ),
                  ),
                  Text(
                    'ค่าเช้าเต้นรวม: ฿${widget.tentRental.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.green,
                    ),
                  ),
                  Text(
                    'ค่าเช่าบ้านพักรวม: ฿${widget.house.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.red,
                    ),
                  ),
                  Text(
                    'ค่ากางเต้น: ฿${widget.campingFee.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.purple,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
