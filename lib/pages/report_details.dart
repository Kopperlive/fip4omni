import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:fip_my_version/core/core.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class ReportDetails extends StatefulWidget {
  final int reportId;

  const ReportDetails({Key? key, required this.reportId}) : super(key: key);

  @override
  _ReportDetailsState createState() => _ReportDetailsState();
}

class _ReportDetailsState extends State<ReportDetails> {
  late Future<Report> reportDetails;
  late Map<String, dynamic> status = {};
  int? selectedStatus;

  @override
  void initState() {
    super.initState();
    reportDetails = getReportDetails(widget.reportId);
    getStatus();
  }

  Future<void> getStatus() async {
  final response = await http.get(
    Uri.parse('$protocol://$domain/api/v1/status/'),
    headers: headers,
  );

  if (response.statusCode == 200) {
    List<dynamic> jsonList = json.decode(response.body);

    Map<String, dynamic> statusMap = {
      for (var status in jsonList) status['id'].toString(): status
    };

    setState(() {
      status = statusMap;
    });
    print(status);
  } else {
    print('Failed to get status. Status code: ${response.statusCode}');
  }
}

  Future<Report> getReportDetails(int reportId) async {
    final response = await http.get(
      Uri.parse('$protocol://$domain/api/v1/report/$reportId'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      var reportJson = json.decode(response.body);

      List<ReportFile> reportFiles = await Future.wait(
        (reportJson['files'] as List).map((fileId) async => await getFileDetails(fileId))
      );

      return Report(
        id: reportJson['id'] ?? -1, // Assuming -1 is an invalid ID
        title: reportJson['title'] ?? 'No Title',
        text: reportJson['text'] ?? 'No Description',
        files: reportFiles,
        recipients: List<String>.from(reportJson['recipients'] ?? []),
        createdAt: reportJson['created_at'] != null ? DateTime.parse(reportJson['created_at']) : DateTime.now(),
        updatedAt: reportJson['updated_at'] != null ? DateTime.parse(reportJson['updated_at']) : DateTime.now(),
        deletedAt: reportJson['deleted_at'] != null ? DateTime.parse(reportJson['deleted_at']) : null,
        deadline: reportJson['deadline'] != null ? DateTime.parse(reportJson['deadline']) : DateTime.now(),
        status: reportJson['status'] ?? 0,
      );
    } else {
      throw Exception('Failed to load report details. Status code: ${response.statusCode}');
    }
  }

  Future<ReportFile> getFileDetails(int fileId) async {
    final response = await http.get(
      Uri.parse('$protocol://$domain/api/v1/common/file/$fileId'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      var fileData = json.decode(response.body);
      return ReportFile.fromJson(fileData);
    } else {
      throw Exception('Failed to load file details. Status code: ${response.statusCode}');
    }
  }

  Future<void> updateStatus(int reportId, int statusId) async {
    final response = await http.patch(
      Uri.parse('$protocol://$domain/api/v1/report/$reportId'),
      headers: headers,
      body: json.encode({
        'status': statusId,
      }),
    );

    if (response.statusCode == 200) {
      // If the server returns an OK response, refresh the report details.
      setState(() {
        reportDetails = getReportDetails(widget.reportId);
      });
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to update report status. Status code: ${response.statusCode}');
    }
  }

  
void downloadAndOpenFile(String fileUrl) async {
  final file = await _fetchFile(fileUrl);
  if (file != null) {
    final result = await OpenFile.open(file.path);
    if (result.type != ResultType.done) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to open the file.')),
      );
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to download the file.')),
    );
  }
}

Future<File?> _fetchFile(String fileUrl) async {
  try {
    final response = await http.get(Uri.parse(fileUrl));
    if (response.statusCode == 200) {
      final bytes = response.bodyBytes;

      // Getting the Downloads directory path
      Directory downloadsDirectory = (await getExternalStorageDirectory())!;
      String downloadsPath = downloadsDirectory.path;

      // Path for a subfolder inside the Downloads directory for the app
      String appFolderPath = p.join(downloadsPath, 'OmnicommFiles');

      final appDirectory = Directory(appFolderPath);
      if (!await appDirectory.exists()) {
        await appDirectory.create(recursive: true);
      }

      // Define the file path and write the file as bytes.
      final filePath = p.join(appDirectory.path, p.basename(fileUrl));
      final file = File(filePath);
      await file.writeAsBytes(bytes);

      return file;
    }
  } catch (e) {
    print('Error downloading file: $e');
  }
  return null;
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report Details'),
      ),
      body: FutureBuilder<Report>(
        future: reportDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('Report not found'));
          } else {
            Report report = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text(report.title),
                      subtitle: Text('Deadline: ${report.deadline.toString()}'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Description: ${report.text}'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: report.files.map((reportFile) {
                          return ListTile(
                            title: Text(reportFile.name),
                            trailing: IconButton(
                              icon: Icon(Icons.download),
                              onPressed: () => downloadAndOpenFile(reportFile.fileUrl),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    if (report.recipients.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Recipients: ${report.recipients.join(', ')}'),
                      ),
                    // DropdownButtonFormField<int>(
                    //     value: selectedStatus,
                    //     items: status.entries
                    //         .map<DropdownMenuItem<int>>((entry) => DropdownMenuItem(
                    //               value: int.parse(entry.key),
                    //               child: Text(entry.value),
                    //             ))
                    //         .toList(),
                    //     onChanged: (int? newValue) {
                    //       if (newValue != null) {
                    //         setState(() {
                    //           selectedStatus = newValue;
                    //         });
                    //         updateStatus(report.id, newValue);
                    //       }
                    //     },
                    //     decoration: InputDecoration(
                    //       labelText: "Update Status",
                    //       filled: true,
                    //       fillColor: Colors.white,
                    //       border: OutlineInputBorder(
                    //         borderRadius: BorderRadius.circular(10.0),
                    //       ),
                    //     ),
                    // ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

class Report {
  int id;
  String title;
  String text;
  List<ReportFile> files;
  List<String> recipients;
  DateTime createdAt;
  DateTime updatedAt;
  DateTime? deletedAt;
  DateTime deadline;
  int status;

  Report({
    required this.id,
    required this.title,
    required this.text,
    required this.files,
    required this.recipients,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.deadline,
    required this.status,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    var fileIds = json['files'] as List<dynamic>?;
    var recipientsList = json['recipients'] as List<dynamic>?;

    return Report(
      id: json['id'] ?? -1, // Provide a default id
      title: json['title'] ?? 'No title provided', // Provide a default title
      text: json['text'] ?? 'No text provided', // Provide a default text
      files: fileIds != null ? List<ReportFile>.from(fileIds.map((fileId) => ReportFile.fromId(fileId)).toList()) : [],
      recipients: recipientsList != null ? List<String>.from(recipientsList) : [],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : DateTime.now(),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : DateTime.now(),
      deletedAt: json['deleted_at'] != null ? DateTime.parse(json['deleted_at']) : null,
      deadline: json['deadline'] != null ? DateTime.parse(json['deadline']) : DateTime.now(),
      status: json['status'] ?? 0,
    );
  }
}

class ReportFile {
  final int id;
  final String name;
  final String fileUrl;

  ReportFile({
    required this.id,
    required this.name,
    required this.fileUrl,
  });

  static Future<ReportFile> fromId(int id) async {
    // Perform your logic to get the file details based on the ID
    final response = await http.get(
      Uri.parse('$protocol://$domain/api/v1/common/file/$id'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return ReportFile.fromJson(json.decode(response.body));
    } else {
      return ReportFile(
        id: id,
        name: 'File $id',
        fileUrl: 'default/path',
      );
    }
  }

  factory ReportFile.fromJson(Map<String, dynamic> json) {
    String defaultFileUrl = json['file'] ?? 'default/path';
    String fileName = defaultFileUrl.split('/').last;

    return ReportFile(
      id: json['id'] ?? -1, 
      name: fileName,
      fileUrl: defaultFileUrl, 
    );
  }
}