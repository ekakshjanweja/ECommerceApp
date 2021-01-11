import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/constants/Constants.dart';
import 'package:ecommerce_app/screens/productPage.dart';
import 'package:ecommerce_app/services/firebaseServices.dart';
import 'package:ecommerce_app/widgets/customInput.dart';
import 'package:flutter/material.dart';

class SearchTab extends StatefulWidget {
  @override
  _SearchTabState createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  FirebaseServices _firebaseServices = FirebaseServices();

  String searchString = '';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.only(top: 0),
        child: Stack(
          children: [
            if (searchString.isEmpty)
              Center(
                child: Container(
                  child: Text(
                    'Search Results',
                    style: Constants.regularDarkText,
                  ),
                ),
              )
            else
              FutureBuilder<QuerySnapshot>(
                future: _firebaseServices.productReference
                    .orderBy('name')
                    .startAt(['$searchString']).endAt(
                        ['$searchString\uf8ff']).get(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Scaffold(
                      body: Center(
                        child: Text('Error : ${snapshot.error}'),
                      ),
                    );
                  }
                  //Collection data is ready to be displayed
                  if (snapshot.connectionState == ConnectionState.done) {
                    //Displaying data inside a listview
                    return ListView(
                      padding: EdgeInsets.only(
                        top: 144,
                        bottom: 24,
                      ),
                      children: snapshot.data.docs
                          .map(
                            (document) => Center(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProductPage(
                                        productId: document.id,
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  height: 354,
                                  margin: EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 24,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.network(
                                          '${document.data()['images'][0]}',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        left: 0,
                                        right: 0,
                                        child: Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '${document.data()['name']}' ??
                                                        'Name',
                                                    style: Constants
                                                        .regularHeadingSmall,
                                                  ),
                                                  Text(
                                                      '${document.data()['variant']}' ??
                                                          'Variant'),
                                                ],
                                              ),
                                              Text(
                                                '₹ ${document.data()['price']}' ??
                                                    'Price',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                  color: Theme.of(context)
                                                      .accentColor,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    );
                  }

                  // Loding State
                  return Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.blue,
                        strokeWidth: 4,
                      ),
                    ),
                  );
                },
              ),
            Container(
              padding: EdgeInsets.only(top: 45),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white,
                    Colors.white.withOpacity(0),
                  ],
                  begin: Alignment(0, 0),
                  end: Alignment(0, 1),
                ),
              ),
              child: CustomInput(
                hintText: 'Search Here . . . . . ',
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    setState(() {
                      searchString = value.toUpperCase();
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
