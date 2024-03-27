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

  @override
  void initState() {
    super.initState();
    reportDetails = getReportDetails(widget.reportId);
  }

  Future<Report> getReportDetails(int reportId) async {
    final response = await http.get(
      Uri.parse('$protocol://$domain/api/v1/report/$reportId'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      var reportJson = json.decode(response.body);
      // Assuming the 'files' field contains a list of file IDs
      List<ReportFile> reportFiles = await Future.wait(
        (reportJson['files'] as List).map((fileId) => getFileDetails(fileId)).toList(),
      );
      return Report(
        id: reportJson['id'],
        title: reportJson['title'],
        text: reportJson['text'],
        files: reportFiles,
        recipients: List<String>.from(reportJson['recipients']),
        deadline: DateTime.parse(reportJson['deadline']),
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

  void downloadFile(String fileUrl) async {
    if (await canLaunch(fileUrl)) {
      await launch(fileUrl);
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
  final int id;
  final String title;
  final String text;
  final List<ReportFile> files; // Now using ReportFile class to include file details
  final List<String> recipients;
  final DateTime deadline;

  Report({
    required this.id,
    required this.title,
    required this.text,
    required this.files,
    required this.recipients,
    required this.deadline,
  });
}

class ReportFile {
  final int id;
  final String name; // name of the file
  final String fileUrl; // the URL for downloading the file

  ReportFile({
    required this.id,
    required this.name,
    required this.fileUrl,
  });

  factory ReportFile.fromJson(Map<String, dynamic> json) {
    String url = json['file']; // assuming 'file' is the key for the file URL
    String fileName = url.split('/').last; // Extracting the file name from URL

    return ReportFile(
      id: json['id'],
      name: fileName,
      fileUrl: url,
    );
  }
}

