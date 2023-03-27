import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:play_tennis/app/main/widgets/palette.dart';
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
            title: Text(
              courtCard.name!,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text("${courtCard.description}"),
                courtCard.phoneNumber != null
                    ? Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: RichText(
                          text: TextSpan(
                            text: "Телефон для записи: ",
                            style: const TextStyle(color: mainColor),
                            children: [
                              TextSpan(
                                text: courtCard.phoneNumber,
                                style: const TextStyle(color: Colors.blue),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    _launchPhone(courtCard.phoneNumber!);
                                  },
                              ),
                            ],
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
                getAddress(),
              ],
              // ),
            ),
          )),
    );
  }

  void _launchPhone(String phoneNumber) async {
    final url = Uri.parse('tel:$phoneNumber');
    if (await launchUrl(url)) {
      await launchUrl(url);
    }
  }

  Widget getAddress() {
    if (courtCard.address == null || courtCard.yandexMapsAppLink == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: InkWell(
        child: Text(
          courtCard.address!,
          style: const TextStyle(color: Colors.blue),
        ),
        onTap: () {
          var link = Uri.parse(courtCard.yandexMapsAppLink!);
          launchUrl(link);
        },
      ),
    );
  }
}
