class SurveyDTO {
  final String comment;

  SurveyDTO({required this.comment});

  factory SurveyDTO.fromMap(Map<String, dynamic> data) {
    return SurveyDTO(comment: data["comment"]);
  }
}
