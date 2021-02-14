import 'package:PlantHydro/themes/light_color.dart';
import 'package:PlantHydro/themes/theme.dart';
import 'package:PlantHydro/wigets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:PlantHydro/wigets/extentions.dart';

class ProductIcon extends StatelessWidget {
  final String imagePath;
  final String text;
  final bool isSelected;
  /*final ValueChanged<Category> onSelected;
  final Category model;*/
  ProductIcon({Key key, this.text, this.imagePath, this.isSelected})
      : super(key: key);

  Widget build(BuildContext context) {
    return this.text == null
        ? Container(width: 5)
        : Container(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: Container(
              padding: AppTheme.hPadding,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: this.isSelected
                    ? LightColor.background
                    : Colors.transparent,
                border: Border.all(
                  color: this.isSelected ? Colors.green : LightColor.grey,
                  width: this.isSelected ? 2 : 1,
                ),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: this.isSelected ? Color(0xfffbf2ef) : Colors.white,
                    blurRadius: 10,
                    spreadRadius: 5,
                    offset: Offset(5, 5),
                  ),
                ],
              ),
              child: Row(
                children: <Widget>[
                  this.imagePath != null
                      ? Image.asset(
                          this.imagePath,
                          height: 30,
                          width: 30,
                        )
                      : SizedBox(),
                  this.text == null
                      ? Container()
                      : Container(
                          margin: EdgeInsets.only(left: 10),
                          child: TitleText(
                            text: this.text,
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        )
                ],
              ),
            ),
          );
  }
}
