import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:prueba_1/controllers/services.dart';
import 'package:prueba_1/controllers/util/session_util.dart';
import 'package:prueba_1/models/data_response.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final _formKey = GlobalKey<FormState>();
  final Services services = Services();
  int _selectedIndex = 0;
  late TextEditingController dniControl;
  late TextEditingController nameControl;
  late TextEditingController lastNameControl;

  late Map<String, dynamic> _user;
  bool _isLoading = true;
  String? _uid = '';

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final SessionUtil session = SessionUtil();

    _uid = await session.getValue('uid');

    final DataResponse response = await services.getUser(_uid);

    if (response.code == "200") {
      setState(() {
        _user = Map<String, dynamic>.from(response.context);
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }

    dniControl = TextEditingController(text: _user['dni']);
    nameControl = TextEditingController(text: _user['name']);
    lastNameControl = TextEditingController(text: _user['last_name']);
  }

  void sendData() {
    FToast ftoast = FToast();
    ftoast.init(context);

    setState(() {
      if (_formKey.currentState!.validate()) {
        Map<String, String> json = {
          "name": nameControl.text,
          "last-name": lastNameControl.text,
          "dni": dniControl.text,
          "person": "$_uid"
        };

        services.updateUser(json).then((data) async {
          if (data.code == '200') {
            ftoast.showToast(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.0),
                  color: Colors.green,
                ),
                child: Text(
                  '${data.context}',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              gravity: ToastGravity.CENTER,
              toastDuration: const Duration(seconds: 3),
            );

            Navigator.pushNamed(context, '/dashboard/products');
          } else {
            ftoast.showToast(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.0),
                  color: Colors.amber.shade400,
                ),
                child: Text(data.context ?? 'Error desconocido'),
              ),
              gravity: ToastGravity.CENTER,
              toastDuration: const Duration(seconds: 2),
            );
          }
        });
      }
    });
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(40),
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(bottom: 40),
                    child: const Column(
                      children: [
                        Text(
                          'Profile',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 30),
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: TextFormField(
                      decoration: const InputDecoration(labelText: 'Dni'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter your dni";
                        } else if (value.length < 10 || value.length > 10) {
                          return "Dni length should be 10";
                        }
                        return null;
                      },
                      controller: dniControl,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: TextFormField(
                      decoration: const InputDecoration(labelText: 'Name'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter your name";
                        }
                        return null;
                      },
                      controller: nameControl,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: TextFormField(
                      decoration: const InputDecoration(labelText: 'Last Name'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter your last name";
                        }
                        return null;
                      },
                      controller: lastNameControl,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: ElevatedButton(
                      onPressed: sendData,
                      child: const Text("Update"),
                    ),
                  )
                ],
              ),
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
