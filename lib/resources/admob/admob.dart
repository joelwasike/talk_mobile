// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:usersms/resources/comments.dart';
// import 'package:usersms/resources/heartanimationwidget.dart';
// import 'package:usersms/utils/colors.dart';

// class GoogleAds extends StatefulWidget {
//   const GoogleAds({super.key});

//   @override
//   GoogleAdsState createState() => GoogleAdsState();
// }

// class GoogleAdsState extends State<GoogleAds> {
//   NativeAd? nativeAd;
//   bool _nativeAdIsLoaded = false;
//   bool boom = false;
//   int likes = 1;
//   bool isliked = false;
//   bool isHeartAnimating = false;
//   var userid;

//   final String _adUnitId = Platform.isAndroid
//       ? 'ca-app-pub-3940256099942544/2247696110'
//       : 'ca-app-pub-3940256099942544/3986624511';

//   /// Loads a native ad.
//   void loadAd() {
//     nativeAd = NativeAd(
//         adUnitId: _adUnitId,
//         listener: NativeAdListener(
//           onAdClicked: (ad) {},
//           onAdImpression: (ad) {},
//           onAdClosed: (ad) {},
//           onAdOpened: (ad) {},
//           onAdWillDismissScreen: (ad) {},
//           onPaidEvent: (ad, valueMicros, precision, currencyCode) {},
//           onAdLoaded: (ad) {
//             debugPrint('$NativeAd loaded.');
//             setState(() {
//               _nativeAdIsLoaded = true;
//             });
//           },
//           onAdFailedToLoad: (ad, error) {
//             // Dispose the ad here to free resources.
//             debugPrint('$NativeAd failed to load: $error');
//             ad.dispose();
//           },
//         ),
//         request: const AdRequest(),
//         // Styling
//         nativeTemplateStyle: NativeTemplateStyle(
//             // Required: Choose a template.
//             templateType: TemplateType.medium,
//             // Optional: Customize the ad's style.
//             mainBackgroundColor: Colors.black,
//             cornerRadius: 10.0,
//             callToActionTextStyle: NativeTemplateTextStyle(
//                 textColor: LightColor.background,
//                 backgroundColor: LightColor.maincolor,
//                 style: NativeTemplateFontStyle.monospace,
//                 size: 16.0),
//             primaryTextStyle: NativeTemplateTextStyle(
//                 textColor: LightColor.scaffold,
//                 backgroundColor: Colors.cyan,
//                 style: NativeTemplateFontStyle.italic,
//                 size: 16.0),
//             secondaryTextStyle: NativeTemplateTextStyle(
//                 textColor: LightColor.scaffold,
//                 backgroundColor: Colors.black,
//                 style: NativeTemplateFontStyle.bold,
//                 size: 16.0),
//             tertiaryTextStyle: NativeTemplateTextStyle(
//                 textColor: LightColor.scaffold,
//                 backgroundColor: LightColor.maincolor,
//                 style: NativeTemplateFontStyle.normal,
//                 size: 16.0)))
//       ..load();
//   }

//   @override
//   void initState() {
//     super.initState();
//     loadAd();
//   }

//   @override
//   void dispose() {
//     nativeAd?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: [
//                     CircleAvatar(
//                       backgroundImage:
//                           AssetImage("assets/talklogo.v1.cropped-modified.png"),
//                     ),
//                     const SizedBox(
//                       width: 10,
//                     ),
//                     Text(
//                       "Talk",
//                       style: TextStyle(
//                         color: Colors.grey.shade300,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           GestureDetector(
//             onDoubleTap: () {
//               setState(() {
//                 isHeartAnimating = true;
//                 isliked = true;
//                 if (!boom) {
//                   if (isliked) {
//                     setState(() {
//                       likes++;
//                     });
//                   }
//                   if (!isliked) {
//                     setState(() {
//                       likes--;
//                     });
//                   }
//                 }
//                 boom = true;
//               });
//             },
//             child: Stack(alignment: Alignment.center, children: [
//               _nativeAdIsLoaded && nativeAd != null
//                   ? ConstrainedBox(
//                       constraints: const BoxConstraints(
//                           minWidth: 320, // minimum recommended width
//                           minHeight: 320, // minimum recommended height
//                           maxHeight: 350,
//                           maxWidth: 350),
//                       child: AdWidget(ad: nativeAd!),
//                     )
//                   : Container(
//                       // You can customize the container as needed.
//                       width: 320,
//                       height: 320,
//                       color: Colors.grey,
//                       child: Center(),
//                     ),
//               Opacity(
//                 opacity: isHeartAnimating ? 1 : 0,
//                 child: HeartAnimationWidget(
//                     isAnimating: isHeartAnimating,
//                     duration: const Duration(milliseconds: 700),
//                     onEnd: () => setState(() {
//                           isHeartAnimating = false;
//                         }),
//                     child: Icon(
//                       Icons.favorite,
//                       color: Colors.grey.shade300,
//                       size: 100,
//                     )),
//               )
//             ]),
//           ),
//           const SizedBox(
//             height: 10,
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 2),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: [
//                     HeartAnimationWidget(
//                       alwaysAnimate: true,
//                       isAnimating: isliked,
//                       child: IconButton(
//                         icon: Icon(
//                           isliked ? Icons.favorite : FontAwesomeIcons.heart,
//                           color: isliked ? Colors.red : Colors.grey.shade300,
//                           size: 28,
//                         ),
//                         onPressed: () {
//                           setState(() {
//                             isliked = !isliked;
//                             if (isliked) {
//                               setState(() {
//                                 likes++;
//                               });
//                             }
//                             if (!isliked) {
//                               setState(() {
//                                 likes--;
//                               });
//                             }
//                           });
//                         },
//                       ),
//                     ),
//                     IconButton(
//                       onPressed: () {
//                         showModalBottomSheet(
//                             useSafeArea: true,
//                             isScrollControlled: true,
//                             enableDrag: true,
//                             context: context,
//                             builder: (context) => Container(
//                                 padding: EdgeInsets.only(
//                                     bottom: MediaQuery.of(context)
//                                         .viewInsets
//                                         .bottom),
//                                 decoration: const BoxDecoration(
//                                     color: LightColor.maincolor1,
//                                     borderRadius: BorderRadius.only(
//                                         topRight: Radius.circular(25),
//                                         topLeft: Radius.circular(25))),
//                                 child: Comments(
//                                   getcommenturl: "widget.getcommenturl",
//                                   postcommenturl: "widget.postcommenturl",
//                                   postid: 0,
//                                 )));
//                       },
//                       icon: Icon(
//                         FontAwesomeIcons.message,
//                         color: Colors.grey.shade300,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 const Text(
//                   "Liked by ",
//                 ),
//                 Text(
//                   "50",
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 const Text(
//                   " students",
//                 )
//               ],
//             ),
//           ),
//           Align(
//             alignment: Alignment.topLeft,
//             child: Padding(
//               padding: const EdgeInsets.only(left: 8),
//               child: RichText(
//                   text: TextSpan(children: [
//                 TextSpan(
//                     text: "Check this out",
//                     style:
//                         TextStyle(color: Colors.grey.shade300, fontSize: 14)),
//               ])),
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   /// Loads a native ad.
// }
