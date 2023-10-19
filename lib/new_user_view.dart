import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_webapp/homepage.dart';
//import 'package:flutter_webapp/model/usermodel.dart';
//import 'package:flutter_webapp/config.dart';
//import 'package:flutter_webapp/homepage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

//import 'package:flutter_webapp/model/usermodel.dart';


class NewUserView extends StatefulWidget {
  const NewUserView({super.key, required this.refreshCallback, });
  
   final VoidCallback refreshCallback;
   

  @override
  // ignore: library_private_types_in_public_api
  _NewUserViewState createState() => _NewUserViewState();
}

class _NewUserViewState extends State<NewUserView> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController? _nameController ;
  TextEditingController? _emailController;
   TextEditingController? _genderController;  
  late SharedPreferences _prefs;
  //final bool _emailValidator = false;

  

  bool _isActive = false;
  
 @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _genderController = TextEditingController();
    
    _initPrefs();
  }

Future<void> _initPrefs() async {
  _prefs = await SharedPreferences.getInstance();
  String draftName = _prefs.getString('draft_name') ?? '';
    String draftEmail = _prefs.getString('draft_email') ?? '';
     String draftGender = _prefs.getString('draft_gender') ?? '';
   
  
    bool draftActive = _prefs.getBool('draft_active') ?? false;

    // Update the form fields with the draft data
    setState(() {

      _nameController!.text = draftName;
      _emailController!.text = draftEmail;
      _genderController!.text = draftGender;
      
      _isActive = draftActive;
      print(_nameController);
    });
}
 @override
 /* void dispose() {
    print('disposed');
    _nameController?.dispose();
    _emailController?.dispose();
    _genderController?.dispose();
    
    super.dispose();
  }*/


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New User'),backgroundColor: const Color.fromARGB(255, 9, 8, 40),),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
             
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email';
                  }
                  
                  // You can add more email validation logic here if needed
                  return null;
                  
                },
              ),
              TextFormField(
                controller: _genderController,
                decoration: const InputDecoration(labelText: 'Gender'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an gender';
                  }
                  
                  // You can add more email validation logic here if needed
                  return null;
                },
              ),
              
               
              SwitchListTile(
                title: const Text('Active'),
                value: _isActive,
                onChanged: (value) {
                  setState(() {
                    _isActive = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  print(_formKey);
                  print('created');
                  if (_formKey.currentState!.validate()) {
                    // Form is valid, proceed with user creation
                    _createUser(context);//pass the context
                  }
                },
                child: const Text('Create User'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _createUser(BuildContext context) async {

     var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.none) {
   
    return; // Return early if there's no internet connection
  }
    
  String name = _nameController!.text;
  String email = _emailController!.text;
  
  String gender = _genderController!.text;
  
  bool isActive = _isActive;
  print(name);

  // Save the form data to SharedPreferences
  _prefs.setString('draft_name', name);
  _prefs.setString('draft_email', email);
  _prefs.setString('draft_gender', gender);
  _prefs.setBool('draft_active', isActive);

  // Show a confirmation dialog or message if needed
 /* final response = await http.post(
    Uri.parse('https://gorest.co.in/public/v2/users'));
   if (response.statusCode == 201) {
    json.encode(response.body);
    print('User created successfully');
  } else {
    print('Failed to create user. Status code: ${response.statusCode}');
  }*/

  try {
     
    var response = await http.post(
      Uri.parse('https://gorest.co.in/public/v2/users'),
      body: {
        'name': name,
        'email': email,
        'gender':gender,
        'status': isActive ? 'active' : 'inactive',
      },
      headers: {
       //'Content-Type ':'application/json; charset=UTF-8'
        'Authorization': 'Bearer fb63d04c6fa95d82ab8394e912d41328e26e6878522a26129769278160742f3e', 
        },
    );
    
    if (response.statusCode == 201) {
      
      print('User created successfully');
      
        var result=jsonDecode(response.body);
        print(result);
     
      
      
      
        ScaffoldMessenger.of(context).showSnackBar(
             const SnackBar(
                         content: Text('User created successfully!'),
                         duration: Duration(seconds: 2),
                 ),
  
          );
 
      widget.refreshCallback();
    
      Navigator.pop(context);
      
    } else {
      print('Failed to create user. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  } catch (error) {
    print('Error creating user: $error');
  }
}

}

