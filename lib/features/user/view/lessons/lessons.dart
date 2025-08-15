import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marwa_teacher/core/styles/themes.dart';
import 'package:marwa_teacher/core/widgets/background.dart';
import 'package:video_player/video_player.dart';

import '../../../../../core/ navigation/navigation.dart';
import '../../../../core/widgets/ScreenCaptureProtection.dart';
import '../../cubit/cubit.dart';
import '../../cubit/states.dart';

class Lessons extends StatefulWidget {
  const Lessons({super.key, required this.videoUrl, required this.title, required this.description, required this.pdfUrl, required this.images, });

  final String videoUrl;
  final String title;
  final String description;
  final String pdfUrl;
  final String images;

  @override
  State<Lessons> createState() => _LessonsState();
}

class _LessonsState extends State<Lessons> {
  VideoPlayerController? _controller;
  ChewieController? _chewieController;
  bool _showVideo = false;

  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    ScreenCaptureProtection.disable();

    _controller?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => UserCubit(),
      child: BlocConsumer<UserCubit,UserStates>(
        listener: (context,state){},
        builder: (context,state){
          var cubit=UserCubit.get(context);
          return SafeArea(
            child: Scaffold(
              body: Stack(
                children: [
                  Background(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      children: [
                        SizedBox(height: 14,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                                onTap: (){
                                  navigateBack(context);
                                },
                                child: Icon(Icons.arrow_back_ios_new)),
                            const Text(
                              textAlign: TextAlign.right,
                              'المحاضرة',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 26,),
                        Expanded(
                          child: SingleChildScrollView(
                            physics: AlwaysScrollableScrollPhysics(),
                            child: Column(
                              children: [
                                _showVideo ?  SizedBox(
                                  height: 200,
                                  child: _chewieController != null
                                      ? Chewie(controller: _chewieController!)
                                      : const Center(child: CircularProgressIndicator()),
                                ): GestureDetector(
                                  onTap: (){
                                    setState(() {
                                      _showVideo = true;
                                      ScreenCaptureProtection.enable();
                                      _controller = VideoPlayerController.network(widget.videoUrl);
                                      _controller!.initialize().then((_) {
                                        _chewieController = ChewieController(
                                          videoPlayerController: _controller!,
                                          autoPlay: true,
                                          looping: false,
                                          showControls: true,
                                          allowFullScreen: true,
                                          allowedScreenSleep: false,
                                        );
                                        setState(() {});
                                      });
                                    });
                                    },
                                  child: Stack(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8),
                                            color: Color(0XFF212529),
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 1,
                                            )
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(12),
                                          child: Image.network(
                                            widget.images,
                                            height: 170,
                                            width: double.maxFinite,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 170,
                                        child: Center(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.grey.withOpacity(0.6),
                                              borderRadius: BorderRadius.circular(30),
                                            ),
                                            child: Icon(Icons.arrow_right,color: Colors.white,size: 60,),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 20),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              widget.title,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.end,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              widget.description,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                                color: Colors.grey,
                                              ),
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.end,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 14),
                                widget.pdfUrl== ''?Container(): GestureDetector(
                                  onTap: (){
                                    cubit.openAttachment(widget.pdfUrl);
                                  },
                                  child: Container(
                                    width: double.maxFinite,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: primaryColor,
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 1.5,
                                        )
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        SizedBox(height: 8),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    'مرفقات الدرس',
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 16,
                                                      color: Colors.white,
                                                    ),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    textAlign: TextAlign.end,
                                                  ),
                                                  SizedBox(width: 10,),
                                                  Container(
                                                    padding: EdgeInsets.all(4),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(4),
                                                      color: Colors.grey.withOpacity(0.5),
                                                    ),
                                                    child: Icon(Icons.newspaper,color: Colors.white,size: 22,),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                      ],
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
            ),
          );
        },
      ),
    );
  }
}
