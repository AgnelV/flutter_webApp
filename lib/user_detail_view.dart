import 'package:flutter/material.dart';
import 'package:flutter_webapp/edit_user_view.dart';

class UserDetailView extends StatefulWidget {
   final Map<String, dynamic> user;

 //const UserDetailView(this.user, {super.key});
  const UserDetailView({
    required this.user,
    Key? key, // Add a named key parameter
  }) : super(key: key);

  @override
   _UserDetailViewState createState() => _UserDetailViewState();
}

 class _UserDetailViewState extends State<UserDetailView> {
  @override
  Widget build(BuildContext context) {
    print(context);
    return Scaffold(
      
      appBar: AppBar(title: const Text('User Detail'),backgroundColor: const Color.fromARGB(255, 9, 8, 40),shadowColor: Colors.blueGrey,elevation: 10,

      actions: [
    IconButton(
      icon: const Icon(Icons.edit),
      onPressed: () {
        print('edit user');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditUserView(widget.user),
          ),
        );
      },
    ),
  ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          //color: Colors.green,
          height: 250,
          width: 500,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.green),
          margin: const EdgeInsets.symmetric(vertical: 30),
          padding: const EdgeInsets.all(15),
          child: Column(
              
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             
              Text('Name:  ${widget.user['name']}',style: const TextStyle(fontSize: 25,color: Colors.blue,letterSpacing: 3,wordSpacing:2),),
              const SizedBox(height: 20,),
              Text('Email: ${widget.user['email']}',style: const TextStyle(fontSize: 17),),
              const SizedBox(height: 10,),
              Text('Geneder: ${widget.user['gender']}',style: const TextStyle(fontSize: 17),),
              const SizedBox(height: 10,),
              Text('Status: ${widget.user['status']}',style: const TextStyle(fontSize: 19),),
            ],
          ),
        ),
      ),
      
    );
  }
}