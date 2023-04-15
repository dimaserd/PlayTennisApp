import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:play_tennis/app/main/widgets/palette.dart';
import 'package:play_tennis/app/ptc/widgets/FavoritesButton.dart';
import 'package:play_tennis/logic/ptc/services/TrainerCardService.dart';
import 'package:url_launcher/url_launcher.dart';

class TrainerCard extends StatelessWidget {
  final TrainerCardSimpleModel trainer;
  const TrainerCard({
    super.key,
    required this.trainer,
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
                  "${trainer.surname!} ${trainer.name!}",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                FavoriteButton()
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  RichText(
                    text: TextSpan(
                      text: "Номер телефона: ",
                      style: const TextStyle(color: mainColor),
                      children: [
                        TextSpan(
                          text: "${trainer.phoneNumber}",
                          style: const TextStyle(color: Colors.blue),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              _launchPhone("${trainer.phoneNumber}");
                            },
                        ),
                      ],
                    ),
                  ),
                ]),
                const SizedBox(
                  height: 5,
                ),
                Text("${trainer.description}"),
                const SizedBox(
                  height: 10,
                )
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
}
