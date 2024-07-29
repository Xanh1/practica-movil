import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:prueba_1/controllers/services.dart';
import 'package:prueba_1/models/data_response.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Services _service = Services();
  List<Marker> _markers = [];
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadBranches();
  }

  void _showBranchInfo(Map<String, dynamic> branch) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(branch['name']),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Has no expired products'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _loadBranches() async {
    DataResponse response = await _service.getBranches();

    if (response.code == '200') {
      List<dynamic> branches = response.context;
      List<Marker> markers = branches.map((branch) {
        return Marker(
          point: LatLng(branch['latitude'], branch['longitude']),
          width: 80,
          height: 80,
          child: GestureDetector(
            onTap: () {
              _showBranchInfo(branch);
            },
            child: Column(
              children: [
                const Icon(Icons.storefront),
                Text(branch['name']),
              ],
            ),
          ),
        );
      }).toList();

      setState(() {
        _markers = markers;
      });
    } else {}
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;

      switch (index) {
        case 0:
          Navigator.pushNamed(context, '/dashboard/user');
          break;
        case 1:
          Navigator.pushNamed(context, '/dashboard/map');
          break;
        case 2:
          Navigator.pushNamed(context, '/dashboard/branch');
          break;
        case 3:
          Navigator.pushNamed(context, '/dashboard/products');
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
        options: const MapOptions(
          initialCenter: LatLng(-4.0220656, -79.2056229),
          initialZoom: 14,
          interactionOptions: InteractionOptions(
            flags:
                InteractiveFlag.doubleTapDragZoom | InteractiveFlag.pinchZoom,
          ),
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
          ),
          MarkerLayer(
            markers: _markers,
          ),
          RichAttributionWidget(
            attributions: [
              TextSourceAttribution(
                'OpenStreetMap contributors',
                onTap: () => (Uri.parse('https://openstreetmap.org/copyright')),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Branch'),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Product'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        onTap: _onItemTapped, // Conectar el método con el evento onTap
      ),
    );
  }
}
