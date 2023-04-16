import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:play_tennis/app/main/widgets/palette.dart';
import 'package:play_tennis/app/ptc/widgets/FavoriteButton.dart';
import 'package:play_tennis/baseApiResponseUtils.dart';
import 'package:play_tennis/logic/ptc/services/CourtCardService.dart';
import 'package:url_launcher/url_launcher.dart';

class CourtCard extends StatelessWidget {
  final CourtCardSimpleModel courtCard;
  const CourtCard({
    required this.courtCard,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // onTapHandler(trainers[index]);
      },
      child: Card(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
          elevation: 4,
          child: ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  courtCard.name!,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const FavoriteButton()
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${courtCard.description}"),
                courtCard.phoneNumber != null
                    ? Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: RichText(
                          text: TextSpan(
                            text: "Телефон для записи: ",
                            style: const TextStyle(
                              color: mainColor,
                              fontSize: 16,
                            ),
                            children: [
                              TextSpan(
                                text: courtCard.phoneNumber,
                                style: const TextStyle(color: Colors.blue),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    _launchPhone(
                                      courtCard.phoneNumber!,
                                      context,
                                    );
                                  },
                              ),
                            ],
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
                getAddress(context),
              ],
              // ),
            ),
          )),
    );
  }

  void _launchPhone(String phoneNumber, BuildContext context) async {
    final url = Uri.parse('tel:$phoneNumber');

    try {
      if (await launchUrl(url)) {
        await launchUrl(url);
      }
    } catch (e) {
      BaseApiResponseUtils.showError(
        context,
        "Произошла ошибка при попытке вызова",
      );
    }
  }

  Widget getAddress(BuildContext context) {
    if (courtCard.address == null || courtCard.yandexMapsAppLink == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
      child: Column(
        children: [
          courtCard.districts != null && courtCard.districts!.isNotEmpty
              ? Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    children: [
                      Text(
                        "Район: ${courtCard.districts![0].name}",
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      )
                    ],
                  ),
                )
              : const SizedBox.shrink(),
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              children: [
                InkWell(
                  child: Text(
                    courtCard.address!,
                    style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
                    ),
                  ),
                  onTap: () {
                    var link = Uri.parse(courtCard.yandexMapsAppLink!);

                    try {
                      launchUrl(link);
                    } catch (e) {
                      BaseApiResponseUtils.showError(context,
                          "Произошла ошибка при попытке запустить Yandex карты");
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
