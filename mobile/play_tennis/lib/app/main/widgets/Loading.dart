import 'package:flutter/material.dart';
import 'package:play_tennis/main-settings.dart';

class Loading extends StatelessWidget {
  final String text;
  const Loading({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        Center(
          child: Image.asset(
            MainSettings.loadingPath,
            height: 150,
            width: 150,
          ),
        ),
      ],
    );
  }
}

class AnimatedLoading extends StatelessWidget {
  const AnimatedLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Добро пожаловать в PlayTennis",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        Center(
          child: Image.asset(
            MainSettings.loadingGif,
            width: double.infinity,
          ),
        ),
      ],
    );
  }
}

class AnimatedCircleLoading extends StatelessWidget {
  final double height;
  const AnimatedCircleLoading({
    super.key,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: height,
          height: height,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color.fromRGBO(82, 186, 141, 1),
          ),
        ),
        SizedBox(
          width: height / 4 * 3,
          child: Image.asset(MainSettings.loadingGif),
        ),
      ],
    );
  }
}
