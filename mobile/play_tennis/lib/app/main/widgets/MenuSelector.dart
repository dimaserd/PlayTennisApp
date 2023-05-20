import 'package:flutter/material.dart';

class MenuSelector extends StatelessWidget {
  const MenuSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(title: const Text('Выбор элементов')),
      body: const Center(child: SelectionWidget()),
    ));
  }
}

class SelectionWidget extends StatefulWidget {
  const SelectionWidget({Key? key}) : super(key: key);
  @override
  State<SelectionWidget> createState() => _SelectionWidgetState();
}

class _SelectionWidgetState extends State<SelectionWidget> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 65,
        padding: const EdgeInsets.symmetric(horizontal: 0),
        decoration: BoxDecoration(
          color: const Color(0xFFE4EBEB),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            for (int i = 0; i < 4; i++)
              Expanded(child: _buildSelectionButton(i, context)),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionButton(int index, BuildContext context) {
    final List<String> items = ['Корты', 'Игроки', 'Группы', 'Турниры'];
    final List<IconData> icons = [
      Icons.sports_tennis,
      Icons.person,
      Icons.group,
      Icons.emoji_events
    ];
    final isSelected = _selectedIndex == index;
    final backgroundColor =
        isSelected ? const Color(0xFF70A50C) : const Color(0xFFE4EBEB);
    final colorElement = isSelected ? Colors.white : const Color(0xFF5C676C);
    final BorderRadius borderRadius = isSelected
        ? const BorderRadius.all(Radius.circular(10))
        : (index == 0
            ? const BorderRadius.only(
                topLeft: Radius.circular(10), bottomLeft: Radius.circular(10))
            : (index == 3
                ? const BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10))
                : BorderRadius.circular(0)));

    return InkWell(
      onTap: () => setState(() => _selectedIndex = index),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          color: backgroundColor,
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icons[index], color: colorElement),
            Text(
              items[index],
              style: TextStyle(
                  color: colorElement,
                  fontSize: 14,
                  fontFamily: 'OpenSans-Bold'),
            )
          ],
        ),
      ),
    );
  }
}
