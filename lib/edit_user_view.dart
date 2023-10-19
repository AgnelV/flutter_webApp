import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class EditUserView extends StatefulWidget {
  final Map<String, dynamic> user;

  const EditUserView(this.user, {super.key});

  @override
  
  // ignore: library_private_types_in_public_api
  _EditUserViewState createState() => _EditUserViewState();
}

class _EditUserViewState extends State<EditUserView> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _genderController;
 

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user['name']);
    _emailController = TextEditingController(text: widget.user['email']);
    _genderController =TextEditingController(text: widget.user['gender']);

   
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit User'),backgroundColor: const Color.fromARGB(255, 9, 8, 40),),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller:_emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
             TextField(
              controller: _genderController,
              decoration: const InputDecoration(labelText: 'Gender'),
            ),
           
            ElevatedButton(
              onPressed: () async {
                
                // Update user details
                widget.user['name'] = _nameController.text;
                widget.user['email'] = _emailController.text;
                widget.user['geneder'] =_genderController.text;
                print(widget.user);
              Updateuserdata();

                // Navigate back to UserDetailView
                Navigator.pop(context);
              },
              child: const Text('Save Changes'),
              
            ),
            
          ],
        ),
      ),
    );
  }
  // ignore: non_constant_identifier_names
  Updateuserdata() async{
    try{
      var body = {
              
              'name':_nameController.text,
              'email':_emailController.text,
              'gender':_genderController.text,
      };
      http.Response response=await http.post(Uri.parse('https://gorest.co.in/public/v2/users'),
      body: jsonEncode(body),
      headers: {
        //'Content-Type' : 'application/json',
        //'Accept' : 'application/json',
        'Authorization': 'Bearer fb63d04c6fa95d82ab8394e912d41328e26e6878522a26129769278160742f3e',

      }
      );
      if(response.statusCode==422){
        final json = jsonDecode(response.body);
        print(json);
      }
      else{
        print('response status code not 200');
                    throw jsonDecode(response.body) ["meta"]["message" ] ?? "Unknown Error occured";
      }
      
    }catch(error){
      print(error);
    }
  }
}

