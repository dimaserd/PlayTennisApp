import 'package:flutter/material.dart';
import 'package:play_tennis/app/ptc/widgets/CountryAndCitySelectWidget.dart';
import 'package:play_tennis/app/ptc/widgets/profile/EditMainDataWidget.dart';
import 'package:play_tennis/app/ptc/widgets/profile/EditPlayerAvatarWidget.dart';
import 'package:play_tennis/baseApiResponseUtils.dart';
import 'package:play_tennis/logic/ptc/models/PlayerData.dart';
import 'package:play_tennis/logic/ptc/services/PlayerService.dart';
import 'package:play_tennis/main-services.dart';

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

  const EditProfileWidget({
    super.key,
    required this.playerData,
  });

  @override
  State<EditProfileWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<EditProfileWidget> {
  final List<Item> _data = generateItems(3);

  final countryAndCitySelectController = CountryAndCitySelectController();

  @override
  void initState() {
    if (!mounted) {
      return;
    }

    AppServices.playerService.getPlayerLocationData((e) => {}).then((value) {
      if (value != null && mounted) {
        countryAndCitySelectController.setPlayerLocationData(value);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            _buildPanel(),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
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
                  showDistrictSelect: false,
                  onCountryChanged: (p) {},
                  onCityChanged: (p) {},
                  controller: countryAndCitySelectController,
                ),
              ),
              const SizedBox(
                height: 10,
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
                  onPressed: () async {
                    final country = countryAndCitySelectController.country;
                    final city = countryAndCitySelectController.city;

                    final String? countryId = country?.id;
                    final String? cityId = city?.id;

                    final model = UpdateCountryAndCityDataRequest(
                      countryId: countryId,
                      cityId: cityId,
                    );

                    final data = await AppServices.playerService
                        .updateCityAndCountryData(model);

                    if (mounted) {
                      BaseApiResponseUtils.handleResponse(
                        context,
                        data,
                      );
                    }
                  },
                  child: const Text(
                    "Сохранить",
                    style: TextStyle(color: Colors.white),
                  ),
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
                onSucceess: () => {},
              ),
            ],
          ),
          isExpanded: _data[2].isExpanded,
        )
      ],
    );
  }
}
