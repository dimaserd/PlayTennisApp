import 'package:flutter/material.dart';
import 'package:play_tennis/logic/ptc/models/PlayerData.dart';
import 'CountryAndCitySelectWidget.dart';
import 'EditMainDataWidget.dart';
import 'EditPlayerAvatarWidget.dart';

// stores ExpansionPanel state information
class Item {
  Item({
    required this.expandedValue,
    required this.headerValue,
    this.isExpanded = false,
  });

  String expandedValue;
  String headerValue;
  bool isExpanded;
}

List<Item> generateItems(int numberOfItems) {
  return List<Item>.generate(numberOfItems, (int index) {
    return Item(
      headerValue: 'Panel $index',
      expandedValue: 'This is item number $index',
    );
  });
}

class EditProfileWidget extends StatefulWidget {
  final PlayerData playerData;

  const EditProfileWidget({super.key, required this.playerData});

  @override
  State<EditProfileWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<EditProfileWidget> {
  final List<Item> _data = generateItems(3);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.center,
        child: _buildPanel(),
      ),
    );
  }

  Widget _buildPanel() {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _data[index].isExpanded = !isExpanded;
        });
      },
      children: [
        ExpansionPanel(
          canTapOnHeader: true,
          headerBuilder: (BuildContext context, bool isExpanded) {
            return const ListTile(
              title: Text("Персональные данные"),
            );
          },
          body: EditMainDataWidget(playerData: widget.playerData),
          isExpanded: _data[0].isExpanded,
        ),
        ExpansionPanel(
          canTapOnHeader: true,
          headerBuilder: (BuildContext context, bool isExpanded) {
            return const ListTile(
              title: Text("Местоположение"),
            );
          },
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 2,
                  horizontal: 15.0,
                ),
                child: CountryAndCitySelect(
                  onCountryChanged: (p) {},
                  onCityChanged: (p) {},
                  controller: CountryAndCitySelectController(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 2,
                  horizontal: 15.0,
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    minimumSize: const Size.fromHeight(40), // NEW
                  ),
                  onPressed: () {},
                  child: const Text("Сохранить"),
                ),
              ),
              const SizedBox(
                height: 6,
              )
            ],
          ),
          isExpanded: _data[1].isExpanded,
        ),
        ExpansionPanel(
          canTapOnHeader: true,
          headerBuilder: (BuildContext context, bool isExpanded) {
            return const ListTile(
              title: Text("Аватар"),
            );
          },
          body: Column(
            children: [
              EditPlayerAvatarWidget(
                avatarFileId: widget.playerData.avatarFileId,
              ),
            ],
          ),
          isExpanded: _data[2].isExpanded,
        )
      ],
    );
  }
}
