import 'package:flutter/material.dart';
import '../../core/network_layer/firebase_utils.dart';


class RegisterViewModel extends ChangeNotifier {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _fullName = TextEditingController();
  final TextEditingController _userName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  String? _registrationStatus = "";

  GlobalKey<FormState>? get formKey => _formKey;
  TextEditingController? get fullName => _fullName;
  TextEditingController? get userName => _userName;
  TextEditingController? get email => _email;
  TextEditingController? get password => _password;
  TextEditingController? get confirmPassword => _confirmPassword;
  String? get registrationStatus => _registrationStatus;

  register() async {
  if (_formKey.currentState!.validate()) {
    // Call API to register
    var response = await FirebaseUtils.register(
      _email.text, _password.text, _userName.text);
    response.fold((l) {
      // Handle registration error
      _registrationStatus = l;
    }, (r) {
      // Registration success
      _registrationStatus = "success";
    });
  }
  // If registration status is empty, set it to "invalid"
  if (_registrationStatus!.isEmpty) _registrationStatus = "invalid";
  // Notify listeners to update UI
  notifyListeners();
}



}
