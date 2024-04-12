import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fip_my_version/core/core.dart';

class HistoryOfReportsPage extends StatefulWidget {
  @override
  _HistoryOfReportsPageState createState() => _HistoryOfReportsPageState();
}

class _HistoryOfReportsPageState extends State<HistoryOfReportsPage> {
  late Map<String, dynamic> userInfo = {};
  late List<Report> reports = [];

  @override
  void initState() {
    super.initState();
    getUserInfo();
    loadReports();
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
      reports = jsonList
          .map((json) => Report.fromJson(json))
          .toList();
    });
    } else {
    // Handle the error or provide feedback to the user
    print('Failed to load reports. Status code: ${response.statusCode}');
  }
}
Color _getCardColor(int status) {
    switch (status) {
      case 1:
        return Colors.white;
      case 2:
        return Colors.yellow;
      case 3:
        return Colors.green;
      case 4:
        return Colors.red;
      default:
        return Colors.white;
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
            Padding(
              padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  for (var report in reports)
                  Card(
                    margin: EdgeInsets.symmetric(vertical: 4, horizontal: 30),
                    color: _getCardColor(report.status),
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
          ],
        ),
      )
    );
  }
}