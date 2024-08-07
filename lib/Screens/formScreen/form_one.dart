import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ridobike/Screens/formScreen/form_four.dart';
import 'package:ridobike/Screens/formScreen/form_three.dart';
import 'package:ridobike/Utils/colors.dart';
import 'package:ridobike/Utils/utils.dart';
import '../../Controller/databaseController.dart';
import '../../Controller/global_controller.dart';
import 'form_two.dart';

class FormOne extends StatefulWidget {
  final String tableName;

  const FormOne({super.key, required this.tableName});

  @override
  State<FormOne> createState() => _FormOneState();
}

TextEditingController _searchKeyController = TextEditingController();
GlobalController controller = Get.find();
DataBaseController databaseController = Get.find();

class _FormOneState extends State<FormOne> {
  Future<void> fetchBrands() async {
    try {
      // Get all distinct makes
      await databaseController.fetchMake(widget.tableName);
    } catch (error) {
      throw Exception('Error fetching brands $error');
    }
  }

  // Map to hold the display names for each table name
  final Map<String, String> tableDisplayNames = {
    'cars_table': 'Car',
    'car_table': 'Electric Car',
    'bike_table': 'Bike',
    'ebike_table': 'Electric Bike',
    'escooter_table': 'Electric Scooter',
  };

  // Function to get display name
  String getDisplayName(String tableName) {
    return tableDisplayNames[tableName] ?? 'Vehicle';
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
              const SizedBox(
                height: 16,
              ),

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

              Text(
                "Select your ${getDisplayName(widget.tableName)} Brand",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: "MontserratBold",
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              const SizedBox(
                height: 6,
              ),
              // const Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 32.0),
              //   child: Text(
              //     "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
              //     textAlign: TextAlign.center,
              //     style: TextStyle(
              //       fontFamily: "MontserratBold",
              //       fontSize: 12,
              //       color: Colors.black26,
              //     ),
              //   ),
              // ),
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
                    controller: _searchKeyController,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    autofocus: false,
                    onChanged: (value) {
                      setState(() {
                        databaseController.searchBrand(value);
                      });
                    },
                    decoration: InputDecoration(
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      hintText: "Search Brands....",
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
                future: fetchBrands(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    if (kDebugMode) {
                      print(snapshot.error);
                    } // Log the error to the console
                    return const Text("Error fetching brands");
                  } else {
                    final brands = databaseController.allMakes;
                    final searchBrands = databaseController.searchMakes;
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0.0, vertical: 8),
                      child: GridView.builder(
                        shrinkWrap: true,
                        // Use shrinkWrap to prevent infinite height error
                        physics: const NeverScrollableScrollPhysics(),
                        // Disable GridView scrolling
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          // Number of columns in the grid
                          // Aspect ratio of each item
                          crossAxisSpacing: 8,
                          // Horizontal spacing between grid items
                          mainAxisSpacing:
                              8, // Vertical spacing between grid items
                        ),
                        itemCount: _searchKeyController.text.isNotEmpty
                            ? searchBrands.length
                            : brands.length,
                        itemBuilder: (context, index) {
                          final brand = _searchKeyController.text.isNotEmpty
                              ? searchBrands[index]
                              : brands[index];
                          return GestureDetector(
                            onTap: () {
                              controller.brand.value = brand;
                              controller.model.value = 'Model';
                              controller.year.value = '2024';
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  fullscreenDialog: true,
                                  builder: (_) =>
                                      FormTwo(tableName: widget.tableName),
                                ),
                              );
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
                                    Image.asset(
                                      "assets/brands/$brand.png",
                                      width: 38,
                                      height: 38,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        String defaultIconPath;
                                        if (kDebugMode) {
                                          print(
                                              'Table Name: ${widget.tableName}');
                                        }
                                        switch (widget.tableName) {
                                          case 'cars_table':
                                            defaultIconPath =
                                                'assets/defaultBrands/Car.png';
                                            break;
                                          case 'bike_table':
                                            defaultIconPath =
                                                'assets/defaultBrands/Bike.png';
                                            break;
                                          case 'car_table':
                                            defaultIconPath =
                                                'assets/defaultBrands/Electric car.png';
                                            break;
                                          case 'ebike_table':
                                            defaultIconPath =
                                                'assets/defaultBrands/Electric bike.png';
                                            break;
                                          case 'escooter_table':
                                            defaultIconPath =
                                                'assets/defaultBrands/Electric Scooter.png';
                                            break;
                                          default:
                                            if (kDebugMode) {
                                              print(
                                                  'Warning: Unexpected table name "${widget.tableName}". Using default Car icon.');
                                            }
                                            defaultIconPath =
                                                'assets/defaultBrands/Car.png';
                                        }

                                        if (kDebugMode) {
                                          print(
                                              'Using default icon: $defaultIconPath');
                                        }

                                        return Image.asset(
                                          defaultIconPath,
                                          width: 38,
                                          height: 38,
                                          color: Colors.grey,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            if (kDebugMode) {
                                              print(
                                                  'Error loading default icon: $defaultIconPath');
                                            }
                                            return const Icon(
                                              Icons.error,
                                              color: Colors.red,
                                              size: 38,
                                            );
                                          },
                                        );
                                      },
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      brand,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontFamily: "MontserratSemiBold",
                                        fontSize: 12,
                                        color: Colors.black,
                                      ),
                                      overflow: TextOverflow.ellipsis,
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

class ArteonScreen extends StatefulWidget {
  final String tableName;

  const ArteonScreen({super.key, required this.tableName});

  @override
  State<ArteonScreen> createState() => _ArteonScreenState();
}

class _ArteonScreenState extends State<ArteonScreen> {
  dynamic dbHelper;

  @override
  void initState() {
    super.initState();
    // Initialize the appropriate database helper based on the vehicle type
    if (widget.tableName == 'Car') {
    } else if (widget.tableName == 'Motorcycle') {}
  }

  Future<List<String>> fetchBrands() async {
    try {
      // Get all distinct makes
      List<String> allMakes = await dbHelper.getAllMakes();
      return allMakes;
    } catch (error) {
      throw Exception('Error fetching brands $error');
    }
  }

  Future<void> showBottomModal(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.red,
      barrierColor: Colors.transparent,
      isScrollControlled: true,
      useSafeArea: true,
      constraints:
          BoxConstraints(minHeight: MediaQuery.of(context).size.height),
      builder: (BuildContext context) {
        return Container(
          constraints:
              BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  decoration: const BoxDecoration(),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 26.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 16,
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                constraints: const BoxConstraints(
                                  minHeight: 26,
                                  minWidth: 60,
                                ),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                        color: Colors.grey.shade100,
                                        width: 0.6)),
                                child: const Center(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16.0),
                                    child: Text(
                                      "Maruti",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: "MontserratSemiBold",
                                        fontSize: 12,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                constraints: const BoxConstraints(
                                  minHeight: 26,
                                  minWidth: 60,
                                ),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.grey.shade100,
                                    border: Border.all(
                                        color: Colors.grey.shade100,
                                        width: 0.6)),
                                child: const Center(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16.0),
                                    child: Text(
                                      "Model",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: "MontserratSemiBold",
                                        fontSize: 12,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                constraints: const BoxConstraints(
                                  minHeight: 26,
                                  minWidth: 60,
                                ),
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                        color: Colors.grey.shade100,
                                        width: 0.6)),
                                child: const Center(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16.0),
                                    child: Text(
                                      "Year",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: "MontserratSemiBold",
                                        fontSize: 12,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                constraints: const BoxConstraints(
                                  minHeight: 26,
                                  minWidth: 60,
                                ),
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                        color: Colors.grey.shade100,
                                        width: 0.6)),
                                child: const Center(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16.0),
                                    child: Text(
                                      "Trim",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: "MontserratSemiBold",
                                        fontSize: 12,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(
                            height: 26,
                          ),

                          const Text(
                            "Select your Car Brand",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: "MontserratBold",
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          // const Padding(
                          //   padding: EdgeInsets.symmetric(horizontal: 32.0),
                          //   child: Text(
                          //     "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                          //     textAlign: TextAlign.center,
                          //     style: TextStyle(
                          //       fontFamily: "MontserratBold",
                          //       fontSize: 12,
                          //       color: Colors.black26,
                          //     ),
                          //   ),
                          // ),
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: TextFormField(
                                style: const TextStyle(
                                  fontFamily: "MontserratSemiBold",
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                                decoration: InputDecoration(
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  hintText: "Search Brands....",
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
                          FutureBuilder<List<String>>(
                            future: fetchBrands(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                // Log the error to the console
                                return const Text("Error fetching brands");
                              } else {
                                final brands = snapshot.data ?? [];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 0.0, vertical: 8),
                                  child: GridView.builder(
                                    shrinkWrap: true,
                                    // Use shrinkWrap to prevent infinite height error
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    // Disable GridView scrolling
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 4,
                                      // Number of columns in the grid
                                      // Aspect ratio of each item
                                      crossAxisSpacing: 8,
                                      // Horizontal spacing between grid items
                                      mainAxisSpacing:
                                          8, // Vertical spacing between grid items
                                    ),
                                    itemCount: brands.length,
                                    itemBuilder: (context, index) {
                                      final brand = brands[index];
                                      return GestureDetector(
                                        onTap: () {
                                          controller.brand.value = brand;
                                          controller.model.value = '';
                                          controller.year.value = "2024";
                                          // controller.trim.value = '';
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.grey.shade200,
                                              width: 1,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                    "assets/brands/pingwing.com (5).png"),
                                                const SizedBox(height: 8),
                                                Text(
                                                  brand,
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                    fontFamily:
                                                        "MontserratSemiBold",
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
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.75,
                height: MediaQuery.of(context).size.height * 0.5,
                decoration: const BoxDecoration(
                    color: Colors.black54,
                    borderRadius:
                        BorderRadius.only(bottomRight: Radius.circular(40))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 36,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 16.0),
                      child: Icon(Icons.arrow_back_ios_new_outlined,
                          color: Colors.white),
                    ),
                    const SizedBox(
                      height: 36,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            '\$ 35 845',
                            style: TextStyle(
                              color: Colors.yellow.shade800,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Container(
                            height: 24,
                            width: 24,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              border: Border.all(color: Colors.grey.shade800),
                              borderRadius: BorderRadius.circular(1000.0),
                            ),
                            child: Center(
                              child: Text(
                                '25',
                                style: TextStyle(
                                  color: Colors.yellow.shade800,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Arteon 2019',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Image.asset(
                      'assets/images/yellowCar.png',
                      // Replace with your image asset
                      height: 200,
                      width: 400,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 48.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 4,
                            width: 4,
                            decoration: const BoxDecoration(
                                color: colorWhite, shape: BoxShape.circle),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Container(
                            height: 4,
                            width: 4,
                            decoration: const BoxDecoration(
                                color: Colors.white54, shape: BoxShape.circle),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Container(
                            height: 4,
                            width: 4,
                            decoration: const BoxDecoration(
                                color: Colors.white54, shape: BoxShape.circle),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Container(
                            height: 4,
                            width: 4,
                            decoration: const BoxDecoration(
                                color: Colors.white54, shape: BoxShape.circle),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                color: const Color(0xff1e1e1f),
                width: MediaQuery.of(context).size.width * 0.25,
                height: MediaQuery.of(context).size.height * 0.5,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 48,
                    ),
                    const Icon(Icons.crop_free, color: Colors.white),
                    const SizedBox(
                      height: 38,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: tabItem("Technology", false),
                    ),
                    const SizedBox(
                      height: 48,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 36.0),
                      child: tabItem("Specification", false),
                    ),
                    const SizedBox(
                      height: 48,
                    ),
                    tabItem("Overview", true),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 36),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 36.0),
            child: Text(
              'The All-New Arteon.\nDesigned to Steal\nAttention.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 36.0),
            child: Text(
              'An evolution of the classic\nfastback design and interior\ncomfort.',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(height: 36),
          Obx(() {
            return GestureDetector(
              onTap: () {
                showBottomModal(context);
              },
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 36.0),
                  child: Container(
                    height: 60,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: colorWhite,
                        borderRadius: BorderRadius.circular(20)),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 26.0)
                            .copyWith(right: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                                child: Text(controller.brand.value != ''
                                    ? controller.brand.value
                                    : "Select Brand")),
                            GestureDetector(
                              onTap: () {
                                if (controller.brand.value == '') {
                                  showSnackBar("Select Brand First", context);
                                } else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => FormTwo(
                                                tableName: widget.tableName,
                                              )));
                                }
                              },
                              child: Container(
                                height: 36,
                                width: 36,
                                decoration: BoxDecoration(
                                    color: Colors.yellow.shade800,
                                    borderRadius: BorderRadius.circular(12)),
                                child: Icon(
                                  Icons.more_horiz,
                                  color: colorBlack.withOpacity(0.5),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )),
            );
          })
        ],
      ),
    );
  }
}

Widget tabItem(String title, bool isSelected) {
  return Transform.rotate(
    angle: -3.142 * 0.5,
    child: Column(
      children: [
        Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white54,
            fontSize: 16,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        const SizedBox(height: 4),
        if (isSelected)
          Container(
            height: 4,
            width: 4,
            decoration: const BoxDecoration(
              color: Colors.yellow,
              shape: BoxShape.circle,
            ),
          )
      ],
    ),
  );
}
