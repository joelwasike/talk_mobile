import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:usersms/utils/colors.dart';
import '../screens/homepage.dart';

class Portal extends StatefulWidget {
  const Portal({Key? key}) : super(key: key);

  @override
  State<Portal> createState() => _PortalState();
}

class _PortalState extends State<Portal> {
  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController? webViewController;
  InAppWebViewSettings settings = InAppWebViewSettings(
      useShouldOverrideUrlLoading: true,
      mediaPlaybackRequiresUserGesture: false,
      allowsInlineMediaPlayback: true,
      iframeAllow: "camera; microphone",
      iframeAllowFullscreen: true);

  PullToRefreshController? pullToRefreshController;
  String url = "";
  double progress = 0;
  final urlController = TextEditingController();

  @override
  void initState() {
    super.initState();

    pullToRefreshController = kIsWeb
        ? null
        : PullToRefreshController(
            settings: PullToRefreshSettings(
              color: LightColor.maincolor,
            ),
            onRefresh: () async {
              if (defaultTargetPlatform == TargetPlatform.android) {
                webViewController?.reload();
              } else if (defaultTargetPlatform == TargetPlatform.iOS) {
                webViewController?.loadUrl(
                    urlRequest:
                        URLRequest(url: await webViewController?.getUrl()));
              }
            },
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: SizedBox(
          height: 40,
          width: 40,
          child: FloatingActionButton(
            onPressed: () {},
            backgroundColor: Colors.grey.shade900,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
            ),
            child: const DrawerWidget(),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
        body: Column(children: <Widget>[
          Expanded(
            child: Stack(
              children: [
                InAppWebView(
                  key: webViewKey,
                  initialUrlRequest:
                      URLRequest(url: WebUri("https://portal.kibu.ac.ke/")),
                  initialSettings: settings,
                  pullToRefreshController: pullToRefreshController,
                  onWebViewCreated: (controller) {
                    webViewController = controller;
                  },
                  onLoadStart: (controller, url) {
                    setState(() {
                      this.url = url.toString();
                      urlController.text = this.url;
                    });
                  },
                  onPermissionRequest: (controller, request) async {
                    return PermissionResponse(
                        resources: request.resources,
                        action: PermissionResponseAction.GRANT);
                  },
                  shouldOverrideUrlLoading:
                      (controller, navigationAction) async {
                    var uri = navigationAction.request.url!;

                    if (![
                      "http",
                      "https",
                      "file",
                      "chrome",
                      "data",
                      "javascript",
                      "about"
                    ].contains(uri.scheme)) {
                      if (await canLaunchUrl(uri)) {
                        // Launch the App
                        await launchUrl(
                          uri,
                        );
                        // and cancel the request
                        return NavigationActionPolicy.CANCEL;
                      }
                    }

                    return NavigationActionPolicy.ALLOW;
                  },
                  onLoadStop: (controller, url) async {
                    pullToRefreshController?.endRefreshing();
                    setState(() {
                      this.url = url.toString();
                      urlController.text = this.url;
                    });
                  },
                  onReceivedError: (controller, request, error) {
                    pullToRefreshController?.endRefreshing();
                  },
                  onProgressChanged: (controller, progress) {
                    if (progress == 100) {
                      pullToRefreshController?.endRefreshing();
                    }
                    setState(() {
                      this.progress = progress / 100;
                      urlController.text = this.url;
                    });
                  },
                  onUpdateVisitedHistory: (controller, url, androidIsReload) {
                    setState(() {
                      this.url = url.toString();
                      urlController.text = this.url;
                    });
                  },
                  onConsoleMessage: (controller, consoleMessage) {
                    print(consoleMessage);
                  },
                ),
                progress < 1.0
                    ? LinearProgressIndicator(value: progress)
                    : Container(),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ButtonBar(
                    alignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      FloatingActionButton(
                        backgroundColor: LightColor.maincolor1,
                        mini: true,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              30.0), // Adjust the radius as needed
                        ),
                        child: const Icon(Icons.arrow_back, color: LightColor.maincolor,),
                        onPressed: () {
                          webViewController?.goBack();
                        },
                      ),
                      FloatingActionButton(
                        backgroundColor: LightColor.maincolor1,
                        mini: true,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              30.0), // Adjust the radius as needed
                        ),
                        child: const Icon(Icons.arrow_forward, color: LightColor.maincolor,),
                        onPressed: () {
                          webViewController?.goForward();
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ]));
  }
}
