import 'package:flutter/material.dart';
import 'package:fip_my_version/core/core.dart';

class ChangeLanguage extends StatefulWidget {
  @override
  _ChangeLanguageState createState() => _ChangeLanguageState();
}

class _ChangeLanguageState extends State<ChangeLanguage> {

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
      Color backgroundColor = themeProvider.isDarkMode
        ? Color.fromRGBO(21, 21, 21, 1)
        : Colors.white;
    Color fontColor = themeProvider.isDarkMode
        ? Colors.white
        : Colors.black;
    Color iconColor = themeProvider.isDarkMode
        ? Colors.white
        : Color(0xff212435);
    return Scaffold(
      backgroundColor: backgroundColor,
      // bottomNavigationBar: BottomBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
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
                    height: 100,
                    width: MediaQuery.of(context).size.width * 0.1,
                    fit: BoxFit.contain,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    "Turdieva Dilnaza Dilmuratovna",
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
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                    child: IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      color: iconColor,
                      iconSize: 28,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Text(
                      AppLocalizations.of(context).translate('language'),
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        fontSize: 22,
                        color: fontColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Expanded(
            flex: 1,
            child: ListView(
              // Your ListView code remains unchanged
              children: [
                languageTile(context, 'en', AppLocalizations.of(context).translate('English')),
                languageTile(context, 'fr', AppLocalizations.of(context).translate('French')),
                languageTile(context, 'ru', AppLocalizations.of(context).translate('Russian')),
                languageTile(context, 'kg', AppLocalizations.of(context).translate('Kyrgyz')),
                // Keep adding more languages as needed, ensuring their names are localized
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget languageTile(BuildContext context, String value, String title) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(fontSize: 18),
      ),
      leading: Radio<String>(
        value: value,
        groupValue: Provider.of<LanguageProvider>(context).locale.languageCode,
        onChanged: (String? selectedLanguage) {
          Provider.of<LanguageProvider>(context, listen: false).updateLocale(Locale(selectedLanguage!));
        },
        activeColor: Colors.orange,
      ),
    );
  }
}