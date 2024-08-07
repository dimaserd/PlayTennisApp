import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'HtmlImageViewWidget.dart';

//https://pub.dev/packages/flutter_html/versions/3.0.0-beta.2

class HtmlViewWidget extends StatelessWidget {
  late final String html;

  String getStyleTag() {
    var styleHtml = "";
    styleHtml += "<style>";
    styleHtml += "h1,h2,h3,h4,h5,h6,p {";
    styleHtml += "margin:0; padding:0;";
    styleHtml += "}";
    styleHtml += ".r {";
    styleHtml += "text-align:right;";
    styleHtml += "}";
    styleHtml += ".l {";
    styleHtml += "text-align:left;";
    styleHtml += "}";
    styleHtml += ".c {";
    styleHtml += "text-align:center;";
    styleHtml += "}";
    styleHtml += getHeaderStyles();
    styleHtml += "</style>";

    return styleHtml;
  }

  getHeaderStyles() {
    var styleHtml = "";

    styleHtml += "h2 {";
    styleHtml += "font-size:24px;";
    styleHtml += "}";
    styleHtml += "h3 {";
    styleHtml += "font-size:22px;";
    styleHtml += "}";
    styleHtml += "h4 {";
    styleHtml += "font-size:20px;";
    styleHtml += "}";

    styleHtml += "h5 {";
    styleHtml += "font-size:18px;";
    styleHtml += "}";
    styleHtml += "h6 {";
    styleHtml += "font-size:16px;";
    styleHtml += "}";

    return styleHtml;
  }

  HtmlViewWidget({super.key, required String html}) {
    html += getStyleTag();
    this.html = html;
  }

  @override
  Widget build(BuildContext context) {
    return Html(
      //Если поставить true то стили не будут приниматься
      shrinkWrap: false,
      data: html,
      extensions: [
        TagExtension(
            tagsToExtend: {"file-image"},
            builder: (extensionContext) {
              var fileId = extensionContext.element!.attributes['file-id']!;

              return HtmlImageViewWidget(fileId: fileId);
            }),
      ],
    );
  }
}
