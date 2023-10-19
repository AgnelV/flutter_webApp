import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webapp/api_service.dart';
import 'package:flutter_webapp/new_user_view.dart';
import 'package:flutter_webapp/user_detail_view.dart';
//import 'package:http/http.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}): super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _refreshUserList() {
    setState(() {}); // This will trigger a rebuild of the widget, fetching new data
  }

  Future<bool> _checkInternetConnectivity() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.none) {
    return false;
  }
  return true;
}

  /*Future<bool> _checkInternetConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('No Internet Connection'),
            content: const Text('Please check your internet connection and try again.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return false;
    }
    return true;
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User List'),
        backgroundColor: const Color.fromARGB(255, 9, 8, 40),
        shadowColor: const Color.fromARGB(255, 203, 203, 203),
        elevation: 10,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('create user');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewUserView(refreshCallback: _refreshUserList),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder(
        future: _checkInternetConnectivity(),
        builder: (context, snapshot) {
          print(snapshot.data);
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.data == false) {
            return const Center(child: Text('No Internet Connection'));
          } else {
            
            // Data has been successfully loaded
            // Replace 'users' with your API endpoint
            return FutureBuilder(
              
              future: ApiService.fetchData('users'), // Assuming ApiService.fetchData exists
              builder: (context, snapshot) {
                print(snapshot.data);
               
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  List<dynamic> users = snapshot.data ?? [];
                  return Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: users.length,
                          
                          itemBuilder: (context, index) {
                            print(users.length);
                            Map<String, dynamic> user = users[index];
                            var inc = index + 1;
                            return  ListTile(
                              shape: Border.all(width: .1),
                              leading: Text('$inc'),
                              title: Text(user['name']),
                              subtitle: Text(user['email'], style: const TextStyle(color: Colors.blue)),
                              trailing: Text(user['gender']),
                              titleTextStyle: const TextStyle(color: Color.fromARGB(255, 82, 81, 81), fontSize: 20),
                              leadingAndTrailingTextStyle: const TextStyle(
                                backgroundColor: Color.fromARGB(255, 250, 246, 246),
                                fontSize: 18,
                                color: Color.fromARGB(255, 15, 185, 241),
                              ),
                              subtitleTextStyle: const TextStyle(color: Color.fromARGB(255, 23, 38, 51)),
                              onTap: () {
                                print('user view');
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    
                                    builder: (context) => UserDetailView(user: user),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}

