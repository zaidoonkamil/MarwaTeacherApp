import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marwa_teacher/features/user/cubit/states.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/network/remote/dio_helper.dart';
import '../../../core/widgets/constant.dart';
import '../../../core/widgets/show_toast.dart';
import '../model/CoursesModel.dart';
import '../model/ExamsDetailsBulkModel.dart';
import '../model/ExamsDetailsModel.dart';
import '../model/ExamsModel.dart';
import '../model/GetAdsModel.dart';
import '../model/GetLessons.dart';
import '../model/JustCustomUserModel.dart';
import '../model/ProfileModel.dart';

class UserCubit extends Cubit<UserStates> {
  UserCubit() : super(UserInitialState());

  static UserCubit get(context) => BlocProvider.of(context);

  bool isPageLoaded = false;

  void startPageAnimation() {
    isPageLoaded = true;
    emit(PageAnimationStartedState());
  }

  void slid(){
    emit(ValidationState());
  }

  void slid2(){
    emit(Validation2State());
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

  JustCustomUserModel? justUserModel;
  void getJustUser({required BuildContext context}) {
    emit(GetExamsLoadingState());
    DioHelper.getData(
      url: '/grades/$id',
    ).then((value) {
      justUserModel = JustCustomUserModel.fromJson(value.data);
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

}