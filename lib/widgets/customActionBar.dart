import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/constants/Constants.dart';
import 'package:ecommerce_app/screens/cartPage.dart';
import 'package:ecommerce_app/services/firebaseServices.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomActionBar extends StatelessWidget {
  final String title;
  final bool hasBackArrow;
  final bool hasTitle;
  CustomActionBar({
    this.hasBackArrow,
    this.title,
    this.hasTitle,
  });

  FirebaseServices _firebaseServices = FirebaseServices();

  final CollectionReference _userReference =
      FirebaseFirestore.instance.collection('Users');

  @override
  Widget build(BuildContext context) {
    final bool _hasBackArrow = hasBackArrow ?? false;
    final bool _hasTitle = hasTitle ?? true;

    return Container(
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
      padding: EdgeInsets.only(
        top: 72,
        left: 24,
        right: 24,
        bottom: 42,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_hasBackArrow)
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                alignment: Alignment.center,
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Image(
                  color: Colors.white,
                  image: AssetImage('assets/images/back_arrow.png'),
                  width: 16,
                  height: 16,
                ),
              ),
            ),
          if (_hasTitle)
            Text(
              title ?? 'Action Bar',
              style: Constants.boldHeading,
            ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartPage(),
                ),
              );
            },
            child: Container(
              alignment: Alignment.center,
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8),
              ),
              child: StreamBuilder(
                stream: _userReference
                    .doc(
                      _firebaseServices.getUserId(),
                    )
                    .collection('Cart')
                    .snapshots(),
                builder: (context, snapshot) {
                  int _totalItems = 0;
                  if (snapshot.connectionState == ConnectionState.active) {
                    List _documents = snapshot.data.docs;
                    _totalItems = _documents.length;
                  }
                  return Text(
                    _totalItems.toString() ?? '0',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
