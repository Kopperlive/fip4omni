import 'package:flutter/material.dart';
import 'package:fip_my_version/core/core.dart';
import 'package:http/http.dart' as http;

class SettingsScreen extends StatefulWidget {
  @override
  
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int _selectedIndex = 2; // Assuming 'Settings' is the third item
  late Map<String, dynamic> userInfo = {};

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  Future<void> getUserInfo() async {
    // final response = await http.get(Uri.parse('http://192.168.0.106:8000/api/v1/user/'), headers: headers);
    final response = await http.get(Uri.parse('$protocol://$domain/api/v1/user/'), headers: headers);

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonMap = json.decode(response.body);
      setState((){
        userInfo = jsonMap;

        print(userInfo);
      });
    }else{
      print('Failed to get full name. Status code: ${response.statusCode}');
    }
  }

  Future<void> signOut() async {
  final response = await http.post(
    Uri.parse('$protocol://$domain/api/v1/user/sign_out'),
    headers: headers,
    body: jsonEncode({}), // If an empty object is required, send an empty JSON object.
  );

  if (response.statusCode == 201) { // Check for the correct status code.
    // Clear any stored user data here, as previously described.
    
    Navigator.pushReplacementNamed(context, '/signIn'); // Proceed to sign-in screen.
  } else {
    print('Failed to sign out. Status code: ${response.statusCode}');
    // Handle failure, perhaps by retrying or informing the user.
  }
}


  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    Color backgroundColor = themeProvider.isDarkMode
        ? Color.fromRGBO(21, 21, 21, 1)
        : Colors.white;
    Color fontColor = themeProvider.isDarkMode
        ? Colors.white
        : Colors.black;
    // Color nameColor = themeProvider.isDarkMode
    //     ? Color.fromRGBO(21, 21, 21, 1)
    //     : Colors.white;
   
    return Scaffold(
      backgroundColor: backgroundColor,
      // bottomNavigationBar: BottomBar(
      //   selectedIndex: _selectedIndex,
      //   onTabSelected: _onItemTapped,
      // ),
      body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
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
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 0, 5, 0),
                      child:

                          ///***If you have exported images you must have to copy those images in assets/images directory.
                          Image(
                        image: AssetImage("assets/images/omni_logo_sign_in.png"),
                        height: 200,
                        width: MediaQuery.of(context).size.width * 0.1,
                        fit: BoxFit.contain,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        (userInfo['last_name'] ?? '') + ' ' + (userInfo['first_name'] ?? '') + ' ' + (userInfo['middle_name'] ?? ''),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          fontSize: 18,
                          color: Color(0xffffffff),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                        child: Text(
                          AppLocalizations.of(context).translate('settings'),
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            fontSize: 20,
                            color: fontColor,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 20, 0),
                        child: Container(
                          height: 40,
                          width: 40,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: userInfo['avatar'] != null
                              ? Image.network(
                                  userInfo['avatar'],
                                  fit: BoxFit.contain,
                                  errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                    // If the image fails to load, display an icon instead
                                    return Icon(Icons.account_circle, size: 40);
                                  },
                                )
                              : Icon(Icons.account_circle, size: 40), // Default icon if the URL is null
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Divider(
                color: Color(0xffcbcaca),
                height: 16,
                thickness: 0,
                indent: 0,
                endIndent: 0,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
                    child: Text(
                      AppLocalizations.of(context).translate('account_settings'),
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        fontSize: 14,
                        color: Color(0xffcbcbcb),
                      ),
                    ),
                  ),
                  MaterialButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/editProfile');
                    },
                    color: backgroundColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    padding: EdgeInsets.fromLTRB(30, 20, 0, 20),
                    textColor: fontColor,
                    height: 40,
                    minWidth: MediaQuery.of(context).size.width,
                    child: Align(
                    alignment: Alignment.centerLeft,
                      child: Text(
                        AppLocalizations.of(context).translate('edit_profile'),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                  ),
              )],
              ),
              MaterialButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/changePassword');
                },
                color: backgroundColor,
                elevation: 0,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
                padding: EdgeInsets.fromLTRB(30, 20, 0, 20),
                textColor: fontColor,
                height: 40,
                minWidth: MediaQuery.of(context).size.width,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    AppLocalizations.of(context).translate('change_password'),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),
              ),
              MaterialButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/changeLanguage');
                },
                color: backgroundColor,
                elevation: 0,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
                padding: EdgeInsets.fromLTRB(30, 20, 0, 20),
                textColor: fontColor,
                height: 40,
                minWidth: MediaQuery.of(context).size.width,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    AppLocalizations.of(context).translate('language'),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                )
              ),
              SwitchListTile(
                value: true,
                title: Text(
                  AppLocalizations.of(context).translate('push_notifications'),
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 14,
                    color: fontColor,
                  ),
                  textAlign: TextAlign.start,
                ),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
                onChanged: (value) {},
                tileColor: backgroundColor,
                activeColor: Color(0xffffffff),
                activeTrackColor: Color(0xfffe8d26),
                controlAffinity: ListTileControlAffinity.trailing,
                dense: false,
                inactiveThumbColor: Color(0xff9e9e9e),
                inactiveTrackColor: Color(0xffe0e0e0),
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                selected: false,
                selectedTileColor: Color(0x42000000),
              ),
              SwitchListTile(
              value: Provider.of<ThemeProvider>(context).isDarkMode,
              title: Text(
                AppLocalizations.of(context).translate('dark_mode'),
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  fontSize: 14,
                  color: fontColor,
                ),
                textAlign: TextAlign.start,
              ),
              onChanged: (value) {
                Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
              },
              tileColor: backgroundColor,
              activeColor: Color(0xffffffff),
              activeTrackColor: Color(0xfffb8b26),
              controlAffinity: ListTileControlAffinity.platform,
              dense: false,
              inactiveThumbColor: Color(0xff9e9e9e),
              inactiveTrackColor: Color(0xffe0e0e0),
              contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
              selected: false,
              selectedTileColor: Color(0x42000000),
            ),
              Divider(
                color: Color(0xffcbcaca),
                height: 16,
                thickness: 0,
                indent: 0,
                endIndent: 0,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
                    child: Text(
                      AppLocalizations.of(context).translate('more'),
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        fontSize: 14,
                        color: Color(0xffcbcaca),
                      ),
                    ),
                  ),
                ],
              ),
              MaterialButton(
                onPressed: () {},
                color: backgroundColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
                padding: EdgeInsets.fromLTRB(30, 20, 0, 20),
                textColor: fontColor,
                height: 40,
                minWidth: MediaQuery.of(context).size.width,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    AppLocalizations.of(context).translate('about_us'),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                )
              ),
              MaterialButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/privacyPolicy');
                },
                color: backgroundColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
                padding: EdgeInsets.fromLTRB(30, 20, 0, 20),
                textColor: fontColor,
                height: 40,
                minWidth: MediaQuery.of(context).size.width,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    AppLocalizations.of(context).translate('privacy_policy'),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                )
              ),
              MaterialButton(
                onPressed: () {
                  signOut();
                  print('User signed out');
                },
                color: backgroundColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
                padding: EdgeInsets.fromLTRB(30, 20, 0, 20),
                textColor: Colors.red, // Use a color that indicates a sign-out action
                height: 40,
                minWidth: MediaQuery.of(context).size.width,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Sign Out', // Replace with AppLocalizations if you have localization set up
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      color: Colors.red, // Use a color that indicates a sign-out action
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
    );
  }
}
