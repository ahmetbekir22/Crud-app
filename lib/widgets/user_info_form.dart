import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:date_time_picker/date_time_picker.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

class UserInfoForm extends StatefulWidget {
  final UserModel? user;

  UserInfoForm({this.user});

  @override
  _UserInfoFormState createState() => _UserInfoFormState();
}

class _UserInfoFormState extends State<UserInfoForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dateController = TextEditingController();
  late SharedPreferences _prefs;
  DateTime? _birthdate;
  ApiService apiService = ApiService();
  bool isEditMode = false;

  @override
  void initState() {
    super.initState();
    _initSharedPreferences();

    if (widget.user != null) {
      isEditMode = true;
      _nameController.text = widget.user!.name!;
      if (widget.user!.birthdate != null) {
        _birthdate = widget.user!.birthdate;
        _dateController.text = _birthdate!.toString().split(' ')[0];
      }
    }
  }

  Future<void> _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    String? savedBirthdate = _prefs.getString('birthdate');
    if (savedBirthdate != null && !isEditMode) {
      setState(() {
        _birthdate = DateTime.parse(savedBirthdate);
        _dateController.text = _birthdate.toString().split(' ')[0];
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate() && _birthdate != null) {
      UserModel user = UserModel(
        id: isEditMode ? widget.user!.id : null,
        name: _nameController.text,
        birthdate: _birthdate,
      );

      try {
        if (isEditMode) {
          await apiService.updateUser(widget.user!.id!, user); // Update user
        } else {
          await apiService.createUser(user); // Create new user
        }
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('User Saved!')));
        Navigator.pop(context, true); // Return to previous screen after saving
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                DateTimePicker(
                  controller: _dateController,
                  type: DateTimePickerType.date,
                  dateLabelText: 'Birthdate',
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2100),
                  onChanged: (val) {
                    setState(() {
                      _birthdate = DateTime.parse(val);
                    });
                    _prefs.setString('birthdate', val);
                  },
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Please enter your birthdate';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text(isEditMode ? 'Update' : 'Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
