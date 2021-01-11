import 'package:ecommerce_app/constants/Constants.dart';
import 'package:ecommerce_app/services/firebaseServices.dart';
import 'package:ecommerce_app/widgets/customActionBar.dart';
import 'package:ecommerce_app/widgets/imageSwipe.dart';
import 'package:ecommerce_app/widgets/productSize.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProductPage extends StatefulWidget {
  final String productId;
  ProductPage({this.productId});
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  FirebaseServices _firebaseServices = FirebaseServices();

  User user = FirebaseAuth.instance.currentUser;

  String _selectedProductSize = '0';

  Future _addToCart() {
    return _firebaseServices.userReference
        .doc(
          _firebaseServices.getUserId(),
        )
        .collection('Cart')
        .doc(widget.productId)
        .set({'size': _selectedProductSize});
  }

  Future _addToSaved() {
    return _firebaseServices.userReference
        .doc(
          _firebaseServices.getUserId(),
        )
        .collection('Saved')
        .doc(widget.productId)
        .set({'size': _selectedProductSize});
  }

  @override
  Widget build(BuildContext context) {
    final SnackBar _snackBar = SnackBar(
      content: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 4,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Product Added To Cart',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
    return Scaffold(
        body: Stack(
      children: [
        FutureBuilder(
          future:
              _firebaseServices.productReference.doc(widget.productId).get(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Scaffold(
                body: Center(
                  child: Text('Error : ${snapshot.error}'),
                ),
              );
            }

            if (snapshot.connectionState == ConnectionState.done) {
              //Firebase Document Data Map
              Map<String, dynamic> documentData = snapshot.data.data();

              //List of Images
              List imageList = documentData['images'];

              //List of Product Sizes
              List productSizes = documentData['size'];

              //Set an initial size
              _selectedProductSize = productSizes[0];

              return ListView(
                children: [
                  ImageSwipe(
                    imageList: imageList,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 24,
                      left: 24,
                      right: 24,
                      bottom: 4,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '${documentData['name']}' ?? 'Product Name',
                          style: Constants.boldHeading,
                        ),
                        Text(
                          '${documentData['variant']}' ?? 'Variant',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black26,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 24,
                    ),
                    child: Text(
                      '₹ ${documentData['price']}' ?? 'Price',
                      style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).accentColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 24,
                    ),
                    child: Text(
                      '${documentData['desc']}' ?? 'Descirption',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 24,
                      horizontal: 24,
                    ),
                    child: Text(
                      'Select Size',
                      style: Constants.regularDarkText,
                    ),
                  ),
                  ProductSize(
                    productSizes: productSizes,
                    onSelected: (size) {
                      _selectedProductSize = size;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            await _addToSaved();
                            ScaffoldMessenger.of(context)
                                .showSnackBar(_snackBar);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: 65,
                            height: 65,
                            decoration: BoxDecoration(
                              color: Color(0xffDCDCDC),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Image(
                              image: AssetImage('assets/images/tab_saved.png'),
                              height: 22,
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              await _addToCart();
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(_snackBar);
                            },
                            child: Container(
                              margin: EdgeInsets.only(left: 20),
                              alignment: Alignment.center,
                              height: 65,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Add To Cart',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
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
        CustomActionBar(
          hasBackArrow: true,
          hasTitle: false,
        ),
      ],
    ));
  }
}
