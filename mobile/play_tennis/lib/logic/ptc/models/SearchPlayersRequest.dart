class SearchPlayersRequest {
  late String? q;
  late bool? sex;
  late bool? emailConfirmed;
  late bool? accountConfirmed;
  late bool? dataFilled;
  late String? cityId;
  late int? count;
  late int offSet;

  SearchPlayersRequest({
    required this.q,
    required this.sex,
    required this.emailConfirmed,
    required this.accountConfirmed,
    required this.dataFilled,
    required this.cityId,
    required this.count,
    required this.offSet,
  });

  factory SearchPlayersRequest.fromJson(Map<String, dynamic> json) =>
      SearchPlayersRequest(
        q: json["q"],
        sex: json["sex"],
        emailConfirmed: json["emailConfirmed"],
        accountConfirmed: json["accountConfirmed"],
        dataFilled: json["dataFilled"],
        cityId: json["cityId"],
        count: json["count"],
        offSet: json["offSet"],
      );

  Map<String, dynamic> toJson() => {
        'q': q,
        'sex': sex,
        'emailConfirmed': emailConfirmed,
        'accountConfirmed': accountConfirmed,
        'dataFilled': dataFilled,
        'cityId': cityId,
        'count': count,
        'offSet': offSet,
      };
}
