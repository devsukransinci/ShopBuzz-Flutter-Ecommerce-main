import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:shopbuzz_ecommerce/const/app_color.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _dotPositioned = 0;
  List<String> _carouselImages = [];
  List _products = [];
  var _firestoreInstance = FirebaseFirestore.instance;

  final TextEditingController _searchController = TextEditingController();

  fecthCarouselImages() async {
    QuerySnapshot qn =
        await _firestoreInstance.collection("carousel-slider").get();
    setState(() {
      for (int i = 0; i < qn.docs.length; i++) {
        _carouselImages.add(qn.docs[i]["img-path"]);
      }
    });
    return qn.docs;
  }

  fetchProducts() async {
    QuerySnapshot qn =
        await _firestoreInstance.collection("products-data").get();
    setState(() {
      for (int i = 0; i < qn.docs.length; i++) {
        _products.add({
          "product-name": qn.docs[i]["product-name"],
          "product-description": qn.docs[i]["product-description"],
          "product-price": qn.docs[i]["product-price"],
          "product-image": qn.docs[i]["product-img"]
        });
      }
    });
    return qn.docs;
  }

  @override
  void initState() {
    fecthCarouselImages();
    fetchProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: SafeArea(
            child: Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 50.0,
                        child: TextFormField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(0)),
                                borderSide: BorderSide(
                                  color: Colors.blue,
                                )),
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(0)),
                                borderSide: BorderSide(
                                  color: Colors.grey,
                                )),
                            hintText: "Search Product Here",
                            hintStyle: TextStyle(fontSize: 14.0),
                            prefixIcon: Icon(Icons.search),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        height: 50.0,
                        width: 50.0,
                        color: AppColors.green_accent,
                        child: Center(
                          child: Icon(
                            Icons.search,
                            color: Colors.white,
                            size: 35,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              AspectRatio(
                aspectRatio: 2.2,
                child: CarouselSlider(
                    items: _carouselImages
                        .map((item) => Padding(
                              padding: const EdgeInsets.only(left: 8, right: 8),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Image.network(
                                    item,
                                    width: 500,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ))
                        .toList(),
                    options: CarouselOptions(
                        autoPlay: true,
                        autoPlayInterval: Duration(seconds: 03),
                        autoPlayAnimationDuration: Duration(microseconds: 800),
                        enlargeCenterPage: true,
                        // height: 600,
                        viewportFraction: 0.8,
                        enlargeStrategy: CenterPageEnlargeStrategy.height,
                        onPageChanged: (val, carouselPageChangedReason) {
                          setState(() {
                            _dotPositioned = val;
                          });
                        })),
              ),
              SizedBox(
                height: 10.0,
              ),
              DotsIndicator(
                dotsCount:
                    _carouselImages.length == 0 ? 1 : _carouselImages.length,
                position: _dotPositioned.toDouble(),
                decorator: DotsDecorator(
                  activeColor: AppColors.green_accent,
                  color: Colors.green.shade400,
                  spacing: EdgeInsets.all(2),
                  activeSize: Size(10, 10),
                  size: Size(8, 8),
                ),
              ),
              SizedBox(
                height: 10,
              ),
        
             
            ],
          ),
        )),
      ),
    );
  }
}
