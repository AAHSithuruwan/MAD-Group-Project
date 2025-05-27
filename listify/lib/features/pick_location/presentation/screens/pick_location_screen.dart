import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class PickLocationScreen extends StatefulWidget {
  @override
  _PickLocationScreenState createState() => _PickLocationScreenState();
}

class _PickLocationScreenState extends State<PickLocationScreen> {
  MapController mapController = MapController();

  final searchStoreController = TextEditingController();
  final searchCityController = TextEditingController();
  LatLng currentLatLng = LatLng(6.9271, 79.8612); // Default to Colombo

  final Map<String, LatLng> storeLocations = {
    "Cargills Colombo": LatLng(6.9271, 79.8612),
    "Keells Colombo": LatLng(6.9157, 79.8636),
    "Cargills Kalutara": LatLng(6.5836, 79.9607),
    "Keells Kalutara": LatLng(6.5767, 79.9601),
    "Cargills Horana": LatLng(6.7161, 80.0604),
    "Keells Horana": LatLng(6.7188, 80.0610),
    "Cargills Panadura": LatLng(6.7130, 79.9024),
    "Keells Panadura": LatLng(6.7095, 79.9031),
    "Cargills Nugegoda": LatLng(6.8720, 79.8891),
    "Keells Nugegoda": LatLng(6.8708, 79.8889),
    "Cargills Homagama": LatLng(6.8438, 80.0035),
    "Keells Homagama": LatLng(6.8445, 80.0040),
    "Cargills Kottawa": LatLng(6.8427, 79.9961),
    "Keells Kottawa": LatLng(6.8440, 79.9943),
  };

  final List<String> recentCities = [
    "Colombo",
    "Kalutara",
    "Horana",
    "Panadura",
    "Nugegoda",
    "Homagama",
    "Kottawa",
  ];

  void _searchLocation(String keyword) {
    if (storeLocations.containsKey(keyword)) {
      setState(() {
        currentLatLng = storeLocations[keyword]!;
      });
      mapController.move(currentLatLng, 15);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Store not found in the list")),
      );
    }
  }

  void _searchCity(String cityName) {
    final match = storeLocations.entries.firstWhere(
          (entry) => entry.key.toLowerCase().contains(cityName.toLowerCase()),
      orElse: () => MapEntry("", LatLng(6.9271, 79.8612)),
    );
    if (match.key != "") {
      setState(() {
        currentLatLng = match.value;
      });
      mapController.move(currentLatLng, 13);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("City not found")),
      );
    }
  }

  Widget buildSearchBar({
    required String hintText,
    required TextEditingController controller,
    required void Function(String) onSubmitted,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white, // Background color
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.black.withOpacity(0.3), // Thin black border
          width: 1,
        ),
      ),
      child: TextField(
        controller: controller,
        onSubmitted: onSubmitted,
        style: TextStyle(color: Colors.black.withOpacity(0.7)), // Input text opacity
        decoration: InputDecoration(
          icon: Icon(Icons.search, color: Colors.black.withOpacity(0.5)), // Icon opacity
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.black.withOpacity(0.5)), // Hint opacity
        ),
      ),
    );
  }


  Widget buildRecentTabs(List<String> items, void Function(String) onTap) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;

          final isFirst = index == 0;

          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
              onTap: () => onTap(item),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: isFirst
                      ? Color(0x261BA424) // 15% opacity of 1BA424
                      : Colors.grey[300],
                ),
                child: Text(
                  item,
                  style: TextStyle(
                    color: isFirst ? Color(0xFF1BA424) : Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }



  Widget sectionDivider() {
    return Divider(
      thickness: 1,
      color: Colors.black.withOpacity(0.3),
      height: 24,
      indent: 16,
      endIndent: 16,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // App Bar
          Container(
            width: double.infinity,
            height: 115,
            padding: const EdgeInsets.only(top: 24),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Icon(Icons.arrow_back_ios_new, size: 28),
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    'Pick Location',
                    style: TextStyle(
                      fontSize: 24,
                      color: Color(0xFF0A3B0D),
                    ),
                  ),
                ),
              ],
            ),
          ),

          sectionDivider(),

          // Search Store
          buildSearchBar(
            hintText: "Search Store",
            controller: searchStoreController,
            onSubmitted: _searchLocation,
          ),
          buildRecentTabs([
            "Cargills Colombo",
            "Keells Colombo",
            "Cargills Kalutara",
            "Keells Nugegoda",
            "Cargills Horana",
            "Keells Panadura",
          ], _searchLocation),

          sectionDivider(),

          // Search City
          buildSearchBar(
            hintText: "Search City",
            controller: searchCityController,
            onSubmitted: _searchCity,
          ),
          buildRecentTabs(recentCities, _searchCity),

          sectionDivider(),

          // Map
          Padding(
            padding: const EdgeInsets.only(top: 40.0),
            child: SizedBox(
              height: 400,
              child: Stack(
                children: [
                  FlutterMap(
                    mapController: mapController,
                    options: MapOptions(
                      center: currentLatLng,
                      zoom: 13.0,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                        subdomains: ['a', 'b', 'c'],
                        userAgentPackageName: 'com.example.yourapp',
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: currentLatLng,
                            width: 40,
                            height: 40,
                            child: Icon(Icons.location_pin, color: Colors.red, size: 40),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: FloatingActionButton(
                      backgroundColor: Colors.white,
                      onPressed: () {
                        _searchLocation(searchStoreController.text.trim());
                      },
                      child: Icon(Icons.search, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}