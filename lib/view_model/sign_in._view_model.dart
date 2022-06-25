import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:rare_crew_task/models/profile_model.dart';

class SignInViewModel {
  // ignore: unused_field
  late ProfileModel _profileModel;
  late String _accessToken, _refreshToken;
  final String _baseUrl = 'http://10.0.2.2:8080';

  get getAccessToken {
    return _accessToken;
  }

  set setAccessToken(value) {
    _accessToken = value;
  }

  get getRefreshToken {
    return _refreshToken;
  }

  set setRefreshToken(value) {
    _refreshToken = value;
  }

  ProfileModel getProfileModel() {
    return _profileModel;
  }

  Future signIn(String email, String password) async {
    var url = Uri.parse('$_baseUrl/login');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode({'email': email, 'password': password}));
    if (response.statusCode < 300 && response.statusCode >= 200) {
      final dataBody = json.decode(response.body);
      _accessToken = dataBody['accessToken'];
      _refreshToken = dataBody['refreshToken'];
    }
  }

  Future getProfileData() async {
    var url = Uri.parse('$_baseUrl/user');
    var response = await http.get(url,
        headers: {HttpHeaders.authorizationHeader: 'Bearer $getAccessToken'});
    if (response.statusCode > 300) {
      await generateAccessToken();
      response = await http.get(url,
          headers: {HttpHeaders.authorizationHeader: 'Bearer $getAccessToken'});
    }
    final dataBody = json.decode(response.body);
    _profileModel = ProfileModel(
      email: dataBody['data']['email'],
      name: dataBody['data']['name'],
      country: dataBody['data']['country'],
      gender: dataBody['data']['gender'],
      phone: dataBody['data']['phone'],
    );
  }

  Future generateAccessToken() async {
    var url = Uri.parse('$_baseUrl/token');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode({'token': getRefreshToken}));
    if (response.statusCode < 300 && response.statusCode >= 200) {
      final dataBody = json.decode(response.body);
      _accessToken = dataBody['accessToken'];
    }
  }

  void signOut() async {
    var url = Uri.parse('$_baseUrl/logout');
    await http.delete(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(
        {'token': getRefreshToken},
      ),
    );
  }

  String? emailValidation(String? email) {
    String? errorMessege;
    if (email == null) {
      errorMessege = 'Email can\'t be empty!!';
    } else if (!email.contains('@') || !email.contains('.com')) {
      errorMessege = 'Invalid Email!!';
    }
    return errorMessege;
  }

  String? passwordValidation(String? password) {
    String? errorMessege;
    if (password == null) {
      errorMessege = 'Password can\'t be empty!!';
    }
    return errorMessege;
  }
}
