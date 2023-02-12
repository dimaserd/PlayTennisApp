class PublicTelegramChatForCityModel {
  late String? chatLink;
  late String? channelLink;

  PublicTelegramChatForCityModel({
    required this.chatLink,
    required this.channelLink,
  });

  factory PublicTelegramChatForCityModel.fromJson(Map<String, dynamic> json) =>
      PublicTelegramChatForCityModel(
        chatLink: json["chatLink"],
        channelLink: json["channelLink"],
      );

  Map<String, dynamic> toJson() => {
        'chatLink': chatLink,
        'channelLink': channelLink,
      };
}
