import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class DropdownWidgetItem {
  final String label;
  final String value;

  DropdownWidgetItem({required this.label, required this.value});
}

class DropdownWidget extends StatefulWidget {
  final String label;
  final List<DropdownWidgetItem> items;
  final Function(DropdownWidgetItem?) changedHandler;
  late DropdownWidgetItem? value;

  double maxHeight = 0;
  double defaultMaxHeight = 350;

  DropdownWidget({
    super.key,
    required this.label,
    required this.items,
    required this.changedHandler,
    this.value,
  }) {
    var height = items.length * 60.0;
    maxHeight = height > defaultMaxHeight ? defaultMaxHeight : height;
  }

  @override
  State<DropdownWidget> createState() => _DropdownWidgetState();
}

class _DropdownWidgetState extends State<DropdownWidget> {
  @override
  Widget build(BuildContext context) {
    return DropdownSearch<DropdownWidgetItem>(
      popupProps: PopupProps.menu(
        showSelectedItems: true,
        disabledItemFn: (DropdownWidgetItem s) => false,
        showSearchBox: false, //Для статического списка ничего не ищем
        isFilterOnline: false,
        constraints: BoxConstraints(
          maxHeight: widget.maxHeight,
        ),
      ),
      compareFn: (item1, item2) => item1.value == item2.value,
      filterFn: (item, filter) => item.label.contains(filter),
      itemAsString: (DropdownWidgetItem u) => u.label,
      items: widget.items,
      dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          labelText: widget.label,
          hintText: widget.label,
          isDense: true,
          isCollapsed: false,
          filled: false,
          //helperMaxLines: 2,
        ),
      ),
      onChanged: (item) {
        widget.value = item;
        widget.changedHandler(item);
      },
      selectedItem: widget.value,
    );
  }
}
