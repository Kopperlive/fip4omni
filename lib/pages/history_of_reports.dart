import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; 
import 'package:fip_my_version/core/core.dart';

class HistoryOfReportsPage extends StatefulWidget {
  @override
  _HistoryOfReportsPageState createState() => _HistoryOfReportsPageState();
}

class _HistoryOfReportsPageState extends State<HistoryOfReportsPage> {
  late Map<String, dynamic> userInfo = {};
  late List<Report> reports = [];
  late List<Report> filteredReports = [];
  Map<int, bool> selectedStatusFilters = {};
  DateTime? startDateFilter;
  DateTime? endDateFilter;

  @override
  void initState() {
    super.initState();
    getUserInfo();
    loadReports();
  }

  Future<void> getUserInfo() async {
    final response = await http.get(Uri.parse('$protocol://$domain/api/v1/user/'), headers: headers);
    if (response.statusCode == 200) {
      setState(() {
        userInfo = json.decode(response.body);
      });
    } else {
      print('Failed to get user info. Status code: ${response.statusCode}');
    }
  }

  Future<void> loadReports() async {
    final response = await http.get(Uri.parse('$protocol://$domain/api/v1/report/'), headers: headers);
    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      setState(() {
        reports = jsonList.map((json) => Report.fromJson(json)).toList();
        applyFilters(); 
      });
    } else {
      print('Failed to load reports. Status code: ${response.statusCode}');
    }
  }

  void applyFilters() {
    setState(() {
      filteredReports = reports.where((report) {
        bool dateFilterCheck = startDateFilter != null && endDateFilter != null &&
                               report.createdAt.isAfter(startDateFilter!) &&
                               report.createdAt.isBefore(endDateFilter!);
        bool statusFilterCheck = selectedStatusFilters.entries.any((entry) => entry.value && report.status == entry.key);
        return dateFilterCheck && statusFilterCheck;
      }).toList();
    });
  }

  void toggleStatusFilter(int status) {
    setState(() {
      selectedStatusFilters[status] = !(selectedStatusFilters[status] ?? false);
      applyFilters();
    });
  }

  Future<void> selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: (isStart ? startDateFilter : endDateFilter) ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          startDateFilter = picked;
        } else {
          endDateFilter = picked;
        }
        applyFilters();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('History of Reports')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            userInfoSection(),
            filterSection(),
            reportsList(),
          ],
        ),
      ),
    );
  }

  Widget userInfoSection() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Text(
        "${userInfo['last_name'] ?? ''} ${userInfo['first_name'] ?? ''} ${userInfo['middle_name'] ?? ''}",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
    );
  }

  Widget filterSection() {
    return Column(
      children: [
        Wrap(
          children: List.generate(3, (index) => filterChip(3 + index, ['In Process', 'Not Completed', 'Completed'][index], [Colors.yellow, Colors.red, Colors.green][index])),
        ),
        datePickerRow(),
      ],
    );
  }

  Widget datePickerRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () => selectDate(context, true),
          child: Text('Start Date: ${startDateFilter != null ? DateFormat('yyyy-MM-dd').format(startDateFilter!) : 'Select'}'),
        ),
        ElevatedButton(
          onPressed: () => selectDate(context, false),
          child: Text('End Date: ${endDateFilter != null ? DateFormat('yyyy-MM-dd').format(endDateFilter!) : 'Select'}'),
        ),
      ],
    );
  }

  Widget filterChip(int status, String label, Color color) {
    return FilterChip(
      label: Text(label),
      backgroundColor: color.withOpacity(0.3),
      selectedColor: color,
      checkmarkColor: Colors.white,
      selected: selectedStatusFilters[status] ?? false,
      onSelected: (bool isSelected) => toggleStatusFilter(status),
    );
  }

  Widget reportsList() {
    return Column(
      children: filteredReports.map((report) => reportCard(report)).toList(),
    );
  }


Widget reportCard(Report report) {
  return Card(
    color: _getCardColor(report.status),
    child: ListTile(
      title: Text(report.title),
      subtitle: Text('Deadline: ${DateFormat('yyyy-MM-dd').format(report.deadline)}'),
      trailing: IconButton(
        icon: Icon(Icons.arrow_forward),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ReportDetails(reportId: report.id)),
          );
        },
      ),
    ),
  );
}


  Color _getCardColor(int status) {
    switch (status) {
      case 3:
        return Colors.yellow.shade200;
      case 4:
        return Colors.red.shade200;
      case 5:
        return Colors.green.shade200;
      default:
        return Colors.grey.shade200;
    }
  }
}