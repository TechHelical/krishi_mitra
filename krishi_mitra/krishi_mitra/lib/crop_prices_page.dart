import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:krishi_mitra/demand_trend_page.dart';
import 'package:krishi_mitra/price_trend_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CropPricesPage extends StatefulWidget {
  final String selectedState;

  const CropPricesPage({super.key, required this.selectedState});

  @override
  State<CropPricesPage> createState() => _CropPricesPageState();
}

class _CropPricesPageState extends State<CropPricesPage> {
  String? selectedState;
  bool showCrops = true; // To toggle between Crops and Demand tabs
  bool isLoading = false;

  final List<String> states = [
    "Andhra Pradesh",
    "Bihar",
    "Chhattisgarh",
    "Delhi",
    "Goa",
    "Gujarat",
    "Haryana",
    "Jharkhand",
    "Karnataka",
    "Kerala",
    "Madhya Pradesh",
    "Maharashtra",
    "Odisha",
    "Punjab",
    "Rajasthan",
    "Tamil Nadu",
    "Telangana",
    "Uttar Pradesh",
    "Uttarakhand",
    "West Bengal",
  ];

  List<Map<String, dynamic>> cropsCollectionData = []; // Dynamically populated
  List<Map<String, dynamic>> demandData = [];

  @override
  void initState() {
    super.initState();
    selectedState = widget.selectedState;
    _fetchCropData();
  }

  // Function to fetch crops data from the Python API
  Future<List<Map<String, dynamic>>> fetchCropsData(String selectedState, String previousMonth, String nextMonth,) async {
    final apiUrl =
        'http://127.0.0.1:8080/cropsCollection'; // Replace with your Flask API URL

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'selectedState': selectedState,
        'previousMonth': previousMonth,
        'nextMonth': nextMonth,
      }),
    );

    if (response.statusCode == 200) {
      final List<dynamic> cropsData = jsonDecode(response.body)['crops'];
      return cropsData.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to fetch crops data: ${response.body}');
    }
  }

  // Function to calculate percentage change and determine if the change is positive
  List<Map<String, dynamic>> processCropsData(List<Map<String, dynamic>> cropsData) {
    List<Map<String, dynamic>> processedCrops = [];

    for (final crop in cropsData) {
      final double previousMonthPrice = crop['previousMonthPrice'].toDouble();
      final double nextMonthPrice = crop['nextMonthPrice'].toDouble();

      // Calculate percentage change
      final change = (nextMonthPrice - previousMonthPrice) / previousMonthPrice * 100;
      final isPositive = nextMonthPrice >= previousMonthPrice;

      processedCrops.add({
        'name': crop['name'],
        'previousMonthPrice': previousMonthPrice.round(),
        'nextMonthPrice': nextMonthPrice.round(),
        'change': change.round(),
        'positive': isPositive,
      });
    }

    return processedCrops;
  }

  // Function to calculate percentage change and determine if the change is positive
  List<Map<String, dynamic>> processCropsDemandData(List<Map<String, dynamic>> cropsData) {
    List<Map<String, dynamic>> processedCrops = [];

    for (final crop in cropsData) {
      final double previousMonthDemand = crop['previousMonthDemand'].toDouble();
      final double nextMonthDemand = crop['nextMonthDemand'].toDouble();

      // Calculate percentage change
      final change = (nextMonthDemand - previousMonthDemand) / previousMonthDemand * 100;
      final isPositive = nextMonthDemand >= previousMonthDemand;

      processedCrops.add({
        'name': crop['name'],
        'previousMonthDemand': previousMonthDemand.round(),
        'nextMonthDemand': nextMonthDemand.round(),
        'change': change.round(),
        'positive': isPositive,
      });
    }

    return processedCrops;
  }

  Future<void> _fetchCropData() async {
    setState(() {
      isLoading = true; // Set loading state to true
    });

    if (selectedState == null) return;

    try {
      final state = selectedState!;
      // final state = 'Maharashtra';
      // final previousMonth = '01-2023';
      // final nextMonth = '02-2023';
      final now = DateTime.now();
      final DateFormat formatter = DateFormat('MM-yyyy'); // Format as MM-YYYY
      final DateTime previousMonthDate = DateTime(now.year, now.month - 1);
      final DateTime nextMonthDate = DateTime(now.year, now.month + 1);
      final previousMonth = formatter.format(previousMonthDate);
      final nextMonth = formatter.format(nextMonthDate);
      // print(previousMonth);
      // print(nextMonth);

      // Fetch crops data from the API
      final cropsData = await fetchCropsData(state, previousMonth, nextMonth);

      // Process the fetched crops data
      final processedCrops = processCropsData(cropsData);
      final processedDemand = processCropsDemandData(cropsData);

      // Add processed crops data to the existing list
      // cropsCollectionData.addAll(processedCrops);
      setState(() {
        cropsCollectionData = processedCrops;
        demandData = processedDemand;
        isLoading = false; // Set loading state to false
      });

      // Print the updated crops list
      for (final crop in cropsCollectionData) {
        print(crop);
      }
      for (final crop in demandData) {
        print(crop);
      }
    } catch (e) {
      print('Error fetching crop data: $e');
      setState(() {
        isLoading = false; // Set loading state to false
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Krishi Mitra", style: TextStyle(color: Colors.green[900])),
        backgroundColor: Colors.lightGreen[100],
        elevation: 0,
      ),
      backgroundColor: Colors.lightGreen[100],
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 10),

            // Dropdown for selecting state
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.brown[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.black),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedState,
                  isExpanded: true,
                  onChanged: (newValue) {
                    setState(() {
                      selectedState = newValue;
                      _fetchCropData(); // Fetch data when the selected state changes
                    });
                  },
                  items:
                      states.map((state) {
                        return DropdownMenuItem(
                          value: state,
                          child: Text(state),
                        );
                      }).toList(),
                ),
              ),
            ),

            SizedBox(height: 20),

            // Tabs for Crops and Demand
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     GestureDetector(
            //       onTap: () => setState(() => showCrops = true),
            //       child: Container(
            //         padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Reduced padding
            //         margin: EdgeInsets.symmetric(horizontal: 5), // Space between buttons
            //         decoration: BoxDecoration(
            //           color: showCrops ? Colors.green[700] : Colors.green[200], // Highlight & hint color
            //           borderRadius: BorderRadius.circular(12), // Rounded shape
            //         ),
            //         child: Text(
            //           "Crops",
            //           style: TextStyle(
            //             color: showCrops ? Colors.white : Colors.green[900], // Text color change
            //             fontSize: 16,
            //             fontWeight: FontWeight.bold,
            //           ),
            //         ),
            //       ),
            //     ),
            //     GestureDetector(
            //       onTap: () => setState(() => showCrops = false),
            //       child: Container(
            //         padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            //         margin: EdgeInsets.symmetric(horizontal: 5),
            //         decoration: BoxDecoration(
            //           color: !showCrops ? Colors.green[700] : Colors.green[200],
            //           borderRadius: BorderRadius.circular(12),
            //         ),
            //         child: Text(
            //           "Demand",
            //           style: TextStyle(
            //             color: !showCrops ? Colors.white : Colors.green[900],
            //             fontSize: 16,
            //             fontWeight: FontWeight.bold,
            //           ),
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            Container(
              decoration: BoxDecoration(
                color:
                    Colors.brown[50], // Light background to hint as a tab bar
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => showCrops = true),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color:
                              showCrops ? Colors.green[600] : Colors.green[100],
                          borderRadius: BorderRadius.horizontal(
                            left: Radius.circular(10),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "Crops",
                          style: TextStyle(
                            color: showCrops ? Colors.white : Colors.green[900],
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => showCrops = false),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color:
                              !showCrops
                                  ? Colors.green[600]
                                  : Colors.green[100],
                          borderRadius: BorderRadius.horizontal(
                            right: Radius.circular(10),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "Demand",
                          style: TextStyle(
                            color:
                                !showCrops ? Colors.white : Colors.green[900],
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // Loading Indicator or List View
            Expanded(
              child:
                  isLoading
                      ? Center(
                        child: CircularProgressIndicator(),
                      ) // Show loading indicator
                      : showCrops
                      ? ListView.builder(
                        itemCount: cropsCollectionData.length,
                        itemBuilder: (context, index) {
                          final crop = cropsCollectionData[index];
                          return CropCard(
                            name: crop["name"],
                            previousMonthPrice: crop["previousMonthPrice"],
                            nextMonthPrice: crop["nextMonthPrice"],
                            change: crop["change"],
                            isPositive: crop["positive"],
                            state: selectedState!,
                          );
                        },
                      )
                      : ListView.builder(
                        itemCount: demandData.length,
                        itemBuilder: (context, index) {
                          final crop = demandData[index];
                          return DemandCard(
                            state: selectedState!,
                            name: crop["name"],
                            previousMonthDemand: crop["previousMonthDemand"],
                            nextMonthDemand: crop["nextMonthDemand"],
                            change: crop["change"],
                            isPositive: crop["positive"],
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}

// Crop Card Widget
class CropCard extends StatelessWidget {
  final String state;
  final String name;
  final int previousMonthPrice;
  final int nextMonthPrice;
  final int change;
  final bool isPositive;

  const CropCard({
    super.key,
    required this.state,
    required this.name,
    required this.previousMonthPrice,
    required this.nextMonthPrice,
    required this.change,
    required this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PriceTrendPage(selectedState: state,cropName: name),
          ),
        );
      },
      child: Card(
        color: Colors.lightGreen[50],
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: Colors.black),
        ),
        margin: EdgeInsets.symmetric(vertical: 10),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "This Month : Rs. $previousMonthPrice",
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                  Text(
                    "Next Month : Rs. $nextMonthPrice",
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ],
              ),
              Column(
                children: [
                  Icon(
                    isPositive ? Icons.trending_up : Icons.trending_down,
                    color: isPositive ? Colors.green : Colors.red,
                  ),
                  Text(
                    "$change %",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isPositive ? Colors.green : Colors.red,
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

class DemandCard extends StatelessWidget {
  final String state;
  final String name;
  final int previousMonthDemand;
  final int nextMonthDemand;
  final int change;
  final bool isPositive;

  const DemandCard({
    super.key,
    required this.state,
    required this.name,
    required this.previousMonthDemand,
    required this.nextMonthDemand,
    required this.change,
    required this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DemandTrendPage(selectedState: state, cropName: name),
          ),
        );
      },
      child: Card(
        color: Colors.lightGreen[50],
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          // side: BorderSide(color: Colors.green[700]!),
          side: BorderSide(color: Colors.black),
        ),
        margin: EdgeInsets.symmetric(vertical: 10),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "This Month : $previousMonthDemand Q",
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                  Text(
                    "Next Month : $nextMonthDemand Q",
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ],
              ),
              Column(
                children: [
                  Icon(
                    isPositive ? Icons.trending_up : Icons.trending_down,
                    color: isPositive ? Colors.green : Colors.red,
                  ),
                  Text(
                    "$change %",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isPositive ? Colors.green : Colors.red,
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
