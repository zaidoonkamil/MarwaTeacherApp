import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marwa_teacher/core/styles/themes.dart';
import '../../../core/ navigation/navigation.dart';
import '../../../core/widgets/background.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';

class HowAs extends StatefulWidget {
  const HowAs({super.key});

  @override
  State<HowAs> createState() => _HowAsState();
}

class _HowAsState extends State<HowAs> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _opacity = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => UserCubit(),
      child: BlocConsumer<UserCubit, UserStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return SafeArea(
            child: Scaffold(
              body: Stack(
                children: [
                  Background(),
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  navigateBack(context);
                                },
                                child: const Icon(Icons.arrow_back_ios_new),
                              ),
                              const Spacer(),
                              const Text(
                                'من نحن',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),

                          AnimatedOpacity(
                            opacity: _opacity,
                            duration: const Duration(milliseconds: 900),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 22),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: primaryColor,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 6,
                                    spreadRadius: 2,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Text(
                                'نحن منصة تعليمية رقمية متخصصة بمادة الكيمياء للصف السادس الإعدادي، بإشراف الأستاذة مروة ماجستير في الكيمياء ، أحد الأساتذة المتميزين في هذا المجال\n\n'
                                    'نسعى إلى تقديم محتوى تعليمي واضح، مبسّط، وشامل يتوافق مع المنهج الوزاري العراقي، مع التركيز على الفهم العميق والتدريب العملي من خلال دروس مصورة، اختبارات تفاعلية، ومواد داعمة تساعد الطالبة والطالب على التفوق بثقة واستعداد للامتحان الوزاري.\n\n'
                                    'نؤمن أن النجاح يبدأ من فهم المادة بطريقة صحيحة… ونحن هنا لنكون شريكك في هذه الرحلة.',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  height: 1.6,
                                ),
                                textAlign: TextAlign.end,
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
          );
        },
      ),
    );
  }
}
