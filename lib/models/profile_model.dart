class ProfileModel {
  final String email, name, gender, phone, country;
  ProfileModel({
    required this.email,
    required this.name,
    required this.country,
    required this.gender,
    required this.phone,
  });

  String getImagePath() {
    if (gender == 'male') {
      return 'assets/images/maleImage.jpg';
    }
    return 'assets/images/ProfileImage.jpg';
  }
}
