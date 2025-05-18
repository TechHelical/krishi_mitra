import 'package:flutter/material.dart';
import 'package:krishi_mitra/crop_prices_page.dart';
// import 'package:krishi_mitra/demand_trend_page.dart';

class SelectStateScreen extends StatefulWidget {
  final String function;
  const SelectStateScreen({super.key, required this.function});

  @override
  State<SelectStateScreen> createState() => _SelectStateScreenState();
}

class _SelectStateScreenState extends State<SelectStateScreen> {
  String? _selectedState;
  final List<String> _indianStates = [
    "Andhra Pradesh",
    "Arunachal Pradesh",
    "Assam",
    "Bihar",
    "Chhattisgarh",
    "Goa",
    "Gujarat",
    "Haryana",
    "Himachal Pradesh",
    "Jharkhand",
    "Karnataka",
    "Kerala",
    "Madhya Pradesh",
    "Maharashtra",
    "Manipur",
    "Meghalaya",
    "Mizoram",
    "Nagaland",
    "Odisha",
    "Punjab",
    "Rajasthan",
    "Sikkim",
    "Tamil Nadu",
    "Telangana",
    "Tripura",
    "Uttar Pradesh",
    "Uttarakhand",
    "West Bengal",
    // Add more states if needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F3E4),
      appBar: AppBar(
        backgroundColor: Colors.green[900],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Select State", style: TextStyle(color: Colors.white)),
        actions: const [
          Icon(Icons.my_location, color: Colors.white),
          SizedBox(width: 12),
          Icon(Icons.location_pin, color: Colors.white),
          SizedBox(width: 8),
        ],
      ),
      body: ListView.builder(
        itemCount: _indianStates.length,
        itemBuilder: (context, index) {
          final state = _indianStates[index];
          return ListTile(
            title: Text(state),
            onTap: () {
              setState(() {
                _selectedState = state;
              });
              _navigateToNextScreen(context, state, widget.function);
            },
            selected: _selectedState == state,
            selectedTileColor: Colors.green[100],
          );
        },
      ),
    );
  }

  void _navigateToNextScreen(BuildContext context, String selectedState, String functionName) {
    Widget nextPage;
    switch (functionName) {
      case "cropPrice":
        // nextPage = CropPriceScreen(selectedState: selectedState);
        nextPage = CropPricesPage(selectedState: selectedState);
        break;
      case "cropDemand":
        // nextPage = CropDemandScreen(selectedState: selectedState);
        nextPage = CropPricesPage(selectedState: selectedState);
        break;
      case "weatherForecast":
        nextPage = WeatherForecastScreen(selectedState: selectedState);
        break;
      case "disease":
        nextPage = PestDetectionScreen(selectedState: selectedState);
        break;
      default:
        nextPage = const Center(child: Text("Error: Unknown function"));
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => nextPage),
    );
  }
}

class CropPriceScreen extends StatelessWidget {
  final String selectedState;
  const CropPriceScreen({super.key, required this.selectedState});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Crop Price"),
        backgroundColor: Colors.green[900],
      ),
      body: Center(
        child: Text("Crop Price data for $selectedState will be shown here."),
      ),
    );
  }
}

class CropDemandScreen extends StatelessWidget {
  final String selectedState;
  const CropDemandScreen({super.key, required this.selectedState});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Crop Demand"),
        backgroundColor: Colors.green[900],
      ),
      body: Center(
        child: Text("Crop Demand data for $selectedState will be shown here."),
      ),
    );
  }
}

class WeatherForecastScreen extends StatelessWidget {
  final String selectedState;
  const WeatherForecastScreen({super.key, required this.selectedState});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Weather Forecast"),
        backgroundColor: Colors.green[900],
      ),
      body: Center(
        child: Text("Weather Forecast for $selectedState will be shown here."),
      ),
    );
  }
}

class PestDetectionScreen extends StatelessWidget {
  final String selectedState;
  const PestDetectionScreen({super.key, required this.selectedState});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pest & Disease Detection"),
        backgroundColor: Colors.green[900],
      ),
      body: Center(
        child: Text("Pest & Disease Detection for $selectedState will be shown here."),
      ),
    );
  }
}