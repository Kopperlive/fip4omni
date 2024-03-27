  // import 'package:flutter/material.dart';
  // import 'package:smooth_page_indicator/smooth_page_indicator.dart';
  // // import 'flutterViz_bottom_navigationBar_model.dart';



  // class HomePage extends StatelessWidget {
  //   final pageController = PageController();
  //   // List<FlutterVizBottomNavigationBarModel> flutterVizBottomNavigationBarItems =
  //   //     [
  //   //   FlutterVizBottomNavigationBarModel(icon: Icons.chat, label: "Chats"),
  //   //   FlutterVizBottomNavigationBarModel(icon: Icons.home, label: "Home"),
  //   //   FlutterVizBottomNavigationBarModel(icon: Icons.settings, label: "Settings")
  //   // ];
    
  //   @override
  //   Widget build(BuildContext context) {
  //     return Scaffold(
  //       backgroundColor: Color(0xffffffff),
  //       // bottomNavigationBar: BottomNavigationBar(
  //       //   items: flutterVizBottomNavigationBarItems
  //       //       .map((FlutterVizBottomNavigationBarModel item) {
  //         //   return BottomNavigationBarItem(
  //         //     icon: Icon(item.icon),
  //         //     label: item.label,
  //         //   );
  //         // }).toList(),
  //       //   backgroundColor: Color(0xff000000),
  //       //   currentIndex: 1,
  //       //   elevation: 8,
  //       //   iconSize: 24,
  //       //   selectedItemColor: Color(0xfffb8b25),
  //       //   unselectedItemColor: Color(0xff9e9e9e),
  //       //   selectedFontSize: 14,
  //       //   unselectedFontSize: 14,
  //       //   showSelectedLabels: false,
  //       //   showUnselectedLabels: false,
  //       //   onTap: (value) {},
  //       // ),
  //       body: Column(
  //         mainAxisAlignment: MainAxisAlignment.start,
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         mainAxisSize: MainAxisSize.max,
  //         children: [
  //           Container(
  //             alignment: Alignment.center,
  //             margin: EdgeInsets.all(0),
  //             padding: EdgeInsets.all(0),
  //             width: MediaQuery.of(context).size.width,
  //             height: MediaQuery.of(context).size.height * 0.15,
  //             decoration: BoxDecoration(
  //               color: Color(0xff000000),
  //               shape: BoxShape.rectangle,
  //               borderRadius: BorderRadius.zero,
  //               border: Border.all(color: Color(0x4d9e9e9e), width: 1),
  //             ),
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.start,
  //               crossAxisAlignment: CrossAxisAlignment.center,
  //               mainAxisSize: MainAxisSize.max,
  //               children: [
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.start,
  //                   crossAxisAlignment: CrossAxisAlignment.center,
  //                   mainAxisSize: MainAxisSize.max,
  //                   children: [
  //                     Padding(
  //                       padding: EdgeInsets.fromLTRB(20, 0, 5, 0),
  //                       child:

  //                           ///***If you have exported images you must have to copy those images in assets/images directory.
  //                           Image(
  //                         image: AssetImage("images/img_ellipse_7.png"),
  //                         height: 100,
  //                         width: MediaQuery.of(context).size.width * 0.1,
  //                         fit: BoxFit.contain,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //                 Expanded(
  //                   flex: 1,
  //                   child: Align(
  //                     alignment: Alignment(0.0, 0.0),
  //                     child: Text(
  //                       "Turdieva Dilnaza Dilmuratovna",
  //                       textAlign: TextAlign.center,
  //                       overflow: TextOverflow.clip,
  //                       style: TextStyle(
  //                         fontWeight: FontWeight.w400,
  //                         fontStyle: FontStyle.normal,
  //                         fontSize: 20,
  //                         color: Color(0xffffffff),
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //           Column(
  //             mainAxisAlignment: MainAxisAlignment.start,
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             mainAxisSize: MainAxisSize.max,
  //             children: [
  //               SizedBox(
  //                 height: MediaQuery.of(context).size.height * 0.25,
  //                 width: MediaQuery.of(context).size.width,
  //                 child: Stack(
  //                   children: [
  //                     PageView.builder(
  //                       controller: pageController,
  //                       scrollDirection: Axis.horizontal,
  //                       itemCount: 3,
  //                       itemBuilder: (context, position) {
  //                         return Padding(
  //                           padding: EdgeInsets.fromLTRB(0, 10, 0, 15),
  //                           child: Image.asset(
  //                             "images/img_rectangle.png",
  //                             height: MediaQuery.of(context).size.height,
  //                             width: MediaQuery.of(context).size.width,
  //                             fit: BoxFit.contain,
  //                           ),
  //                         );
  //                       },
  //                     ),
  //                     Align(
  //                       alignment: Alignment.bottomCenter,
  //                       child: SmoothPageIndicator(
  //                         controller: pageController,
  //                         count: 3,
  //                         axisDirection: Axis.horizontal,
  //                         effect: ScrollingDotsEffect(
  //                           dotColor: Color(0xff9e9e9e),
  //                           activeDotColor: Color(0xffff8d25),
  //                           dotHeight: 9,
  //                           dotWidth: 9,
  //                           radius: 10,
  //                           spacing: 8,
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ],
  //           ),
  //           Padding(
  //             padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.start,
  //               crossAxisAlignment: CrossAxisAlignment.center,
  //               mainAxisSize: MainAxisSize.max,
  //               children: [
  //                 Text(
  //                   "Please, confirm reports",
  //                   textAlign: TextAlign.start,
  //                   overflow: TextOverflow.clip,
  //                   style: TextStyle(
  //                     fontWeight: FontWeight.w400,
  //                     fontStyle: FontStyle.normal,
  //                     fontSize: 18,
  //                     color: Color(0xff000000),
  //                   ),
  //                 ),
  //                 Card(
  //                   margin: EdgeInsets.symmetric(vertical: 4, horizontal: 30),
  //                   color: Color(0xffffffff),
  //                   shadowColor: Color(0xff000000),
  //                   elevation: 1,
  //                   shape: RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.circular(5.0),
  //                     side: BorderSide(color: Color(0x4d9e9e9e), width: 1),
  //                   ),
  //                   child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     crossAxisAlignment: CrossAxisAlignment.center,
  //                     mainAxisSize: MainAxisSize.max,
  //                     children: [
  //                       Padding(
  //                         padding: EdgeInsets.fromLTRB(1, 0, 0, 0),
  //                         child: Column(
  //                           mainAxisAlignment: MainAxisAlignment.start,
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           mainAxisSize: MainAxisSize.max,
  //                           children: [
  //                             Padding(
  //                               padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
  //                               child: Text(
  //                                 "Theme",
  //                                 textAlign: TextAlign.start,
  //                                 overflow: TextOverflow.clip,
  //                                 style: TextStyle(
  //                                   fontWeight: FontWeight.w400,
  //                                   fontStyle: FontStyle.normal,
  //                                   fontSize: 16,
  //                                   color: Color(0xff000000),
  //                                 ),
  //                               ),
  //                             ),
  //                             Row(
  //                               mainAxisAlignment: MainAxisAlignment.start,
  //                               crossAxisAlignment: CrossAxisAlignment.center,
  //                               mainAxisSize: MainAxisSize.max,
  //                               children: [
  //                                 Padding(
  //                                   padding: EdgeInsets.fromLTRB(5, 5, 0, 5),
  //                                   child:

  //                                       ///***If you have exported images you must have to copy those images in assets/images directory.
  //                                       Image(
  //                                     image:
  //                                         AssetImage("images/Vector.png"),
  //                                     height: 15,
  //                                     width: 15,
  //                                     fit: BoxFit.contain,
  //                                   ),
  //                                 ),
  //                                 Padding(
  //                                   padding: EdgeInsets.fromLTRB(3, 0, 0, 0),
  //                                   child: Text(
  //                                     "file name.pdf",
  //                                     textAlign: TextAlign.start,
  //                                     overflow: TextOverflow.clip,
  //                                     style: TextStyle(
  //                                       fontWeight: FontWeight.w400,
  //                                       fontStyle: FontStyle.normal,
  //                                       fontSize: 12,
  //                                       color: Color(0xff6c6c6c),
  //                                     ),
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                       Padding(
  //                         padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
  //                         child: Container(
  //                           color: Color(0xfffb8b25),
  //                           child: IconButton(
  //                             icon: Icon(Icons.arrow_forward, color: Colors.white),
  //                             iconSize: 24,
  //                             onPressed: (){},
  //                           )
  //                         )
  //                         // child: IconButton(
  //                         //   icon: Icon(Icons.arrow_forward, color: Color(0xfffb8b25)),
  //                         //   onPressed: () {},
  //                         //   iconSize: 24,
  //                         // ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     );
  //   }
  // }


import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:http/http.dart' as http;
import 'package:fip_my_version/core/core.dart';

List<Map<String, dynamic>> imageData = [
  {
    // https://drive.google.com/file/d/1uWKHIsyDIuv0FodmdKtaOSG17X9PEhs5/view?usp=sharing
    'image': "assets/images/how_to_use_omni.png",
  },
  {
    'image': "assets/images/taxes.png",
  },
  {
    'image': "assets/images/communication.png",
  },
];

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final pageController = PageController();
  late List<Report> reports = [];
  late Map<String, dynamic> userInfo = {};
  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    getUserInfo();
    loadReports();
  // getImage();
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
    }
    else {
      print('Failed to get full name. Status code: ${response.statusCode}');
    }
  }
  
  Future<void> loadReports() async {
  // final response = await http.get(Uri.parse('https://user121459.pythonanywhere.com/api/v1/report/'), headers: headers);
  final response = await http.get(Uri.parse('$protocol://$domain/api/v1/report/'), headers: headers);
  print(response.body);
  if (response.statusCode == 200) {
    List<dynamic> jsonList = json.decode(response.body);

    setState(() {
      reports = jsonList.map((json) => Report.fromJson(json)).toList();
    });
    } else {
    // Handle the error or provide feedback to the user
    print('Failed to load reports. Status code: ${response.statusCode}');
  }
}

  Future<void> getImage() async {
  // final response = await http.get(Uri.parse('https://cdn.britannica.com/92/212692-050-D53981F5/labradoodle-dog-stick-running-grass.jpg'), headers: {'Accept': 'image/webp',
  // 'Content-Type': 'image/webp', 'Access-Control-Allow-Origin': '*'});
  // final bytes = response.bodyBytes;
  final response1 = await http.readBytes(Uri.parse('https://cdn.britannica.com/92/212692-050-D53981F5/labradoodle-dog-stick-running-grass.jpg'));
  print(response1);
  // print(bytes);
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
    return Scaffold(
      backgroundColor: backgroundColor,
      // bottomNavigationBar: BottomBar(
      // selectedIndex: _selectedIndex,
      // onTabSelected: _onItemTapped,
    // ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              alignment: Alignment.center,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 5, 0),
                        child:

                            ///***If you have exported images you must have to copy those images in assets/images directory.
                            Image(
                          image: const AssetImage("assets/images/omni_logo_sign_in.png"),
                          height: 100,
                          width: MediaQuery.of(context).size.width * 0.1,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    flex: 1,
                    child: Align(
                      alignment: Alignment(0.0, 0.0),
                      child: Text(
                        (userInfo['last_name'] ?? '') + ' ' + (userInfo['first_name'] ?? '') + ' ' + (userInfo['middle_name'] ?? ''),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.clip,
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          fontSize: 24,
                          color: Color(0xffffffff),
                        ),
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
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.25,
                  width: MediaQuery.of(context).size.width,
                  child: Stack(
                    children: [
                      PageView.builder(
                        controller: pageController,
                        scrollDirection: Axis.horizontal,
                        itemCount: imageData.length,
                        itemBuilder: (context, position) {
                          return Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 15),
                            child: GestureDetector(
                              onTap: () {
                                switch (position) {
                                  case 0:
                                    Navigator.pushNamed(context, '/chatsScreen');
                                    break;
                                  case 1:
                                    Navigator.pushNamed(context, '/editProfile');
                                    break;
                                  case 2:
                                    Navigator.pushNamed(context, '/changeLanguage');
                                    break;
                                  // Add more cases for additional positions/pages
                                  default:
                                    break;
                                }
                              },
                              // child: Image.memory(
                              //   (http.get(
                              //     Uri.parse(imageData[position]['image']),
                              //   )).bodyBytes,
                              //   height: MediaQuery.of(context).size.height,
                              //   width: MediaQuery.of(context).size.width,
                              //   fit: BoxFit.contain,
                              // ),
                              child: Image(
                                image: AssetImage(
                                  imageData[position]['image'],
                                ),
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width,
                                fit: BoxFit.contain,
                              ),
                            )
                          );
                        },
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: SmoothPageIndicator(
                          controller: pageController,
                          count: 3,
                          axisDirection: Axis.horizontal,
                          effect: const ScrollingDotsEffect(
                            dotColor: Color(0xff9e9e9e),
                            activeDotColor: Color(0xffff8d25),
                            dotHeight: 9,
                            dotWidth: 9,
                            radius: 10,
                            spacing: 8,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    AppLocalizations.of(context).translate('Please, confirm reports'),
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      fontSize: 22,
                      color: fontColor,
                    ),
                  ),
                  for (var report in reports)
                  Card(
                    margin: EdgeInsets.symmetric(vertical: 4, horizontal: 30),
                    color: Color(0xffffffff),
                    shadowColor: Color(0xff000000),
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      side: BorderSide(color: Color(0x4d9e9e9e), width: 1),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            report.title,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Color(0xff000000),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Deadline: ${report.deadline}',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Color(0xff6c6c6c),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Files: ${report.files.length}',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Color(0xff6c6c6c),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Sender: ${report.recipients.join(", ")}',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Color(0xff6c6c6c),
                            ),
                          ),
                          SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                // Navigate to the report details page
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ReportDetails(reportId: report.id),
                                  ),
                                );
                              },
                              child: Text(
                                'View Details',
                                style: TextStyle(
                                  color: Color(0xfffb8b25),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
            child: Container(
              margin: EdgeInsets.all(0),
              padding: EdgeInsets.all(0),
              width: MediaQuery.of(context).size.width * 0.14,
              height: MediaQuery.of(context).size.height * 0.07,
              decoration: BoxDecoration(
                color: Color(0xfffb8b25),
                shape: BoxShape.circle,
                border: Border.all(color: Color(0x4d9e9e9e), width: 1),
              ),
              child: IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  Navigator.pushNamed(context, '/createReport');
                },
                color: Color(0xffffffff),
                iconSize: 33,
              ),
            ),)
          ],
        ),
      )
    );
  }
}

