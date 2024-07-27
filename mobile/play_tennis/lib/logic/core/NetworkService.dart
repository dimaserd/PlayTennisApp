import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class HeaderNames {
  static const authenticated = "X-Authenticated";
}

class NetworkService {
  Map<String, String> headers = {"content-type": "application/json"};
  Map<String, String> cookies = {};
  String domain;
  NetworkService(this.domain);
  NetworkService.withCookies(this.domain, this.cookies);

  void _updateCookie(http.Response response) {
    String? allSetCookie = response.headers['set-cookie'];

    if (allSetCookie != null) {
      var setCookies = allSetCookie.split(',');

      for (var setCookie in setCookies) {
        var cookies = setCookie.split(';');

        for (var cookie in cookies) {
          _setCookie(cookie);
        }
      }

      headers['cookie'] = _generateCookieHeader();
    }
  }

  void _setCookie(String? rawCookie) {
    if (rawCookie != null) {
      var keyValue = rawCookie.split('=');
      if (keyValue.length == 2) {
        var key = keyValue[0].trim();
        var value = keyValue[1];

        // ignore keys that aren't cookies
        if (key == 'path' || key == 'expires') return;

        cookies[key] = value;
      }
    }
  }

  String _generateCookieHeader() {
    String cookie = "";

    for (var key in cookies.keys) {
      if (cookie.isNotEmpty) cookie += ";";
      cookie += "$key=${cookies[key]!}";
    }

    return cookie;
  }

  bool? getIsAuthenticated(http.Response response) {
    if (!response.headers.containsKey(HeaderNames.authenticated)) {
      return null;
    }

    return response.headers[HeaderNames.authenticated]! == "true";
  }

  Future<String> postData(String uriPath, String bodyJson) async {
    return postDataV2(uriPath, bodyJson, (p0) {});
  }

  Future<String> postDataV2(
    String uriPath,
    String bodyJson,
    Function(String) errorHandler,
  ) async {
    var response = await postDataInner(uriPath, bodyJson, errorHandler);

    if (response == null) {
      return "";
    }

    return response.body;
  }

  Future<Response?> postDataInner(String uriPath, String bodyJson,
      Function(String error) errorHandler) async {
    var client = http.Client();
    try {
      var url = Uri.parse(domain + uriPath);

      var response = await http.post(
        url,
        headers: headers,
        body: bodyJson,
      );

      _updateCookie(response);

      return response;
    } catch (e) {
      errorHandler.call(e.toString());
    } finally {
      client.close();
    }

    return null;
  }

  Future<String?> getData(String url) async {
    var client = http.Client();
    try {
      var uri = Uri.parse(domain + url);

      var response = await client.get(uri, headers: headers);
      _updateCookie(response);
      return response.body;
    } catch (e) {
      print(e);
    } finally {
      client.close();
    }

    return null;
  }

  Future<String?> getDataInner(String url, Function(String) onError) async {
    var client = http.Client();
    try {
      var uri = Uri.parse(domain + url);

      var response = await client.get(uri, headers: headers);
      _updateCookie(response);
      return response.body;
    } catch (e) {
      onError("Произошла ошибка при выполнении запроса. ${e.toString()}");
    } finally {
      client.close();
    }

    return null;
  }

  Future<String?> getDataWithRetry(
      String url, Future<bool> reloginAction) async {
    var client = http.Client();
    try {
      var uri = Uri.parse(domain + url);

      var response = await client.get(uri, headers: headers);

      var isAuthenticated = getIsAuthenticated(response);

      if (isAuthenticated == false) {
        await reloginAction;
        response = await client.get(uri, headers: headers);
      }

      _updateCookie(response);

      return response.body;
    } catch (e) {
      print(e);
    } finally {
      client.close();
    }

    return null;
  }
}

