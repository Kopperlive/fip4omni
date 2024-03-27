import 'package:flutter/material.dart';
import 'package:fip_my_version/core/core.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class CreateReport extends StatefulWidget {
  @override
  _CreateReportState createState() => _CreateReportState();
}

class _CreateReportState extends State<CreateReport> {
  TextEditingController toController = TextEditingController();
  TextEditingController fromController = TextEditingController();
  TextEditingController themeController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  late Map<String, dynamic> userInfo = {};
  final List<Map<String, dynamic>> _attachedFileData = [];

  @override
  void dispose() {
    toController.dispose();
    fromController.dispose();
    themeController.dispose();
    messageController.dispose();
    dateController.dispose();
    super.dispose();
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(selectedDate),
      );
      if (pickedTime != null) {
        setState(() {
          selectedDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          dateController.text = DateFormat('yyyy-MM-dd – kk:mm').format(selectedDate);
        });
      }
    }
  }

  Future<void> createReport(List<int> fileIds) async {
  var apiUrl = Uri.parse('$protocol://$domain/api/v1/report/');

  List<int> fileIds = _attachedFileData.map<int>((file) => file['id'] as int).toList();

  Map<String, dynamic> reportData = {
    'files': fileIds, // Assuming this is an empty array for now
    'recipients': toController.text.split(',').map((e) => e.trim()).toList(), // Split recipients by comma and trim spaces
    'title': themeController.text,
    'text': messageController.text,
    'deadline': selectedDate.toIso8601String(),
    'status': 1,
  };

  print('Creating report with data: $reportData');

  var response = await http.post(
    apiUrl,
    headers: headers,
    body: jsonEncode(reportData),
  );

  if (response.statusCode == 201) {
    // Successfully created the report
    print('Report created: ${response.body}');
    // Handle success, like navigating to another page or showing a success message
  } else {
    // If the server did not return a CREATED response,
    // then throw an exception.
    throw Exception('Failed to create report: ${response.body}');
  }
}

Future<int> uploadFile(File file) async {
  var request = http.MultipartRequest('POST', Uri.parse('$protocol://$domain/api/v1/file/'))
    ..headers.addAll(headers)
    ..files.add(
      http.MultipartFile(
        'file', // This should match the name expected by the server.
        file.readAsBytes().asStream(),
        file.lengthSync(),
        filename: path.basename(file.path),
      ),
    );
  
  var response = await request.send();

  if (response.statusCode == 201) {
    final responseData = await response.stream.toBytes();
    final responseString = String.fromCharCodes(responseData);
    var decoded = json.decode(responseString);
    return decoded['id']; // Assuming the 'id' field holds the file ID
  } else {
    // Handle the error, maybe throw an exception
    throw Exception('Failed to upload file. Status code: ${response.statusCode}');
  }
}


  Future<void> pickAndUploadFile() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles();
  
  if (result != null) {
    File file = File(result.files.single.path!);
    int fileId = await uploadFile(file);
    
    // Assuming you have a method to upload the file and it returns the file's ID
    setState(() {
      // Add the uploaded file's metadata to _attachedFileData
      _attachedFileData.add({
        'id': fileId,
        'name': path.basename(file.path),
        // You can add more file information here if needed
      });
    });
  }
}

Future<void> handleSubmit() async {
  try {
    // Extract file IDs from _attachedFileData
    List<int> fileIds = _attachedFileData.map<int>((file) => file['id'] as int).toList();

    // Create the report with the file IDs
    await createReport(fileIds);

    // After successfully creating the report, you may want to clear the list
    setState(() {
      _attachedFileData.clear();
    });

    // Handle post-report creation logic here (like navigation or showing a message)
  } catch (e) {
    // Handle the error (e.g., show an error message)
    print('Error occurred: $e');
  }
}



  void _showFileAttachmentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Attached Files'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _attachedFileData.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(path.basename(_attachedFileData[index]['name'])),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        _attachedFileData.removeAt(index);
                      });
                      // Optionally, also handle the deletion from the server
                    },
                  ),
                );
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Add File'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog before opening file picker
                pickAndUploadFile();
              },
            ),
            TextButton(
              child: Text('Done'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }


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
    }
    else {
      print('Failed to get full name. Status code: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            margin: EdgeInsets.all(0),
            padding: EdgeInsets.all(0),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.1,
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
                  padding: EdgeInsets.fromLTRB(20, 0, 10, 0),
                  child:
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
                    (userInfo['last_name'] ?? '') + ' ' + (userInfo['first_name'] ?? '') + ' ' + (userInfo['middle_name'] ?? ''),
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
              Padding(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      color: Color(0xff212435),
                      iconSize: 24,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        IconButton(
                          icon: Stack(
                            alignment: Alignment.topRight,
                            children: <Widget>[
                              Icon(Icons.insert_link),
                              if (_attachedFileData.isNotEmpty)
                                CircleAvatar(
                                  radius: 10,
                                  backgroundColor: Colors.red,
                                  child: Text(
                                    _attachedFileData.length.toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          onPressed: _showFileAttachmentDialog, // Open the attachment dialog
                          color: Color(0xff212435),
                          iconSize: 24,
                        ),
                        IconButton(
                          icon: Icon(Icons.play_arrow),
                          onPressed: () {
                            handleSubmit();
                          },
                          color: Color(0xfffb8b25),
                          iconSize: 28,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            child: TextField(
              controller: toController,
              obscureText: false,
              textAlign: TextAlign.start,
              maxLines: 1,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
                fontSize: 14,
                color: Color(0xff000000),
              ),
              decoration: InputDecoration(
                disabledBorder: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(4.0),
                  borderSide: BorderSide(color: Color(0xff000000), width: 1),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(4.0),
                  borderSide: BorderSide(color: Color(0xff000000), width: 1),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(4.0),
                  borderSide: BorderSide(color: Color(0xff000000), width: 1),
                ),
                hintText: "To",
                hintStyle: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  fontSize: 14,
                  color: Color(0xff6b6b6b),
                ),
                filled: true,
                fillColor: Color(0xffffffff),
                isDense: false,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            child: TextField(
              controller: fromController,
              obscureText: false,
              textAlign: TextAlign.start,
              maxLines: 1,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
                fontSize: 14,
                color: Color(0xff000000),
              ),
              decoration: InputDecoration(
                disabledBorder: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(4.0),
                  borderSide: BorderSide(color: Color(0xff000000), width: 1),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(4.0),
                  borderSide: BorderSide(color: Color(0xff000000), width: 1),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(4.0),
                  borderSide: BorderSide(color: Color(0xff000000), width: 1),
                ),
                hintText: "From",
                hintStyle: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  fontSize: 14,
                  color: Color(0xff6b6b6b),
                ),
                filled: true,
                fillColor: Color(0xffffffff),
                isDense: false,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            child: TextField(
              controller: themeController,
              obscureText: false,
              textAlign: TextAlign.start,
              maxLines: 1,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.normal,
                fontSize: 14,
                color: Color(0xff000000),
              ),
              decoration: InputDecoration(
                disabledBorder: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(4.0),
                  borderSide: BorderSide(color: Color(0xff000000), width: 1),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(4.0),
                  borderSide: BorderSide(color: Color(0xff000000), width: 1),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderRadius: BorderRadius.circular(4.0),
                  borderSide: BorderSide(color: Color(0xff000000), width: 1),
                ),
                hintText: "Theme",
                hintStyle: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  fontSize: 14,
                  color: Color(0xff6b6b6b),
                ),
                filled: true,
                fillColor: Color(0xffffffff),
                isDense: false,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            child: TextField(
                controller: dateController,
                decoration: InputDecoration(
                  labelText: 'Deadline',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () {
                  FocusScope.of(context).requestFocus(new FocusNode());
                  _selectDateTime(context);
                },
              ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 20),
              child: TextField(
                controller: messageController,
                obscureText: false,
                textAlign: TextAlign.start,
                maxLines: 1,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  fontSize: 14,
                  color: Color(0xff000000),
                ),
                decoration: InputDecoration(
                  disabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  hintText: "White message",
                  hintStyle: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 14,
                    color: Color(0xff6b6b6b),
                  ),
                  filled: true,
                  fillColor: Color(0xffffffff),
                  isDense: false,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
