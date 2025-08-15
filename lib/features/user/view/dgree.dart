import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marwa_teacher/core/styles/themes.dart';
import '../../../core/widgets/background.dart';
import '../../../core/widgets/circular_progress.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';

class DegreeUser extends StatelessWidget {
  const DegreeUser({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => UserCubit()..getJustUser(context: context),
      child: BlocConsumer<UserCubit, UserStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = UserCubit.get(context);
          final student = cubit.justUserModel?.student;
          if (student == null) {
            return const Scaffold(
              body: Stack(
                children: [
                  Background(),
                  Center(child: CircularProgress()),
                ],
              ),
            );
          }
          final grade = student.grade;
          Widget buildContainers(String grades) {
            return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:[
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                    width: double.infinity,
                    height: 55,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white54),
                      //  borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      grades.toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  )
                ]
            );
          }
          Widget buildGradeContainers(List<dynamic> grades) {
            return Column(
              children: grades
                  .map(
                    (gradeValue) => Container(
                      width: double.maxFinite,
                      padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 6),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white54),
                      ),
                      child: Text(
                        gradeValue.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                    ),
              ).toList(),
            );
          }
          return SafeArea(
            child: Scaffold(
              body: Stack(
                children: [
                  Background(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      children: [
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Text(
                              'نتائجي',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Expanded(
                          child: ListView(
                            children: [
                              Card(
                                color: primaryColor.withOpacity(0.5),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(student.name, style: const TextStyle(color: Colors.white, fontSize: 18)),
                                          const Text("الاسم", style: TextStyle(color: Colors.white)),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(student.phone, style: const TextStyle(color: Colors.white, fontSize: 16)),
                                          const Text("رقم الهاتف", style: TextStyle(color: Colors.white)),
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              children: [
                                                buildContainers('الفصل'),
                                                buildGradeContainers(grade.lectureNos)
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              children: [
                                                buildContainers("درجة الامتحان"),
                                                buildGradeContainers(grade.examGrades)
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              children: [
                                                buildContainers("الدرجة الاصلية"),
                                                buildGradeContainers(grade.originalGrades)
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              children: [
                                                buildContainers("درجة الاعادة 1"),
                                                buildGradeContainers(grade.resitGrades1)
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              children: [
                                                buildContainers("درجة الاعادة 2"),
                                                buildGradeContainers(grade.resitGrades2)
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                            ],
                          ),
                        )
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
