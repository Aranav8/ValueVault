import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:ridobike/Utils/colors.dart';

import '../../Controller/databaseController.dart';
import '../../Controller/global_controller.dart';

import '../../Utils/utils.dart';
import '../../Widgets/ad_mob_service.dart';
import '../car_details_screen.dart';
import 'form_one.dart';
import 'form_three.dart';
import 'form_two.dart';

class FormFour extends StatefulWidget {
  final String tableName;

  const FormFour({super.key, required this.tableName});

  @override
  State<FormFour> createState() => _FormFourState();
}

TextEditingController _searchKeyController = TextEditingController();
GlobalController controller = Get.find();
DataBaseController databaseController = Get.find();

class _FormFourState extends State<FormFour> {
  dynamic dbHelper;
  // InterstitialAd? _interstitialAd;

  Future<void> fetchVariants(String brand, String model, String year) async {
    try {
      await databaseController.fetchTrim(widget.tableName, brand, model, year);
    } catch (error) {
      if (kDebugMode) {
        print('Error fetching models: $error');
      }
      throw Exception('Error fetching models: $error');
    }
  }

  Widget _buildContainer(String text) {
    return Container(
      constraints: BoxConstraints(minHeight: 26, minWidth: 60),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.grey.shade100,
        border: Border.all(color: Colors.grey.shade100, width: 0.6),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: "MontserratSemiBold",
              fontSize: 12,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _createInterstitialAd();
  }

  // void _createInterstitialAd() {
  //   InterstitialAd.load(
  //     adUnitId: AdMobService.interstitialAdUnitId!,
  //     request: const AdRequest(),
  //     adLoadCallback: InterstitialAdLoadCallback(
  //       onAdLoaded: (ad) {
  //         _interstitialAd = ad;
  //         if (kDebugMode) {
  //           print("Interstitial Ad Loaded");
  //         }
  //       },
  //       onAdFailedToLoad: (error) {
  //         _interstitialAd = null;
  //         if (kDebugMode) {
  //           print("Interstitial Ad Failed to Load: $error");
  //         }
  //       },
  //     ),
  //   );
  // }
  //
  // void _showInterstitialAd() {
  //   if (_interstitialAd != null) {
  //     _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
  //       onAdDismissedFullScreenContent: (ad) {
  //         ad.dispose();
  //         _createInterstitialAd();
  //         if (kDebugMode) {
  //           print("Interstitial Ad Dismissed");
  //         }
  //       },
  //       onAdFailedToShowFullScreenContent: (ad, error) {
  //         ad.dispose();
  //         _createInterstitialAd();
  //         if (kDebugMode) {
  //           print("Interstitial Ad Failed to Show: $error");
  //         }
  //       },
  //     );
  //     _interstitialAd!.show();
  //     _interstitialAd = null;
  //   } else {
  //     if (kDebugMode) {
  //       print("Interstitial Ad is not ready yet.");
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorWhite,
      appBar: PreferredSize(
        preferredSize: Size.zero,
        child: AppBar(
          backgroundColor: Colors.black54,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 8,
              ),
              // Icon(Icons.keyboard_backspace, color: colorBlack,),

              Obx(() {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildContainer(controller.brand.value),
                      SizedBox(width: 16),
                      _buildContainer(controller.model.value),
                      SizedBox(width: 16),
                      _buildContainer(controller.year.value.toString()),
                      SizedBox(width: 16),
                      _buildContainer(controller.variant.value),
                      SizedBox(width: 16),
                    ],
                  ),
                );
              }),

              const SizedBox(
                height: 26,
              ),
              GestureDetector(
                onTap: () async {
                  if (controller.variant.value != 'Variant') {
                    await databaseController.fetchData(
                        controller.brand.value,
                        controller.model.value,
                        controller.year.value.toString(),
                        controller.variant.value,
                        "cars_table");

                    if (kDebugMode) {
                      print(databaseController.allvehicle);
                    }

                    final carData = databaseController.allvehicle.first;

                    // If car data exists, navigate to the CarDetailsScreen
                    if (kDebugMode) {
                      print("njdnckdsnckdf");
                    }
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (_) => CarDetailsScreen(
                                carData: carData,
                                tableName: widget.tableName,
                              )),
                    );
                  } else {
                    showSnackBar("Select Variant first", context);
                  }
                },
                child: const Text(
                  "Select Variant",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "MontserratBold",
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Container(
                height: 52,
                width: MediaQuery.of(context).size.width - 32,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextFormField(
                    style: const TextStyle(
                      fontFamily: "MontserratSemiBold",
                      fontSize: 14,
                      color: Colors.black,
                    ),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    controller: _searchKeyController,
                    autofocus: false,
                    onChanged: (value) {
                      setState(() {
                        databaseController.searchVariant(value);
                      });
                    },
                    decoration: InputDecoration(
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      hintText: "Search Variant....",
                      hintStyle: TextStyle(
                        fontFamily: "MontserratSemiBold",
                        fontSize: 14,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              FutureBuilder<void>(
                future: fetchVariants(controller.brand.value,
                    controller.model.value, controller.year.value),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    if (kDebugMode) {
                      print(snapshot.error);
                    } // Log the error to the console
                    return const Text("Error fetching brands");
                  } else {
                    final variants = databaseController.allTrims ?? [];
                    final searchBrands = databaseController.searchTrim ?? [];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8),
                      child: GridView.builder(
                        shrinkWrap: true,
                        // Use shrinkWrap to prevent infinite height error
                        physics: const NeverScrollableScrollPhysics(),
                        // Disable GridView scrolling
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          // Number of columns in the grid
                          // Aspect ratio of each item
                          crossAxisSpacing: 16,
                          // Horizontal spacing between grid items
                          mainAxisSpacing:
                              16, // Vertical spacing between grid items
                        ),
                        itemCount: _searchKeyController.text.isNotEmpty
                            ? searchBrands.length
                            : variants.length,
                        itemBuilder: (context, index) {
                          final variant = _searchKeyController.text.isNotEmpty
                              ? searchBrands[index]
                              : variants[index];
                          return GestureDetector(
                            onTap: () async {
                              controller.variant.value = variant;
                              if (controller.variant.value != 'Variant') {
                                await databaseController.fetchData(
                                    controller.brand.value,
                                    controller.model.value,
                                    controller.year.value.toString(),
                                    controller.variant.value,
                                    widget.tableName);

                                if (kDebugMode) {
                                  print(databaseController.allvehicle);
                                }

                                final carData =
                                    databaseController.allvehicle.first;

                                // If car data exists, navigate to the CarDetailsScreen
                                if (kDebugMode) {
                                  print("njdnckdsnckdf");
                                }

                                // _showInterstitialAd;

                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (_) => CarDetailsScreen(
                                            carData: carData,
                                            tableName: widget.tableName,
                                          )),
                                );
                              } else {
                                showSnackBar("Select Variant first", context);
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey.shade200,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 36,
                                      width: 36,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.car_rental,
                                        size: 24,
                                        color: Colors.blue,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      variant.toString(),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontFamily: "MontserratSemiBold",
                                        fontSize: 12,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
