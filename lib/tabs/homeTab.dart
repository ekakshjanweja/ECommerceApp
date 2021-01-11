import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/constants/Constants.dart';
import 'package:ecommerce_app/screens/productPage.dart';
import 'package:ecommerce_app/widgets/customActionBar.dart';
import 'package:flutter/material.dart';

class HomeTab extends StatelessWidget {
  final CollectionReference _productReference =
      FirebaseFirestore.instance.collection('Products');
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          child: FutureBuilder<QuerySnapshot>(
            future: _productReference.get(),
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
                                                MainAxisAlignment.spaceBetween,
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
                                              color:
                                                  Theme.of(context).accentColor,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  // Positioned(
                                  //   top: 0,
                                  //   right: 16,
                                  //   child: Image(
                                  //     height: 36,
                                  //     image: AssetImage(
                                  //       'assets/images/nike_icon.png',
                                  //     ),
                                  //   ),
                                  // ),
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
        ),
        CustomActionBar(
          hasBackArrow: false,
          title: 'Home',
          hasTitle: true,
        ),
      ],
    );
  }
}
