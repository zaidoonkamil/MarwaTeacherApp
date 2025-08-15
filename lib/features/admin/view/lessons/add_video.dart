import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:marwa_teacher/core/styles/themes.dart';

import '../../../../core/widgets/background.dart';

class AddVideo extends StatefulWidget {
  const AddVideo({super.key});

  @override
  State<AddVideo> createState() => _AddVideoState();
}

class _AddVideoState extends State<AddVideo> {
  double progress = 0;
  bool isUploading = false;
  String? uploadedVideoLink;

  final String vimeoToken = "e9737174eff0c80d3ea0b1609d2275ba";

  Future<void> pickAndUploadVideo() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.video,
    );

    if (result != null) {
      File videoFile = File(result.files.single.path!);
      await uploadToVimeo(videoFile);
    }
  }

  Future<void> waitUntilVideoReady(Dio dio, String videoId) async {
    while (true) {
      var statusResponse = await dio.get(
        "https://api.vimeo.com/videos/$videoId",
        options: Options(
          headers: {
            "Authorization": "Bearer $vimeoToken",
            "Accept": "application/vnd.vimeo.*+json;version=3.4",
          },
        ),
      );

      String status = statusResponse.data['status'];
      debugPrint("📡 حالة الفيديو: $status");

      bool hasFiles = (statusResponse.data['files'] != null &&
          (statusResponse.data['files'] as List).isNotEmpty);

      if (status == "available" && hasFiles) {
        debugPrint("✅ الفيديو جاهز بالكامل");
        break;
      }

      await Future.delayed(const Duration(seconds: 5));
    }
  }

  Future<void> uploadToVimeo(File videoFile) async {
    setState(() {
      isUploading = true;
      progress = 0;
    });

    try {
      Dio dio = Dio();

      var createResponse = await dio.post(
        "https://api.vimeo.com/me/videos",
        options: Options(
          headers: {
            "Authorization": "Bearer $vimeoToken",
            "Content-Type": "application/json",
            "Accept": "application/vnd.vimeo.*+json;version=3.4",
          },
        ),
        data: {
          "upload": {
            "approach": "tus",
            "size": videoFile.lengthSync().toString(),
          },
          "name": "محاضرة جديدة",
          "description": "محاضرة مرفوعة من التطبيق",
        },
      );

      String uploadLink = createResponse.data['upload']['upload_link'];
      String videoUri = createResponse.data['uri'];
      String videoId = videoUri.split('/').last;

      const int chunkSize = 1024 * 1024;
      int offset = 0;
      RandomAccessFile raf = await videoFile.open();

      while (true) {
        List<int> buffer = await raf.read(chunkSize);
        if (buffer.isEmpty) break;

        await dio.patch(
          uploadLink,
          data: Stream.fromIterable([buffer]),
          options: Options(
            headers: {
              "Content-Type": "application/offset+octet-stream",
              "Upload-Offset": offset.toString(),
              "Tus-Resumable": "1.0.0",
            },
          ),
        );

        offset += buffer.length;
        setState(() {
          progress = offset / videoFile.lengthSync();
        });
      }

      await raf.close();

      await waitUntilVideoReady(dio, videoId);

      String folderId = "26233367";
      await dio.put(
        "https://api.vimeo.com/me/projects/$folderId/videos/$videoId",
        options: Options(
          headers: {
            "Authorization": "Bearer $vimeoToken",
            "Content-Type": "application/json",
          },
        ),
      );

      setState(() {
        uploadedVideoLink = "https://vimeo.com/$videoId";
        isUploading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ تم رفع الفيديو وإضافته للفولدر بنجاح!")),
      );
    } catch (e) {
      setState(() {
        isUploading = false;
      });

      if (e is DioError) {
        debugPrint('Status Code: ${e.response?.statusCode}');
        debugPrint('Response Data: ${e.response?.data}');
      }

      debugPrint("❌ خطأ أثناء الرفع أو الإضافة للفولدر: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("فشل رفع الفيديو أو إضافته للفولدر: $e")),
      );
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("رفع محاضرة")),
      body: Stack(
        children: [
          Background(),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isUploading) ...[
                  CircularProgressIndicator(value: progress,color: primaryColor,),
                  const SizedBox(height: 10),
                  Text("${(progress * 100).toStringAsFixed(0)}%"),
                ] else ...[
                  ElevatedButton(
                    onPressed: pickAndUploadVideo,
                    child: const Text("📤 اختر فيديو وارفعه"),
                  ),
                ],
                if (uploadedVideoLink != null) ...[
                  const SizedBox(height: 20),
                  const Text("رابط الفيديو:"),
                  SelectableText(uploadedVideoLink!),
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }
}
