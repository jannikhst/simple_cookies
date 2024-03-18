library simple_cookies;

import 'package:flutter/material.dart';
import 'package:universal_html/html.dart' as uni;

/// Class for controlling your Cookies and creating CookieBanners.
/// IMPORTANT: Don't forget to change the default value of your main-cookie-id: [acceptedCookiesId].
class Cookies {
  static _WebStorage _storage = _WebStorage();

  ///Change this to the value where you want to save your users decision.
  static String acceptedCookiesId = 'ToDo: change this';

  /// Wrap [Cookie.wrapBanner(child)] around your Site to show the CookieBanner if needed.
  /// Create your own CookieBanner by creating your own Banner Class which extends [CookieBanner].
  /// IMPORTANT: Don't forget to change the default value of your main-cookie-id: [acceptedCookiesId].
  static Widget wrapBanner({required Widget child, CookieBanner? banner}) =>
      Scaffold(body: _WrapBanner(child, banner: banner));

  /// Call this if you want to check if the users allowed cookies and show a banner if not.
  /// Create your own CookieBanner [banner] by creating your own Banner Class which extends [CookieBanner].
  /// The [acceptedId] of your own CookieBanner overwrites the [acceptedCookiesId].
  static void checkAccepted(BuildContext context, {CookieBanner? banner}) {
    if (banner == null && !exists(acceptedCookiesId)) _PopUp.show(context);
    if (banner != null && !exists(banner.acceptedId))
      _PopUp.show(context, alternative: banner);
  }

  /// Creates a new Cookie identified by [id] and saves [content] in it.
  static void create(String id, String content) => _storage.set(id, content);

  /// Returns the content of the cookie with [id].
  /// Returns [null] if there is no Cookie.
  static String? get(String id) => _storage.get(id);

  /// Checks if there exists a cookie with [id].
  static bool exists(String id) => _storage.get(id) != null;

  /// Removes an existing Cookie with [id].
  static void remove(String id) => _storage.set(id, null);

  /// Removes all in this Session created Cookies.
  static void removeAllCookies() => _storage.reset();
}

class _WebStorage {
  _WebStorage._internal();
  static final _WebStorage instance = _WebStorage._internal();
  factory _WebStorage() => instance;
  Map<String, String> _history = {};
  void reset() {
    _history.forEach((id, _) => set(id, null));
    set(Cookies.acceptedCookiesId, null);
  }

  String? get(String id) => uni.window.localStorage[id] ?? null;
  void set(String id, String? content) {
    _history.putIfAbsent(id, () => DateTime.now().toIso8601String());
    (content == null)
        ? uni.window.localStorage.remove(id)
        : uni.window.localStorage[id] = content;
  }
}

class _PopUp extends StatelessWidget {
  final Color dark = Color.fromRGBO(35, 39, 42, 1);
  final Color light = Color.fromRGBO(64, 70, 74, 1);
  static show(BuildContext context, {Widget? alternative}) => showBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (ctx) => alternative ?? _PopUp(),
        elevation: 0,
      );

  ///Example Banner
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: dark,
          borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
      margin: const EdgeInsets.symmetric(horizontal: 2),
      padding: const EdgeInsets.fromLTRB(15, 10, 15, 5),
      height: MediaQuery.of(context).size.height * 0.13,
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              'We are using Cookies!',
              style: TextStyle(color: Colors.white70, fontSize: 15),
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      if (Cookies.exists(Cookies.acceptedCookiesId))
                        Cookies.remove(Cookies.acceptedCookiesId);
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Deny',
                      style: TextStyle(color: light),
                    ),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    onPressed: () {
                      Cookies.create(Cookies.acceptedCookiesId, 'true');
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Delicious!',
                      style: TextStyle(color: dark),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

abstract class CookieBanner extends StatelessWidget {
  final String acceptedId;

  /// [acceptedId]: the Cookie where the decision should be saved
  CookieBanner(this.acceptedId);

  ///Use this in your CustomBanner
  void acceptCookies(BuildContext context) {
    Cookies.create(acceptedId, 'true');
    Navigator.pop(context);
  }

  ///Use this in your CustomBanner
  void denyCookies(BuildContext context) {
    Cookies.remove(acceptedId);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context);
}

class _WrapBanner extends StatelessWidget {
  final Widget child;
  final CookieBanner? banner;
  _WrapBanner(this.child, {this.banner});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(milliseconds: 800))
        .whenComplete(() => Cookies.checkAccepted(context, banner: banner));
    return child;
  }
}
