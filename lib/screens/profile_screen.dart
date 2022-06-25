import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rare_crew_task/screens/login_screen.dart';
import 'package:rare_crew_task/view_model/sign_in._view_model.dart';

import '../models/profile_model.dart';

// ignore: must_be_immutable
class ProfileScreen extends StatelessWidget with SignInViewModel {
  final String accessToken, refreshToken;
  ProfileScreen(
      {Key? key, required this.accessToken, required this.refreshToken})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sizeOfScreen = MediaQuery.of(context).size;
    final signInProvider = Provider((ref) => SignInViewModel());
    final responseProvider = FutureProvider<ProfileModel>((ref) async {
      final readData = ref.read(signInProvider);
      readData.setAccessToken = accessToken;
      readData.setRefreshToken = refreshToken;
      await readData.getProfileData();
      return readData.getProfileModel();
    });
    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer(
        builder: (context, watch, child) {
          final response = watch(responseProvider);
          return response.map(
              data: ((data) {
                return SafeArea(
                  child: Column(
                    children: [
                      ProfileSyledImage(
                        sizeOfScreen: sizeOfScreen,
                        country: data.value.country,
                        imagePath: data.value.getImagePath(),
                        name: data.value.name,
                        onPress: () {
                          signOut();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) => LoginScreen(),
                            ),
                          );
                        },
                      ),
                      Expanded(
                          child: ListView(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.person),
                            title: Text(data.value.name),
                          ),
                          ListTile(
                            leading: const Icon(Icons.location_on_outlined),
                            title: Text(data.value.country),
                          ),
                          ListTile(
                            leading: const Icon(Icons.phone_android),
                            title: Text(data.value.phone),
                          ),
                          ListTile(
                            leading: const Icon(Icons.email),
                            title: Text(data.value.email),
                          ),
                        ],
                      ))
                    ],
                  ),
                );
              }),
              loading: (_) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
              error: (_) => const Center(child: Text("Error")));
        },
      ),
    );
  }
}

class ProfileSyledImage extends StatelessWidget {
  const ProfileSyledImage({
    Key? key,
    required this.sizeOfScreen,
    required this.imagePath,
    required this.onPress,
    required this.name,
    required this.country,
  }) : super(key: key);

  final Size sizeOfScreen;
  final String imagePath;
  final Function onPress;
  final String name, country;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: sizeOfScreen.height / 2,
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            imagePath,
            fit: BoxFit.fill,
          ),
          Container(
            color: Colors.black38,
          ),
          Positioned(
            bottom: 1,
            child: Container(
              margin: const EdgeInsets.only(left: 10, bottom: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.fmd_good_outlined,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        country,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 20),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 1,
            bottom: 1,
            child: Container(
              margin: const EdgeInsets.only(bottom: 50),
              child: TextButton(
                onPressed: () => onPress(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.person_outline,
                      color: Colors.white,
                      size: 17,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      'Log Out',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                      ),
                    ),
                  ],
                ),
                style: TextButton.styleFrom(
                  fixedSize: const Size(120, 60),
                  backgroundColor: const Color(0xff10ADBC),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
