import 'package:flutter/material.dart';
import 'package:prueba_1/controllers/services.dart';
import 'package:prueba_1/models/data_response.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  int _selectedIndex = 0;
  List<Map<String, dynamic>> _products = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    final Services services = Services();
    final DataResponse response = await services.getProducts();

    if (response.code == "200") {
      setState(() {
        _products = List<Map<String, dynamic>>.from(response.context);
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
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
      appBar: AppBar(
        title: const Text("Productos"),
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : ProductsTable(data: _products),
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
          BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Branch',),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Product',),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        onTap: _onItemTapped, // Conectar el método con el evento onTap
      ),
    );
  }
}

class ProductsTable extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const ProductsTable({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        showCheckboxColumn: false,
        columns: const [
          DataColumn(label: Text('Name')),
          DataColumn(label: Text('Stock')),
          DataColumn(label: Text('Status')),
          DataColumn(label: Text('Branch')),
        ],
        rows: data.map((item) {
          return DataRow(
            cells: [
              DataCell(Text(item['product'] ?? '')),
              DataCell(Text(item['stock'].toString())),
              DataCell(Text(item['status'] ?? '')),
              DataCell(Text(item['branch'] ?? '')),
            ],
          );
        }).toList(),
      ),
    );
  }
}
