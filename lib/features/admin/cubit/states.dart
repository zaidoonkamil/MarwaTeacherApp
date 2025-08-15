abstract class AdminStates {}

class AdminInitialState extends AdminStates {}

class ValidationState extends AdminStates {}

class SelectedImagesState extends AdminStates {}

class VerifyTokenLoadingState extends AdminStates {}
class VerifyTokenSuccessState extends AdminStates {}
class VerifyTokenErrorState extends AdminStates {}

class GetAdsLoadingState extends AdminStates {}
class GetAdsSuccessState extends AdminStates {}
class GetAdsErrorState extends AdminStates {}

class AddAdsLoadingState extends AdminStates {}
class AddAdsSuccessState extends AdminStates {}
class AddAdsErrorState extends AdminStates {}

class DeleteAdsLoadingState extends AdminStates {}
class DeleteAdsSuccessState extends AdminStates {}
class DeleteAdsErrorState extends AdminStates {}

class DeleteCoursesLoadingState extends AdminStates {}
class DeleteCoursesSuccessState extends AdminStates {}
class DeleteCoursesErrorState extends AdminStates {}

class DeleteUserLoadingState extends AdminStates {}
class DeleteUserSuccessState extends AdminStates {}
class DeleteUserErrorState extends AdminStates {}

class AddQuestionLoadingState extends AdminStates {}
class AddQuestionSuccessState extends AdminStates {}
class AddQuestionErrorState extends AdminStates {
  final String error;
  AddQuestionErrorState(this.error);
}


class AddImageExamLoadingState extends AdminStates {}
class AddImageExamSuccessState extends AdminStates {}
class AddImageExamErrorState extends AdminStates {}

class CheckSubscriptionLoadingState extends AdminStates {}
class CheckSubscriptionSuccessState extends AdminStates {}
class CheckSubscriptionErrorState extends AdminStates {}

class GetLessonsLoadingState extends AdminStates {}
class GetLessonsSuccessState extends AdminStates {}
class GetLessonsErrorState extends AdminStates {}

class AddLessonsLoadingState extends AdminStates {}
class AddLessonsSuccessState extends AdminStates {}
class AddLessonsErrorState extends AdminStates {}

class DeleteLessonsLoadingState extends AdminStates {}
class DeleteLessonsSuccessState extends AdminStates {}
class DeleteLessonsErrorState extends AdminStates {}

class AddNotificationLoadingState extends AdminStates {}
class AddNotificationSuccessState extends AdminStates {}
class AddNotificationErrorState extends AdminStates {}

class AddExamLoadingState extends AdminStates {}
class AddExamSuccessState extends AdminStates {}
class AddExamErrorState extends AdminStates {}

class AddCoursesLoadingState extends AdminStates {}
class AddCoursesSuccessState extends AdminStates {}
class AddCoursesErrorState extends AdminStates {}

class SignUpLoadingState extends AdminStates {}
class SignUpSuccessState extends AdminStates {}
class SignUpErrorState extends AdminStates {}

class GetNameUserLoadingState extends AdminStates {}
class GetNameUserSuccessState extends AdminStates {}
class GetNameUserErrorState extends AdminStates {}

class GetExamsLoadingState extends AdminStates {}
class GetExamsSuccessState extends AdminStates {}
class GetExamsErrorState extends AdminStates {}

class GetCoursesLoadingState extends AdminStates {}
class GetCoursesSuccessState extends AdminStates {}
class GetCoursesErrorState extends AdminStates {}

class GetResultExamLoadingState extends AdminStates {}
class GetResultExamSuccessState extends AdminStates {}
class GetResultExamErrorState extends AdminStates {}

class ExamAnswersLoadingState extends AdminStates {}
class ExamAnswersSuccessState extends AdminStates {}
class ExamAnswersErrorState extends AdminStates {}

class GetSubmitExamsLoadingState extends AdminStates {}
class GetSubmitExamsSuccessState extends AdminStates {}
class GetSubmitExamsErrorState extends AdminStates {}

class GetSubmitGradesLoadingState extends AdminStates {}
class GetSubmitGradesSuccessState extends AdminStates {}
class GetSubmitGradesErrorState extends AdminStates {}

class UpdateLockLoadingState extends AdminStates {}
class UpdateLockSuccessState extends AdminStates {}
class UpdateLockErrorState extends AdminStates {}

class GetExamsDetailsBulkLoadingState extends AdminStates {}
class GetExamsDetailsBulkSuccessState extends AdminStates {}
class GetExamsDetailsBulkErrorState extends AdminStates {}

class GetExamsDetailsLoadingState extends AdminStates {}
class GetExamsDetailsSuccessState extends AdminStates {}
class GetExamsDetailsErrorState extends AdminStates {}

class GetProfileLoadingState extends AdminStates {}
class GetProfileSuccessState extends AdminStates {}
class GetProfileErrorState extends AdminStates {}

class GetTeachersLoadingState extends AdminStates {}
class GetTeachersSuccessState extends AdminStates {}
class GetTeachersErrorState extends AdminStates {}

class GetVideosLoadingState extends AdminStates {}
class GetVideosSuccessState extends AdminStates {}
class GetVideosErrorState extends AdminStates {}