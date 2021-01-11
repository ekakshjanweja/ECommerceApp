import 'package:flutter/material.dart';

class ProductSize extends StatefulWidget {
  final List productSizes;
  final Function(String) onSelected;
  ProductSize({
    this.productSizes,
    this.onSelected,
  });
  @override
  _ProductSizeState createState() => _ProductSizeState();
}

class _ProductSizeState extends State<ProductSize> {
  int _selected = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        bottom: 24,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (var i = 0; i < widget.productSizes.length; i++)
            GestureDetector(
              onTap: () {
                widget.onSelected(
                  '${widget.productSizes[i]}',
                );
                setState(() {
                  _selected = i;
                  widget.onSelected('${widget.productSizes[i]}');
                });
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOutCubic,
                alignment: Alignment.center,
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: _selected == i
                      ? Theme.of(context).accentColor
                      : Color(0xffDCDCDC),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${widget.productSizes[i]}',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: _selected == i ? Colors.white : Colors.black,
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}
