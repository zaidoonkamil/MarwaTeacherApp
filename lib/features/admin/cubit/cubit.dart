import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marwa_teacher/features/admin/cubit/states.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/network/remote/dio_helper.dart';
import '../../../core/network/remote/dio_helper_vimeo.dart';
import '../../../core/widgets/constant.dart';
import '../../../core/widgets/show_toast.dart';
import '../../user/model/CoursesModel.dart';
import '../../user/model/ExamAnswersModel.dart';
import '../../user/model/ExamsDetailsBulkModel.dart';
import '../../user/model/ExamsDetailsModel.dart';
import '../../user/model/ExamsModel.dart';
import '../../user/model/GetAdsModel.dart';
import '../../user/model/GetLessons.dart';
import '../../user/model/GetResultExamModel.dart';
import '../../user/model/JustUserModel.dart';
import '../../user/model/ProfileModel.dart';
import '../../user/model/VimeoVideoModel.dart';
import '../../user/model/getNameUser.dart';
import '../view/details/AddQuestion.dart';
import '../view/details/AddQuestionBulk.dart';

class AdminCubit extends Cubit<AdminStates> {
  AdminCubit() : super(AdminInitialState());

  static AdminCubit get(context) => BlocProvider.of(context);

  void slid(){
    emit(ValidationState());
  }

  List<XFile> selectedImages = [];
  Future<void> pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> resultList = await picker.pickMultiImage();

    if (resultList.isNotEmpty) {
      selectedImages = resultList;
      emit(SelectedImagesState());
    }
  }

  void addImageExam({required BuildContext context,required String examId,}) async {
    emit(AddImageExamLoadingState());
    if (selectedImages.isEmpty) {
      showToastInfo(text: "الرجاء اختيار صور أولاً!", context: context);
      return;
    }
    FormData formData = FormData();
    formData.fields.addAll([
      MapEntry("userId", id),
      MapEntry("examId", examId),
    ]);
    for (var file in selectedImages) {
      formData.files.add(
          MapEntry(
            "images",
            await MultipartFile.fromFile(
              file.path, filename: file.name,
              contentType: MediaType('image', 'jpeg'),
            ),
          ));
    }
    DioHelper.postData(
      url: '/submit-text-answer',
      data: formData,
      options: Options(headers: {"Content-Type": "multipart/form-data"}),
    ).then((value) {
      selectedImages=[];
      emit(AddImageExamSuccessState());
    }).catchError((error) {
      if (error is DioException) {
        showToastError(text: error.response?.data['error'] ?? 'حدث خطأ غير متوقع', context: context,);
      } else {
        print("❌ Unknown Error: $error");
      }
      emit(AddImageExamErrorState());
    });
  }


  int tab=1;
  void onTabChanged({required int t}){
    tab=t;
    emit(ValidationState());
  }

  void verifyToken({required BuildContext context}) {
    if(token == ''){
      return emit(VerifyTokenErrorState());
    }
    emit(VerifyTokenLoadingState());
    DioHelper.getData(
        url: '/verify-token',
        token: token
    ).then((value) {
      bool isValid = value.data['valid'];
      if (isValid) {
        emit(VerifyTokenSuccessState());
      } else {
        signOut(context);
        showToastError(text: "توكن غير صالح", context: context);
        emit(VerifyTokenErrorState());
      }
    }).catchError((error) {
      if (error is DioError) {
        showToastError(text: error.toString(),
          context: context,);
        emit(VerifyTokenErrorState());
      }else {
        print("Unknown Error: $error");
      }
    });
  }

  List<Ad> ads = [];
  Pagination? pagination;
  int currentPage = 1;
  bool isLastPage = false;
  GetAds? getAdsModel;
  void getAds({required String page,required BuildContext? context,}) {
    emit(GetAdsLoadingState());
    DioHelper.getData(
      url: '/ads',
    ).then((value) {
      getAdsModel = GetAds.fromJson(value.data);
      ads.addAll(getAdsModel!.ads);
      pagination = getAdsModel!.pagination;
      currentPage = pagination!.currentPage;
      if (currentPage >= pagination!.totalPages) {
        isLastPage = true;
      }
      emit(GetAdsSuccessState());
    }).catchError((error) {
      if (error is DioError) {
        showToastError(text: error.toString(),
          context: context!,);
        print(error.toString());
        emit(GetAdsErrorState());
      }else {
        print("Unknown Error: $error");
      }
    });
  }

  addAds({required String tittle, required String desc, required BuildContext context,})async{
    emit(AddAdsLoadingState());
    if (selectedImages.isEmpty) {
      showToastInfo(text: "الرجاء اختيار صور أولاً!", context: context);
      emit(AddAdsErrorState());
      return;
    }
    FormData formData = FormData.fromMap(
        {
          'title': tittle,
          'description': desc,
        },
        ListFormat.multiCompatible
    );

    for (var file in selectedImages) {
      formData.files.add(
        MapEntry(
          "images",
          await MultipartFile.fromFile(
            file.path, filename: file.name,
            contentType: MediaType('image', 'jpeg'),
          ),
        ),
      );
    }

    DioHelper.postData(
      url: '/ads',
      data: formData,
      options: Options(headers: {"Content-Type": "multipart/form-data"}),
    ).then((value) {
      emit(AddAdsSuccessState());
    }).catchError((error)
    {
      if (error is DioError) {
        showToastError(
          text: error.response?.data["error"],
          context: context,
        );
        emit(AddAdsErrorState());
      }else {
        print("Unknown Error: $error");
      }
    });
  }


  void deleteAds({required String id,required BuildContext context}) {
    emit(DeleteAdsLoadingState());
    DioHelper.deleteData(
      url: '/ads/$id',
    ).then((value) {
      ads.removeWhere((getAdsModel) => getAdsModel.id.toString() == id);
      showToastSuccess(
        text: 'تم الحذف بنجاح',
        context: context,
      );
      emit(DeleteAdsSuccessState());
    }).catchError((error) {
      if (error is DioError) {
        showToastError(text: error.toString(),context: context,);
        print(error.toString());
        emit(DeleteAdsErrorState());
      }else {
        print("Unknown Error: $error");
      }
    });
  }

  void deleteCourses({required String id,required BuildContext context}) {
    emit(DeleteCoursesLoadingState());
    DioHelper.deleteData(
      url: '/courses/$id',
    ).then((value) {
      coursesModel.removeWhere((getCoursesModel) => getCoursesModel.id.toString() == id);
      showToastSuccess(
        text: 'تم الحذف بنجاح',
        context: context,
      );
      emit(DeleteCoursesSuccessState());
    }).catchError((error) {
      if (error is DioError) {
        showToastError(text: error.toString(),context: context,);
        print(error.toString());
        emit(DeleteCoursesErrorState());
      }else {
        print("Unknown Error: $error");
      }
    });
  }

  ProfileModel? profileModel;
  void getProfile({required BuildContext context,}) {
    emit(GetProfileLoadingState());
    DioHelper.getData(
        url: '/users/$id',
        token: token
    ).then((value) {
      profileModel = ProfileModel.fromJson(value.data);
      emit(GetProfileSuccessState());
    }).catchError((error) {
      if (error is DioError) {
        showToastError(text: error.toString(),
          context: context,);
        print(error.toString());
        emit(GetProfileErrorState());
      }else {
        print("Unknown Error: $error");
      }
    });
  }


  List<GetLessons> getLessonsModel = [];
  void getLessons({required BuildContext context,required String courseId}) {
    emit(GetLessonsLoadingState());
    DioHelper.getData(
      url: '/lessons/$courseId',
    ).then((value) {
      getLessonsModel = (value.data as List)
          .map((item) => GetLessons.fromJson
        (item as Map<String, dynamic>)).toList();
      emit(GetLessonsSuccessState());
    }).catchError((error) {
      if (error is DioError) {
        showToastError(text: error.toString(), context: context,);
        emit(GetLessonsErrorState());
      }else {
        print("Unknown Error: $error");
      }
    });
  }

  addLessons({required String tittle,required String videoUrl,required String pdfUrl,required String courseId, required String desc, required BuildContext context,})async{
    emit(AddLessonsLoadingState());
    if (selectedImages.isEmpty) {
      showToastInfo(text: "الرجاء اختيار صور أولاً!", context: context);
      emit(AddLessonsErrorState());
      return;
    }
    FormData formData = FormData.fromMap(
        {
          'title': tittle,
          'description': desc,
          'videoUrl': videoUrl,
          'pdfUrl': pdfUrl,
          'courseId': courseId,
        },
        ListFormat.multiCompatible
    );

    for (var file in selectedImages) {
      formData.files.add(
        MapEntry(
          "images",
          await MultipartFile.fromFile(
            file.path, filename: file.name,
            contentType: MediaType('image', 'jpeg'),
          ),
        ),
      );
    }

    DioHelper.postData(
      url: '/lessons',
      data: formData,
      options: Options(headers: {"Content-Type": "multipart/form-data"}),
    ).then((value) {
      emit(AddLessonsSuccessState());
    }).catchError((error)
    {
      if (error is DioError) {
        showToastError(
          text: error.response?.data["error"],
          context: context,
        );
        emit(AddLessonsErrorState());
      }else {
        print("Unknown Error: $error");
      }
    });
  }

  void deleteLessons({required String id,required BuildContext context}) {
    emit(DeleteLessonsLoadingState());
    DioHelper.deleteData(
      url: '/lessons/$id',
    ).then((value) {
      getLessonsModel.removeWhere((getAdsModel) => getAdsModel.id.toString() == id);
      showToastSuccess(
        text: 'تم الحذف بنجاح',
        context: context,
      );
      emit(DeleteLessonsSuccessState());
    }).catchError((error) {
      if (error is DioError) {
        showToastError(text: error.toString(),context: context,);
        print(error.toString());
        emit(DeleteLessonsErrorState());
      }else {
        print("Unknown Error: $error");
      }
    });
  }

  addNotification({required String tittle, required String desc, required BuildContext context,})async{
    emit(AddNotificationLoadingState());
    DioHelper.postData(
      url: '/send-notification-to-role',
      data: {
        'title': tittle,
        'message': desc,
        'role': 'user',
      },
    ).then((value) {
      emit(AddNotificationSuccessState());
    }).catchError((error)
    {
      if (error is DioError) {
        showToastError(
          text: error.response?.data["error"],
          context: context,
        );
        emit(AddNotificationErrorState());
      }else {
        print("Unknown Error: $error");
      }
    });
  }

  addExam({required String tittle,required BuildContext context,})async{
    emit(AddExamLoadingState());
    DioHelper.postData(
      url: '/exams',
      data: {
        'title': tittle,
      },
    ).then((value) {
      emit(AddExamSuccessState());
    }).catchError((error)
    {
      if (error is DioError) {
        showToastError(
          text: error.response?.data["error"],
          context: context,
        );
        emit(AddExamErrorState());
      }else {
        print("Unknown Error: $error");
      }
    });
  }

  addCourses({required String tittle,required BuildContext context,})async{
    emit(AddCoursesLoadingState());
    DioHelper.postData(
      url: '/courses',
      data: {
        'title': tittle,
        'description': '',
        'price': '1',
      },
    ).then((value) {
      emit(AddCoursesSuccessState());
    }).catchError((error)
    {
      if (error is DioError) {
        showToastError(
          text: error.response?.data["error"],
          context: context,
        );
        emit(AddCoursesErrorState());
      }else {
        print("Unknown Error: $error");
      }
    });
  }

  signUp({required String name, required String phone, required String password,required String role, required BuildContext context,}){
    emit(SignUpLoadingState());
    DioHelper.postData(
      url: '/users',
      data:
      {
        'name': name,
        'phone': phone,
        'role': role,
        'password': password,
      },
    ).then((value) {
      emit(SignUpSuccessState());
    }).catchError((error)
    {
      if (error is DioError) {
        print(error.response?.data["error"]);
        showToastError(
          text: error.response?.data["error"],
          context: context,
        );
        emit(SignUpErrorState());
      }else {
        print("Unknown Error: $error");
      }
    });
  }

  List<User> user = [];
  Pagination2? pagination2;
  int currentPage1 = 1;
  bool isLastPage1 = false;
  GetNameUser? getNameUserModel;
  void getNameUser({required BuildContext? context,required String page}) {
    emit(GetNameUserLoadingState());
    DioHelper.getData(
      url: '/users?page=$page',
    ).then((value) {
      getNameUserModel = GetNameUser.fromJson(value.data);
      user.addAll(getNameUserModel!.users);
      pagination2 = getNameUserModel!.pagination2;
      currentPage1 = pagination2!.currentPage;
      if (currentPage1 >= pagination2!.totalPages) {
        isLastPage1 = true;
      }
      emit(GetNameUserSuccessState());
    }).catchError((error) {
      if (error is DioError) {
        showToastError(text: error.toString(),
          context: context!,);
        print(error.toString());
        emit(GetNameUserErrorState());
      }else {
        print("Unknown Error: $error");
      }
    });
  }

  void deleteUser({required String id,required BuildContext context}) {
    emit(DeleteUserLoadingState());
    DioHelper.deleteData(
      url: '/users/$id',
    ).then((value) {
      user.removeWhere((getUserModel) => getUserModel.id.toString() == id);
      getNameUserModel!.users.removeWhere((getUserModel) => getUserModel.id.toString() == id);
      showToastSuccess(
        text: 'تم الحذف بنجاح',
        context: context,
      );
      emit(DeleteUserSuccessState());
    }).catchError((error) {
      if (error is DioError) {
        showToastError(text: error.toString(),context: context,);
        print(error.toString());
        emit(DeleteUserErrorState());
      }else {
        print("Unknown Error: $error");
      }
    });
  }

  void deleteExam({required String id,required BuildContext context}) {
    emit(DeleteUserLoadingState());
    DioHelper.deleteData(
      url: '/exam/$id',
    ).then((value) {
      examsModel.removeWhere((getUserModel) => getUserModel.id.toString() == id);
      showToastSuccess(
        text: 'تم الحذف بنجاح',
        context: context,
      );
      emit(DeleteUserSuccessState());
    }).catchError((error) {
      if (error is DioError) {
        showToastError(text: error.toString(),context: context,);
        print(error.toString());
        emit(DeleteUserErrorState());
      }else {
        print("Unknown Error: $error");
      }
    });
  }

  Future<void> addMultipleQuestions({required String examId, required List<QuestionData> questions,}) async {
    emit(AddQuestionLoadingState());

    try {
      final response = await DioHelper.postData(
        url: '/questions',
        data: {
          "examId": examId,
          "questions": questions.map((q) => q.toJson()).toList(),
        },
      );
      emit(AddQuestionSuccessState());
    } catch (error) {
      emit(AddQuestionErrorState(error.toString()));
    }
  }

  void addTextQuestions({required String examId, required List<TextQuestionData> questions}) async {
    emit(AddQuestionLoadingState());
    try {
      final data = {
        "examId": examId,
        "questions": questions.map((q) => q.toJson()).toList(),
      };

      final response = await DioHelper.postData(url: "/questions/bulk", data: data);
      emit(AddQuestionSuccessState());
    } catch (e) {
      emit(AddQuestionErrorState(e.toString()));
    }
  }

  Future<void> openAttachment(String url) async {
    final Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.inAppWebView,
      );
    } else {
      throw 'لا يمكن فتح الرابط: $url';
    }
  }

  List<ExamsModel> examsModel = [];
  void getExams({required BuildContext context}) {
    emit(GetExamsLoadingState());
    DioHelper.getData(
      url: '/exams',
    ).then((value) {
      examsModel = (value.data as List)
          .map((item) => ExamsModel.fromJson
        (item as Map<String, dynamic>)).toList();
      emit(GetExamsSuccessState());
    }).catchError((error) {
      if (error is DioError) {
        showToastError(text: error.toString(), context: context,);
        emit(GetExamsErrorState());
      }else {
        print("Unknown Error: $error");
      }
    });
  }

  void answersExam({required String type,required BuildContext context,required String questionId}){
    if(type == 'text'){
      examAnswers(context: context, questionId: questionId);
    }else if(type == 'multy'){
      getResultExam(context: context, questionId: questionId);
    }
  }

  List<GetResultExamModel> getResultExamModel = [];
  void getResultExam({required BuildContext context,required String questionId}) {
    emit(GetResultExamLoadingState());
    DioHelper.getData(
      url: '/exam/$questionId/results',
    ).then((value) {
      getResultExamModel = (value.data as List)
          .map((item) => GetResultExamModel.fromJson
        (item as Map<String, dynamic>)).toList();
      emit(GetResultExamSuccessState());
    }).catchError((error) {
      if (error is DioError) {
        showToastError(text: error.toString(), context: context,);
        emit(GetResultExamErrorState());
      }else {
        print("Unknown Error: $error");
      }
    });
  }

  List<ExamAnswersModel> examAnswersModel = [];
  void examAnswers({required BuildContext context,required String questionId}) {
    emit(ExamAnswersLoadingState());
    DioHelper.getData(
      url: '/text-answers/$questionId',
    ).then((value) {
      examAnswersModel = (value.data as List)
          .map((item) => ExamAnswersModel.fromJson
        (item as Map<String, dynamic>)).toList();
      emit(ExamAnswersSuccessState());
    }).catchError((error) {
      if (error is DioError) {
        showToastError(text: error.toString(), context: context,);
        emit(ExamAnswersErrorState());
      }else {
        print("Unknown Error: $error");
      }
    });
  }

  List<ExamsDetailsBulkModel> examsDetailsBulkModel = [];
  void getExamsDetailsBulk({required BuildContext context,required String examId}) {
    emit(GetExamsDetailsBulkLoadingState());
    DioHelper.getData(
      url: '/questionsBulk/$examId',
    ).then((value) {
      examsDetailsBulkModel = (value.data as List)
          .map((item) => ExamsDetailsBulkModel.fromJson
        (item as Map<String, dynamic>)).toList();
      emit(GetExamsDetailsBulkSuccessState());
    }).catchError((error) {
      if (error is DioError) {
        showToastError(text: error.toString(), context: context,);
        emit(GetExamsDetailsBulkErrorState());
      }else {
        print("Unknown Error: $error");
      }
    });
  }

  List<ExamsDetailsModel> examsDetailsModel = [];
  void getExamsDetails({required BuildContext context,required String questionsId,}) {
    emit(GetExamsDetailsLoadingState());
    DioHelper.getData(
      url: '/questions/$questionsId',
    ).then((value) {
      examsDetailsModel = (value.data as List)
          .map((item) => ExamsDetailsModel.fromJson
        (item as Map<String, dynamic>)).toList();
      emit(GetExamsDetailsSuccessState());
    }).catchError((error) {
      if (error is DioError) {
        showToastError(text: error.toString(), context: context,);
        emit(GetExamsDetailsErrorState());
      }else {
        print("Unknown Error: $error");
      }
    });
  }

  void submitExams({required BuildContext context, required String userId, required String examId, required Map<int, int> selectedChoices,}) {
    emit(GetSubmitExamsLoadingState());
    List<Map<String, dynamic>> answers = selectedChoices.entries.map((entry) {
      return {
        'questionId': entry.key,
        'selectedChoiceId': entry.value,
      };
    }).toList();
    DioHelper.postData(
      url: '/submit-exam',
      data: {
        'userId': userId,
        'examId': examId,
        'answers': answers,
      },
    ).then((value) {
      emit(GetSubmitExamsSuccessState());
    }).catchError((error) {
      if (error is DioError) {
        showToastError(text: error.response?.data['error'] ?? 'حدث خطأ غير متوقع', context: context,);
        emit(GetSubmitExamsErrorState());
      }else {
        print("Unknown Error: $error");
      }
    });
  }


  JustUserModel? justUserModel;
  void getJustUser({required BuildContext context}) {
    emit(GetExamsLoadingState());
    DioHelper.getData(
      url: '/grades',
    ).then((value) {
      justUserModel = JustUserModel.fromJson(value.data);
      emit(GetExamsSuccessState());
    }).catchError((error) {
      if (error is DioError) {
        showToastError(text: error.toString(), context: context,);
        emit(GetExamsErrorState());
      }else {
        print("Unknown Error: $error");
      }
    });
  }


  List<CoursesModel> coursesModel = [];
  void getCourses({required BuildContext context}) {
    emit(GetCoursesLoadingState());
    DioHelper.getData(
      url: '/courses',
    ).then((value) {
      coursesModel = List<CoursesModel>.from(
        value.data.map((x) => CoursesModel.fromJson(x)),
      );
      emit(GetCoursesSuccessState());
    }).catchError((error) {
      if (error is DioError) {
        showToastError(text: error.toString(), context: context);
        emit(GetCoursesErrorState());
      } else {
        print("Unknown Error: $error");
      }
    });
  }


  Map<int, Map<String, dynamic>> inputGrades = {};
  void submitGrades({required BuildContext context, required List<Map<String, dynamic>> allGrades,}) {
    emit(GetSubmitGradesLoadingState());
    DioHelper.postData(
      url: '/grades',
      data: allGrades,
    ).then((value) {
      emit(GetSubmitGradesSuccessState());
    }).catchError((error) {
      if (error is DioError) {
        print("❌ Dio Error: ${error.response?.data}");
        showToastError(text: error.response?.data['error'] ?? 'حدث خطأ غير متوقع', context: context);
      } else {
        print("Unknown Error: $error");
      }
      emit(GetSubmitGradesErrorState());
    });
  }

  void updateLock({required BuildContext context, required bool isLocked, required String id}) {
    emit(UpdateLockLoadingState());
    DioHelper.patchData(
      url: '/lessons/$id/lock',
      data: {
        'isLocked': isLocked,
      },
    ).then((value) {
      emit(UpdateLockSuccessState());
    }).catchError((error) {
      if (error is DioError) {
        print("❌ Dio Error: ${error.response?.data}");
        showToastError(text: error.response?.data['error'] ?? 'حدث خطأ غير متوقع', context: context);
      } else {
        print("Unknown Error: $error");
      }
      emit(UpdateLockErrorState());
    });
  }


  List<VimeoVideoModel> videos = [];
  String? nextPageUrl;
  void getVideosFromFolder({required BuildContext context, required String folderId, bool loadMore = false}) {
    if (!loadMore) {
      emit(GetVideosLoadingState());
      videos.clear();
      nextPageUrl = null;
    }final url = nextPageUrl ?? '/me/projects/$folderId/videos';

    DioHelperVimeo.getDataVimeo(
      url: url,
      token: 'Bearer e9737174eff0c80d3ea0b1609d2275ba',
    ).then((value) {
      final newVideos = (value.data['data'] as List)
          .map((item) => VimeoVideoModel.fromJson(item))
          .toList();
      videos.addAll(newVideos);
      nextPageUrl = value.data['paging']?['next'];
      emit(GetVideosSuccessState());
    }).catchError((error) {
      if (error is DioError) {
        print(error.toString());
        showToastError(text: error.toString(), context: context);
      } else {
        print("Unknown Error: $error");
      }
      emit(GetVideosErrorState());
    });
  }


}