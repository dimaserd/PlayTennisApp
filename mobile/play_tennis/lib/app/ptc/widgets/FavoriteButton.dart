import 'package:flutter/material.dart';
import 'package:play_tennis/baseApiResponseUtils.dart';

class FavoriteButton extends StatefulWidget {
  const FavoriteButton({super.key});

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        _isFavorite ? Icons.favorite : Icons.favorite_border,
        color: Colors.red,
      ),
      onPressed: () {
        setState(() {
          _isFavorite = !_isFavorite;
        });
        Future.delayed(const Duration(seconds: 1), () {
          setState(() {
            _isFavorite = false;
          });
        });

        if (_isFavorite) {
          BaseApiResponseUtils.showError(context, 'Пока не реализовано');
        }
      },
    );
  }
}
