import 'package:flutter/material.dart';
import 'package:krishi_mitra/select_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F3E4),
      appBar: AppBar(
        backgroundColor: Colors.green[900],
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15.0), // Half of the assumed width/height (30/2 = 15)
            child: Image.asset(
              'app_icon.png', // Replace with your actual app icon path
              width: 30,
              height: 30,
              fit: BoxFit.cover, // Important to maintain aspect ratio and fill the circle
            ),
          ),
        ),
        title: const Text("Krishi Mitra", style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              // Navigate to settings page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          children: <Widget>[
            _buildHomeTile(
              context: context,
              title: "Crop Price",
              icon: Icons.info_outline,
              onTap: () {
                // Navigate to Crop Information page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      // builder: (context) => const CropInfoScreen()),
                    builder: (context) => const SelectStateScreen(function: "cropPrice")),
                );
              },
            ),
            _buildHomeTile(
              context: context,
              title: "Crop Demand",
              icon: Icons.store,
              onTap: () {
                // Navigate to Market Prices page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      // builder: (context) => const MarketPricesScreen()),
                      builder: (context) => const SelectStateScreen(function: "cropDemand")),
                );
              },
            ),
            _buildHomeTile(
              context: context,
              title: "Weather Forecast",
              icon: Icons.cloud,
              onTap: () {
                // Navigate to Weather Forecast page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      // builder: (context) => const WeatherForecastScreen()),
                      builder: (context) => const SelectStateScreen(function: "weatherForecast")),
                );
              },
            ),
            _buildHomeTile(
              context: context,
              title: "Pest & Disease Detection",
              icon: Icons.bug_report,
              onTap: () {
                // Navigate to Pest & Disease Detection page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      // builder: (context) => const PestDetectionScreen()),
                      builder: (context) => const SelectStateScreen(function: "disease")),
                );
              },
            ),
            // Add more tiles as needed
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildHomeTile({
    required BuildContext context,
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              size: 40.0,
              color: Colors.green[900],
            ),
            const SizedBox(height: 10.0),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.green[900],
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white70,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.smart_toy), label: "Chat Bot"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Me"),
      ],
      onTap: (index) {
        if (index == 0) {
          // Already on Home Screen
        } else if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ChatBotScreen()),
          );
        } else if (index == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProfileScreen()),
          );
        }
      },
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: Colors.green[900],
      ),
      body: const Center(
        child: Text("Settings Page Content"),
      ),
    );
  }
}

class CropInfoScreen extends StatelessWidget {
  const CropInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Crop Information"),
        backgroundColor: Colors.green[900],
      ),
      body: const Center(
        child: Text("Crop Information Page Content"),
      ),
    );
  }
}

class MarketPricesScreen extends StatelessWidget {
  const MarketPricesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Market Prices"),
        backgroundColor: Colors.green[900],
      ),
      body: const Center(
        child: Text("Market Prices Page Content"),
      ),
    );
  }
}

class WeatherForecastScreen extends StatelessWidget {
  const WeatherForecastScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Weather Forecast"),
        backgroundColor: Colors.green[900],
      ),
      body: const Center(
        child: Text("Weather Forecast Page Content"),
      ),
    );
  }
}

class PestDetectionScreen extends StatelessWidget {
  const PestDetectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pest & Disease Detection"),
        backgroundColor: Colors.green[900],
      ),
      body: const Center(
        child: Text("Pest & Disease Detection Page Content"),
      ),
    );
  }
}

class ChatBotScreen extends StatelessWidget {
  const ChatBotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat Bot"),
        backgroundColor: Colors.green[900],
      ),
      body: const Center(
        child: Text("Chat Bot Page Content"),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.green[900],
      ),
      body: const Center(
        child: Text("Profile Page Content"),
      ),
    );
  }
}