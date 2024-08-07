import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:ridobike/Model/database_model.dart';
import 'package:ridobike/Utils/colors.dart';
import 'package:ridobike/Widgets/ad_mob_service.dart';
import '../Controller/databaseController.dart';
import '../Widgets/price_selector.dart';

class CarDetailsScreen extends StatefulWidget {
  final DataBaseModel carData;
  final String tableName;
  const CarDetailsScreen(
      {super.key, required this.carData, required this.tableName});

  @override
  State<CarDetailsScreen> createState() => _CarDetailsScreenState();
}

DataBaseController databaseController = Get.find();

class _CarDetailsScreenState extends State<CarDetailsScreen> {
  List<Map<String, String>> variantsList = [];
  List<String> variantNameList = [];
  InterstitialAd? _interstitialAd;

  Future<void> getVariant() async {
    await databaseController.fetchVariantForNewCra(
        '${widget.carData.make} ${widget.carData.model}');

    String variantsString =
        databaseController.allNewCarVariant.first['Variants'].toString();

    // Split the string by comma to get each variant
    List<String> variantsArray = variantsString.split(',');

    // Process each variant
    for (String variant in variantsArray) {
      List<String> parts = variant.split(':');

      if (parts.length == 2) {
        String variantName = parts[0].trim();
        String variantPrice = parts[1].trim();

        variantsList.add({'name': variantName, 'price': variantPrice});
        variantNameList.add(variantName);
      }
    }
    // Print the results to verify
    for (var variant in variantsList) {}
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadInterstitialAd();
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    super.dispose();
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdMobService.interstitialAdUnitId!,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('Interstitial Ad loaded');
          _interstitialAd = ad;

          // Show the ad after it's loaded
          _interstitialAd!.show();
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('Interstitial Ad failed to load: $error');
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String imagePath;

    switch (widget.tableName) {
      // Assuming carData has a property `tableName`
      case 'cars_table':
        imagePath = 'assets/defaultIndividualVehicles/car.png';
        break;
      case 'bike_table':
        imagePath = 'assets/defaultIndividualVehicles/bike.png';
        break;
      case 'car_table':
        imagePath = 'assets/defaultIndividualVehicles/car.png';
        break;
      case 'ebike_table':
        imagePath = 'assets/defaultIndividualVehicles/electric bike.png';
        break;
      case 'escooter_table':
        imagePath = 'assets/defaultIndividualVehicles/electric scooty.png';
        break;
      default:
        imagePath = 'assets/images/default_vehicle.png'; // Default image
        break;
    }

    print(
        "min: ${widget.carData.minPrice} and max: ${widget.carData.maxPrice}");

    return Scaffold(
      backgroundColor: colorWhite,
      appBar: PreferredSize(
        preferredSize: Size.zero,
        child: AppBar(
          backgroundColor: colorWhite,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  // const Padding(
                  //   padding: EdgeInsets.symmetric(vertical: 8.0),
                  //   child:
                  //   Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     crossAxisAlignment: CrossAxisAlignment.center,
                  //     children: [
                  //       Text(
                  //         "Vehicle Condition:",
                  //         style: TextStyle(
                  //             fontSize: 16,
                  //             fontFamily: "MontserratSemiBold",
                  //             color: colorBlack),
                  //       ),
                  //       SizedBox(
                  //         width: 4,
                  //       ),
                  //       Row(
                  //         mainAxisAlignment: MainAxisAlignment.start,
                  //         crossAxisAlignment: CrossAxisAlignment.center,
                  //         children: [
                  //           Text(
                  //             "Good",
                  //             style: TextStyle(
                  //                 fontSize: 16,
                  //                 fontFamily: "MontserratSemiBold",
                  //                 color: colorPrimary),
                  //           ),
                  //           Icon(
                  //             Icons.arrow_drop_down,
                  //             color: colorBlack,
                  //           )
                  //         ],
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // ContainerSelection(
                  //   carData: widget.carData,
                  // ),
                  // Divider(
                  //   thickness: 1,
                  //   color: Colors.grey.shade200,
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Comprehensive Plan",
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: "MontserratSemiBold",
                                color: colorBlack),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            widget.carData.make,
                            style: const TextStyle(
                                fontSize: 16,
                                fontFamily: "MontserratBold",
                                color: colorBlack),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(8)),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 4),
                                child: Text(
                                  widget.carData.model,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontFamily: "MontserratSemiBold",
                                      color: colorBlack),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Image.asset(
                        imagePath,
                        width: 150,
                        height: 100,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Car Brand",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: "MontserratSemiBold",
                                  color: colorBlack),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              widget.carData.make,
                              style: const TextStyle(
                                  fontSize: 15,
                                  fontFamily: "MontserratBold",
                                  color: colorBlack),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Car Model",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: "MontserratSemiBold",
                                  color: colorBlack),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              widget.carData.model,
                              style: const TextStyle(
                                  fontSize: 15,
                                  fontFamily: "MontserratBold",
                                  color: colorBlack),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox()
                    ],
                  ),
                  const SizedBox(
                    height: 26,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Car Variant",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: "MontserratSemiBold",
                                  color: colorBlack),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              widget.carData.trim,
                              style: const TextStyle(
                                  fontSize: 15,
                                  fontFamily: "MontserratBold",
                                  color: colorBlack),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Year",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: "MontserratSemiBold",
                                  color: colorBlack),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              widget.carData.year.toString(),
                              style: const TextStyle(
                                  fontSize: 15,
                                  fontFamily: "MontserratBold",
                                  color: colorBlack),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox()
                    ],
                  ),
                  const SizedBox(
                    height: 26,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Car Ownership",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: "MontserratSemiBold",
                                  color: colorBlack),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              "private",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: "MontserratBold",
                                  color: colorBlack),
                            ),
                          ],
                        ),
                      ),
                      // Expanded(
                      //   child: Column(
                      //     mainAxisAlignment: MainAxisAlignment.start,
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      //       Text(
                      //         "Total KM run",
                      //         style: TextStyle(
                      //             fontSize: 12,
                      //             fontFamily: "MontserratSemiBold",
                      //             color: colorBlack),
                      //       ),
                      //       SizedBox(
                      //         height: 4,
                      //       ),
                      //       Text(
                      //         "1200 KM",
                      //         style: TextStyle(
                      //             fontSize: 15,
                      //             fontFamily: "MontserratBold",
                      //             color: colorBlack),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      SizedBox()
                    ],
                  ),
                  const SizedBox(
                    height: 26,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Price",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: "MontserratSemiBold",
                                  color: colorBlack),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            ContainerSelection(
                              carData: widget.carData,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 26,
                  ),
                  // Divider(
                  //   thickness: 1,
                  //   color: Colors.grey.shade200,
                  // ),
                  // const Padding(
                  //   padding: EdgeInsets.symmetric(vertical: 8.0),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     crossAxisAlignment: CrossAxisAlignment.center,
                  //     children: [
                  //       Icon(
                  //         Icons.downloading_rounded,
                  //         color: colorPrimary,
                  //         size: 24,
                  //       ),
                  //       SizedBox(
                  //         width: 4,
                  //       ),
                  //       Text(
                  //         "Download Car Description",
                  //         style: TextStyle(
                  //             fontSize: 16,
                  //             fontFamily: "MontserratSemiBold",
                  //             color: colorPrimary),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // Divider(
                  //   thickness: 1,
                  //   color: Colors.grey.shade200,
                  // ),
                ],
              ),

              // FutureBuilder<void>(
              //     future: getVariant(),
              //     builder: (context, snapshot) {
              //       if (snapshot.connectionState == ConnectionState.waiting) {
              //         // Return a loading indicator or an empty container
              //         return Center(
              //             child: CircularProgressIndicator(
              //               color: colorPrimary,
              //               strokeWidth: 2,
              //             ));
              //       } else if (snapshot.hasError) {
              //         // Handle errors
              //         return Center(child: Text("Error"));
              //       } else {
              //         return
              //           DefaultTabController(
              //             length: variantsList.length,
              //             child: Column(
              //               mainAxisSize: MainAxisSize.min,
              //               children: [
              //                 TabBar(
              //
              //                   physics: BouncingScrollPhysics(),
              //                   indicatorSize: TabBarIndicatorSize.label,
              //                   indicatorWeight: 0.5,
              //                   isScrollable: true,
              //                   tabAlignment: TabAlignment.start,
              //                   tabs: [
              //                     for (String variant in variantNameList)
              //                       Tab(text: variant.capitalizeFirst),
              //                   ],
              //                   labelColor: Colors.black,
              //                   labelStyle: TextStyle(
              //                       fontSize: 14,
              //                       fontFamily: "MontserratSemiBold",
              //                       color: colorPrimary),
              //                   unselectedLabelColor: Colors.grey,
              //                   indicatorColor: colorPrimary,
              //                   dividerColor: Colors.transparent,
              //                 ),
              //                 Container(
              //                   height: MediaQuery.of(context).size.height * 0.5,
              //                   child: TabBarView(
              //                     physics: BouncingScrollPhysics(),
              //                     children: [
              //                       // Content for Tab 1
              //                       for (String variant in variantNameList)
              //                          Column(
              //                         mainAxisAlignment: MainAxisAlignment.start,
              //                         crossAxisAlignment: CrossAxisAlignment.start,
              //                         children: [
              //                           const SizedBox(
              //                             height: 26,
              //                           ),
              //                           Row(
              //                             mainAxisAlignment:
              //                             MainAxisAlignment.spaceBetween,
              //                             crossAxisAlignment: CrossAxisAlignment.center,
              //                             children: [
              //                               Column(
              //                                 mainAxisAlignment:
              //                                 MainAxisAlignment.start,
              //                                 crossAxisAlignment:
              //                                 CrossAxisAlignment.start,
              //                                 children: [
              //                                   const Text(
              //                                     "Comprehensive Plan",
              //                                     style: TextStyle(
              //                                         fontSize: 14,
              //                                         fontFamily: "MontserratSemiBold",
              //                                         color: colorBlack),
              //                                   ),
              //                                   const SizedBox(
              //                                     height: 4,
              //                                   ),
              //                                   const Text(
              //                                     "Ford FreeStyle",
              //                                     style: TextStyle(
              //                                         fontSize: 16,
              //                                         fontFamily: "MontserratBold",
              //                                         color: colorBlack),
              //                                   ),
              //                                   const SizedBox(
              //                                     height: 4,
              //                                   ),
              //                                   Container(
              //                                     decoration: BoxDecoration(
              //                                         color: Colors.grey.shade200,
              //                                         borderRadius:
              //                                         BorderRadius.circular(8)),
              //                                     child: const Center(
              //                                       child: Padding(
              //                                         padding: EdgeInsets.symmetric(
              //                                             horizontal: 8.0, vertical: 4),
              //                                         child: Text(
              //                                           "KL07 S 0949",
              //                                           style: TextStyle(
              //                                               fontSize: 12,
              //                                               fontFamily:
              //                                               "MontserratSemiBold",
              //                                               color: colorBlack),
              //                                         ),
              //                                       ),
              //                                     ),
              //                                   ),
              //                                 ],
              //                               ),
              //                               Image.asset(
              //                                 "assets/images/car.png",
              //                                 width: 150,
              //                                 height: 100,
              //                                 fit: BoxFit.cover,
              //                               ),
              //                             ],
              //                           ),
              //                           const SizedBox(
              //                             height: 16,
              //                           ),
              //                           const Row(
              //                             mainAxisAlignment:
              //                             MainAxisAlignment.spaceBetween,
              //                             crossAxisAlignment: CrossAxisAlignment.center,
              //                             children: [
              //                               Expanded(
              //                                 child: Column(
              //                                   mainAxisAlignment:
              //                                   MainAxisAlignment.start,
              //                                   crossAxisAlignment:
              //                                   CrossAxisAlignment.start,
              //                                   children: [
              //                                     Text(
              //                                       "Start Date",
              //                                       style: TextStyle(
              //                                           fontSize: 12,
              //                                           fontFamily:
              //                                           "MontserratSemiBold",
              //                                           color: colorBlack),
              //                                     ),
              //                                     SizedBox(
              //                                       height: 4,
              //                                     ),
              //                                     Text(
              //                                       "2023-04-14",
              //                                       style: TextStyle(
              //                                           fontSize: 15,
              //                                           fontFamily: "MontserratBold",
              //                                           color: colorBlack),
              //                                     ),
              //                                   ],
              //                                 ),
              //                               ),
              //                               Expanded(
              //                                 child: Column(
              //                                   mainAxisAlignment:
              //                                   MainAxisAlignment.start,
              //                                   crossAxisAlignment:
              //                                   CrossAxisAlignment.start,
              //                                   children: [
              //                                     Text(
              //                                       "End Date",
              //                                       style: TextStyle(
              //                                           fontSize: 12,
              //                                           fontFamily:
              //                                           "MontserratSemiBold",
              //                                           color: colorBlack),
              //                                     ),
              //                                     SizedBox(
              //                                       height: 4,
              //                                     ),
              //                                     Text(
              //                                       "2023-04-14",
              //                                       style: TextStyle(
              //                                           fontSize: 15,
              //                                           fontFamily: "MontserratBold",
              //                                           color: colorBlack),
              //                                     ),
              //                                   ],
              //                                 ),
              //                               ),
              //                               SizedBox()
              //                             ],
              //                           ),
              //                           const SizedBox(
              //                             height: 26,
              //                           ),
              //                           const Row(
              //                             mainAxisAlignment:
              //                             MainAxisAlignment.spaceBetween,
              //                             crossAxisAlignment: CrossAxisAlignment.center,
              //                             children: [
              //                               Expanded(
              //                                 child: Column(
              //                                   mainAxisAlignment:
              //                                   MainAxisAlignment.start,
              //                                   crossAxisAlignment:
              //                                   CrossAxisAlignment.start,
              //                                   children: [
              //                                     Text(
              //                                       "Policy Holder",
              //                                       style: TextStyle(
              //                                           fontSize: 12,
              //                                           fontFamily:
              //                                           "MontserratSemiBold",
              //                                           color: colorBlack),
              //                                     ),
              //                                     SizedBox(
              //                                       height: 4,
              //                                     ),
              //                                     Text(
              //                                       "Anurag Kashyap",
              //                                       style: TextStyle(
              //                                           fontSize: 15,
              //                                           fontFamily: "MontserratBold",
              //                                           color: colorBlack),
              //                                     ),
              //                                   ],
              //                                 ),
              //                               ),
              //                               Expanded(
              //                                 child: Column(
              //                                   mainAxisAlignment:
              //                                   MainAxisAlignment.start,
              //                                   crossAxisAlignment:
              //                                   CrossAxisAlignment.start,
              //                                   children: [
              //                                     Text(
              //                                       "Evaluated Price",
              //                                       style: TextStyle(
              //                                           fontSize: 12,
              //                                           fontFamily:
              //                                           "MontserratSemiBold",
              //                                           color: colorBlack),
              //                                     ),
              //                                     SizedBox(
              //                                       height: 4,
              //                                     ),
              //                                     Text(
              //                                       "₹ 1,88,949",
              //                                       style: TextStyle(
              //                                           fontSize: 15,
              //                                           fontFamily: "MontserratBold",
              //                                           color: colorBlack),
              //                                     ),
              //                                   ],
              //                                 ),
              //                               ),
              //                               SizedBox()
              //                             ],
              //                           ),
              //                           const SizedBox(
              //                             height: 26,
              //                           ),
              //                         ],
              //                       ),
              //                     ],
              //                   ),
              //                 ),
              //               ],
              //             ),
              //           );
              //       }
              //     }),

              Divider(
                thickness: 1,
                color: Colors.grey.shade200,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.keyboard_backspace,
                        color: colorPrimary,
                        size: 24,
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Text(
                        "Check another vehicle",
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: "MontserratSemiBold",
                            color: colorPrimary),
                      ),
                    ],
                  ),
                ),
              ),
              Divider(
                thickness: 1,
                color: Colors.grey.shade200,
              ),
              const SizedBox(
                height: 16,
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Disclaimer",
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: "MontserratBold",
                          color: colorBlack),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      "Above displayed value are based on estimates and industry standards. Actual market value might be different.",
                      style: TextStyle(
                          fontSize: 12,
                          fontFamily: "MontserratSemiBold",
                          color: colorBlack),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 26,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
