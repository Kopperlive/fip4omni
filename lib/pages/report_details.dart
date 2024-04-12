import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:fip_my_version/core/core.dart';

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

    var fileFutures = (reportJson['files'] as List)
        .map<Future<ReportFile>>((fileId) => getFileDetails(fileId))
        .toList();

    List<ReportFile> reportFiles = await Future.wait(fileFutures);

    return Report(
      id: reportJson['id'] as int,
      title: reportJson['title'] as String,
      text: reportJson['text'] as String,
      files: reportFiles,
      recipients: List<String>.from(reportJson['recipients']),
      createdAt: DateTime.parse(reportJson['created_at']),
      updatedAt: DateTime.parse(reportJson['updated_at']),
      deletedAt: reportJson['deleted_at'] != null
          ? DateTime.parse(reportJson['deleted_at'])
          : null,
      deadline: reportJson['deadline'],
      status: reportJson['status'] as int,
    );
  } else {
    throw Exception('Failed to load report details. Status code: ${response.statusCode}');
  }
  }

  Future<ReportFile> getFileDetails(int fileId) async {
    final response = await http.get(
      Uri.parse('$protocol://$domain/api/v1/file/$fileId'),
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

  void downloadFile(String fileUrl) async {
    if (await canLaunchUrl(Uri.parse(fileUrl))) {
      await launchUrl(Uri.parse(fileUrl));
    } else {
      throw 'Could not launch $fileUrl';
    }
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
                              onPressed: () => downloadFile(reportFile.fileUrl),
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
                      DropdownButtonFormField<int>(
                    value: selectedStatus,
                    items: status.entries
                        .map<DropdownMenuItem<int>>((entry) => DropdownMenuItem(
                              value: int.parse(entry.key),
                              child: Text(entry.value),
                            ))
                        .toList(),
                    onChanged: (int? newValue) {
                      if (newValue != null) {
                        setState(() {
                          selectedStatus = newValue;
                        });
                        updateStatus(report.id, newValue);
                      }
                    },
                    decoration: InputDecoration(
                      labelText: "Update Status",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
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
  String deadline;
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
    return Report(
      id: json['id'] as int,
      title: json['title'] as String,
      text: json['text'] as String,
      files: (json['files'] as List<dynamic>)
          .map((fileId) => ReportFile.fromId(fileId as int))
          .toList(),
      recipients: List<String>.from(json['recipients']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      deletedAt: json['deleted_at'] != null ? DateTime.parse(json['deleted_at']) : null,
      deadline: json['deadline'],
      status: json['status'] as int,
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

  factory ReportFile.fromJson(Map<String, dynamic> json) {
    return ReportFile(
      id: json['id'] as int,
      name: json['name'] as String,
      fileUrl: json['file'] as String,
    );
  }

  factory ReportFile.fromId(int id) {
    return ReportFile(
      id: id,
      name: 'File $id',
      fileUrl: 'path/to/file/$id',
    );
  }
}