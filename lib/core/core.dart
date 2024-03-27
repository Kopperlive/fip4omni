export 'package:http/http.dart';
export 'dart:convert';
export 'package:provider/provider.dart';
import 'package:flutter/material.dart';
export 'dart:io';
export 'package:open_file/open_file.dart';
export 'package:flutter_downloader/flutter_downloader.dart';
export 'package:intl/intl.dart';
export 'package:image_picker/image_picker.dart';
export 'package:file_picker/file_picker.dart';

export 'package:fip_my_version/pages/change_password.dart';
export 'package:fip_my_version/pages/language_page.dart';
export 'package:fip_my_version/pages/edit_profile_screen.dart';
export 'package:fip_my_version/pages/privacy_policy_screen.dart';
export 'package:fip_my_version/pages/report_details.dart';
export 'package:fip_my_version/core/language_provider.dart';
export 'package:fip_my_version/core/AppLocalizations.dart';
export 'package:fip_my_version/pages/bar/bottom_bar.dart';
export 'package:fip_my_version/pages/main_page.dart';
export 'package:fip_my_version/pages/settings_page.dart';
export 'package:fip_my_version/core/theme_provider.dart';
export 'package:fip_my_version/pages/pages_provider.dart';
export 'package:fip_my_version/pages/chats_screen.dart';
export 'package:fip_my_version/pages/chat_screen.dart';
export 'package:fip_my_version/pages/create_report.dart';


import 'package:fip_my_version/core/core.dart';

Map<String, String> headers = {
  'Accept': 'application/json',
  'Content-Type': 'application/json',
};

String protocol = 'http';

String domain = 'user121459.pythonanywhere.com';

enum SlideDirection { left, right }

final List<Widget> _pages = [
    ChangeLanguage(), // Page 0
    HomePage(),    // Page 1 (Home)
    SettingsScreen(),       // Page 2
  ];


class Report {
  int id;
  String title;
  String text;
  List<int> files;
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
      files: List<int>.from(json['files']),
      recipients: List<String>.from(json['recipients']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      deletedAt: json['deleted_at'] != null ? DateTime.parse(json['deleted_at']) : null,
      deadline: json['deadline'],
      status: json['status'] as int,
    );
  }
}


class ReportsList {
  List<Report> reports;

  ReportsList({required this.reports});

  factory ReportsList.fromJson(List<dynamic> parsedJson) {
    List<Report> reports = parsedJson.map((i) => Report.fromJson(i)).toList();
    return ReportsList(reports: reports);
  }
}


class UserProfile {
  String name;
  String email;
  String phoneNumber;
  String country;
  String gender;
  String telegramNickname;
  String imageUrl; // Added for profile image

  UserProfile({
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.country,
    required this.gender,
    required this.telegramNickname,
    required this.imageUrl, // Initialize the image path in the constructor
  });
}

class ProfileManager {
  static UserProfile userProfile = UserProfile(
    name: "Turdieva Dilnaza Dilmuratovna",
    email: "turdieva_d@auca.kg",
    phoneNumber: "+996 555 555 555",
    country: "kyrgyzstan",
    gender: "female",
    telegramNickname: "@yorunmichi",
    imageUrl: 'https://i.redd.it/3ntdykbuoi271.jpg', // Initial imageUrl is null
  );

  static void updateProfile({
    String? email,
    String? phoneNumber,
    String? country,
    String? gender,
    String? telegramNickname,
    String? imageUrl, // Add imagePath parameter
  }) {
    userProfile = UserProfile(
      name: userProfile.name,
      email: email ?? userProfile.email,
      phoneNumber: phoneNumber ?? userProfile.phoneNumber,
      country: country ?? userProfile.country,
      gender: gender ?? userProfile.gender,
      telegramNickname: telegramNickname ?? userProfile.telegramNickname,
      imageUrl: imageUrl ?? userProfile.imageUrl, // Update imagePath
    );
  }
}



class Chat {
  final String id;
  final DateTime created;
  final DateTime updated;
  final DateTime deleted;
  final String header;
  final List<int> participants;
  final List<Message> messages;
  final String imageUrl; // Added imageUrl field

  Chat({
    required this.id,
    required this.created,
    required this.updated,
    required this.deleted,
    required this.header,
    required this.participants,
    required this.messages,
    required this.imageUrl, // Initialize imageUrl in the constructor
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['ID'],
      created: DateTime.parse(json['created']),
      updated: DateTime.parse(json['updated']),
      deleted: DateTime.parse(json['deleted']),
      header: json['header'],
      participants: List<int>.from(json['participants']),
      messages: (json['last message'] as List)
          .map((messageJson) => Message.fromJson(messageJson))
          .toList(),
      imageUrl: json['imageUrl'], // Extract imageUrl from JSON
    );
  }
}

class Message {
  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime deletedAt;
  final String text;
  final int user;
  final int chat;

  Message({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.text,
    required this.user,
    required this.chat,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      deletedAt: DateTime.parse(json['deleted_at']),
      text: json['text'],
      user: json['user'],
      chat: json['chat'],
    );
  }
}
