import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/api_service.dart';
import '../models/user_model.dart';
import '../pages/user_info_form.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

// State class for HomePage
class _HomePageState extends State<HomePage> {
  // List of all users and filtered users
  List<UserModel> _users = [];
  List<UserModel> _filteredUsers = [];

  // Loading indicator flag
  bool _isLoading = true;

  // Controllers for search and API key input
  TextEditingController _searchController = TextEditingController();
  TextEditingController _apiKeyController = TextEditingController();

  ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    // Fetch users when the widget is initialized
    _fetchUsers();
  }

  // Fetch users from the API
  Future<void> _fetchUsers() async {
    try {
      List<UserModel> users = await apiService.fetchUsers();
      setState(() {
        _users = users;
        _filteredUsers = users;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('An error occurred!')));
    }
  }

  // Filter users based on the search query
  void _filterUsers(String query) {
    final filtered = _users
        .where((user) => user.name!.toLowerCase().contains(query.toLowerCase()))
        .toList();
    setState(() {
      _filteredUsers = filtered;
    });
  }

  // Navigate to the add user form
  void _navigateToAddUser() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UserInfoFormPage()),
    ).then((value) => _fetchUsers());
  }

  // Navigate to the edit user form
  void _navigateToEditUser(UserModel user) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UserInfoFormPage(user: user)),
    ).then((value) => _fetchUsers());
  }

  // Show a dialog to enter a new API key
  void _showApiKeyDialog() async {
    bool isConnected = await apiService.isConnected();
    if (isConnected) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Already connected')));
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Enter New API Key'),
            content: TextField(
              controller: _apiKeyController,
              decoration: InputDecoration(hintText: 'API Key'),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  String apiKey = _apiKeyController.text;
                  try {
                    await apiService.updateApiKey(apiKey);
                    await _fetchUsers();
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Connected successfully!')));
                  } catch (e) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Connection failed!')));
                  }
                },
                child: Text('Save'),
              ),
            ],
          );
        },
      );
    }
  }

  // Launch a URL in the browser
  void _launchURL() async {
    const url = 'https://crudcrud.com/';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(), // Add this to push the title to the center
            Text(
              'CRUD APP',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.black,
              ),
            ),
            Spacer(), // Add this to push the actions to the end
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.black),
            onPressed: _fetchUsers,
          ),
          IconButton(
            icon: Icon(Icons.vpn_key, color: Colors.black),
            onPressed: _showApiKeyDialog,
          ),
          IconButton(
            icon: Icon(Icons.web, color: Colors.black),
            onPressed: _launchURL,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: _filterUsers,
            ),
          ),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _filteredUsers.length,
                    itemBuilder: (context, index) {
                      UserModel user = _filteredUsers[index];
                      int? age = user.calculateAge();
                      String? horoscope = user.getHoroscope();
                      return Card(
                        elevation: 4.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        margin: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: ListTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(user.name!,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              if (age != null)
                                Text('Age: $age',
                                    style: TextStyle(color: Color.fromARGB(255, 90, 111, 131))),
                              if (horoscope != null)
                                Text('Horoscope: $horoscope',
                                    style: TextStyle(color: Color.fromARGB(255, 90, 111, 131))),
                            ],
                          ),
                          onTap: () => _navigateToEditUser(user),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              try {
                                await apiService.deleteUser(user.id!);
                                _fetchUsers();
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content:
                                            Text('Failed to delete user')));
                              }
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 162, 185, 188),
        foregroundColor: Colors.black,
        shape: StadiumBorder(
          side: BorderSide(color: Color.fromARGB(255, 185, 172, 172), width: 2.0),
        ),        
        onPressed: _navigateToAddUser,
        child: Icon(Icons.add),
      ),
    );
  }
}
