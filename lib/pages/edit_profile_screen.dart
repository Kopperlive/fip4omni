import 'package:flutter/material.dart';
import 'package:fip_my_version/core/core.dart';
import 'package:email_validator/email_validator.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;


class EditProfScreen extends StatefulWidget {
  @override
  _EditProfScreenState createState() => _EditProfScreenState();
}

class _EditProfScreenState extends State<EditProfScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController telegramController = TextEditingController();
  String? selectedCountry = 'kyrgyzstan';
  String? selectedGender;
  String? _profileImageUrl;
  File? _profileImage;
  


  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  Future<void> getUserInfo() async {
    final response = await http.get(
      Uri.parse('$protocol://$domain/api/v1/user/'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final userInfo = json.decode(response.body);

      setState(() {
        // Assuming the userInfo map contains all the keys used below
        emailController.text = userInfo['email'];
        // phoneNumberController.text = userInfo['phoneNumber'];
        // telegramController.text = userInfo['telegramNickname'];
        // selectedCountry = userInfo['country'];
        selectedGender = userInfo['gender'];
        // _profileImageUrl = userInfo['avatar'];
        // Assuming you get the image URL and need to convert it to a File
        // You'll need to use a package like 'path_provider' to get a directory
        // and 'dio' or similar to download the file into your app's storage
        _profileImageUrl = userInfo['avatar'];
      });
    } else {
      // Handle error or notify user
      print('Failed to get user info. Status code: ${response.statusCode}');
    }
  }

  Future<void> updateUserInfo() async {
    var request = http.MultipartRequest('PATCH', Uri.parse('$protocol://$domain/api/v1/user/'))
      ..headers.addAll(headers)
      ..fields['email'] = emailController.text
      ..fields['gender'] = selectedGender!;
    
    if (_profileImage != null) {
      request.files.add(http.MultipartFile(
        'avatar',
        _profileImage!.readAsBytes().asStream(),
        _profileImage!.lengthSync(),
        filename: path.basename(_profileImage!.path),
      ));
    }
    
    var response = await request.send();
    if (response.statusCode == 200) {
      // Handle successful response
      print('User info updated successfully.');
    } else {
      // Handle error response
      print('Failed to update user info. Status code: ${response.statusCode}');
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      body: SingleChildScrollView( // Use SingleChildScrollView to prevent overflow when keyboard appears
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // User Profile Header
            Container(
              margin: EdgeInsets.all(0),
              padding: EdgeInsets.all(0),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.15,
              decoration: BoxDecoration(
                color: Color(0xff000000),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.zero,
                border: Border.all(color: Color(0x4d9e9e9e), width: 1),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 5, 0),
                    child: Image(
                      image: AssetImage("assets/images/omni_logo_sign_in.png"),
                      height: 100,
                      width: MediaQuery.of(context).size.width * 0.1,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      ProfileManager.userProfile.name,
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        fontSize: 22,
                        color: Color(0xffffffff),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Back Button
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                  child: IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    color: Color(0xff212435),
                    iconSize: 28,
                  ),
                ),
              ],
            ),
            // User Profile Picture
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => Wrap(
                    children: [
                      ListTile(
                        leading: Icon(Icons.photo_camera),
                        title: Text('Camera'),
                        onTap: () {
                          _pickImage(ImageSource.camera);
                          Navigator.of(context).pop();
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.photo_library),
                        title: Text('Gallery'),
                        onTap: () {
                          _pickImage(ImageSource.gallery);
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                );
              },
              child: CircleAvatar(
                radius: 60,
                backgroundImage: _profileImage != null 
                  ? FileImage(_profileImage!) as ImageProvider<Object>
                  : (_profileImageUrl != null 
                      ? NetworkImage(_profileImageUrl!) as ImageProvider<Object>
                      : null),
                child: (_profileImage == null && _profileImageUrl == null) 
                  ? Icon(Icons.add_a_photo, size: 50) 
                  : null,
                ),
            ),
            // Email TextField
            Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: AppLocalizations.of(context).translate('email'),
                  filled: true,
                  fillColor: Color(0xfff2f2f3),
                ),
              ),
            ),
            // Phone Number TextField
            Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: TextField(
                controller: phoneNumberController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: AppLocalizations.of(context).translate('phone_number'),
                  filled: true,
                  fillColor: Color(0xfff2f2f3),
                ),
              ),
            ),
            // Country Dropdown
            Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: DropdownButtonFormField<String>(
                value: selectedCountry,
                // Make sure all items in this list are unique
                items: <String>[
                  "kyrgyzstan",
                  "usa",
                  "united_kingdom",
                  "russia",
                  "china",
                  // ... other country codes
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(AppLocalizations.of(context).translate(value)),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      selectedCountry = newValue;
                      ProfileManager.userProfile.country = newValue;
                    });
                  }
                },
                isExpanded: true,
              ),
            ),
            // Gender Dropdown
            Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: DropdownButtonFormField<String>(
                value: selectedGender,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: AppLocalizations.of(context).translate('gender'),
                ),
                items: <String>[
                  'M',
                  'F',
                  // ... other gender options
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(AppLocalizations.of(context).translate(value)),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) { // Check if newValue is not null
                    setState(() {
                      selectedGender = newValue;
                      ProfileManager.userProfile.gender = newValue;
                    });
                  }
                  },
                isExpanded: true,
              ),
            ),
            // Telegram Nickname TextField
            Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: TextField(
                controller: telegramController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: AppLocalizations.of(context).translate('telegram_nickname'),
                  filled: true,
                  fillColor: Color(0xfff2f2f3),
                ),
              ),
            ),
            // Save Button
            ElevatedButton(
              onPressed: () async {
                // Check if the email is valid
                if (EmailValidator.validate(emailController.text)) {
                  try {
                    await updateUserInfo();
                    // If the update is successful, show a success dialog or toast
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Success'),
                        content: Text('Your information has been updated.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(), // Dismiss the dialog
                            child: Text(AppLocalizations.of(context).translate('ok')),
                          ),
                        ],
                      ),
                    );
                  } catch (e) {
                    // If there's an error, show an error dialog or toast
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Error'),
                        content: Text('Failed to update information. Please try again.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(), // Dismiss the dialog
                            child: Text(AppLocalizations.of(context).translate('ok')),
                          ),
                        ],
                      ),
                    );
                  }
                } else {
                  // If the email is not valid, show a warning dialog
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(AppLocalizations.of(context).translate('invalid_email')),
                      content: Text(AppLocalizations.of(context).translate('enter_valid_email')),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(), // Dismiss the dialog
                          child: Text(AppLocalizations.of(context).translate('ok')),
                        ),
                      ],
                    ),
                  );
                }
              },
              child: Text(AppLocalizations.of(context).translate('save')),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // Rounded corners
                ),
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16), // Padding inside the button
              ),
            ),
          ],
        ),
      ),
    );
  }
}


