import 'dart:ffi';

import 'package:PlantHydro/themes/light_color.dart';
import 'package:PlantHydro/themes/theme.dart';
import 'package:PlantHydro/wigets/title_text.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

class ProductCard extends StatefulWidget {
  /*final Product product;
  final ValueChanged<Product> onSelected;*/
  final String name;
  final String image;
  final double waterlevel;
  final List pump_h;
  final List pump_m;
  final int pump_index;
  final String soilmeasure;
  final String floattingtime;
  final String ftcounter;
  final int like;
  ProductCard({
    Key key,
    this.name,
    this.image,
    this.waterlevel,
    this.pump_h,
    this.pump_m,
    this.pump_index,
    this.soilmeasure,
    this.floattingtime,
    this.ftcounter,
    this.like,
  }) : super(key: key);

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: LightColor.background,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: <BoxShadow>[
          BoxShadow(color: Color(0xfff8f8f8), blurRadius: 5, spreadRadius: 5),
        ],
      ),
      margin: EdgeInsets.symmetric(
          vertical: /*!product.isSelected ? 20 : 0*/ 5, horizontal: 10),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            LiquidLinearProgressIndicator(
              value: widget.waterlevel == null
                  ? -0.5
                  : widget.waterlevel == 0
                      ? -0.05
                      : widget.waterlevel / 100,
              direction: Axis.vertical,
              backgroundColor: Colors.white,
              valueColor: AlwaysStoppedAnimation(Colors.blue.withOpacity(0.2)),
              borderRadius: 12.0,
            ),
            Positioned(
              right: 10,
              top: 0,
              child: IconButton(
                icon: Icon(
                  widget.like == 1 ? Icons.favorite : Icons.favorite_border,
                  color:
                      widget.like == 1 ? LightColor.red : LightColor.iconColor,
                ),
                onPressed: () {
                  /*if (widget.like == 1) {
                    print("haha");
                    data_pro.update("like", (value) => "0");
                  } else {
                    print("haha");
                    data_pro.update("like", (value) => "1");
                  }*/
                },
              ),
            ),
            Row(
              children: <Widget>[
                //SizedBox(height: /*product.isSelected ? 15 : */ 0),
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: LightColor.orange.withAlpha(40),
                      ),
                      Image.asset(this.widget.image)
                    ],
                  ),
                ),
                // SizedBox(height: 5),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 8),
                      width: 100,
                      child: Text(
                        widget.name,
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      height: 98,
                      child: Row(
                        children: [
                          Column(
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      /*border: Border.all(
                                        width: 2,
                                        color: Colors.grey,
                                      ),
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(20),
                                        bottomRight: Radius.circular(10),
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(10),
                                      ),*/
                                    ),
                                    alignment: Alignment.center,
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 40,
                                        ),
                                        Container(
                                          width: 40,
                                          alignment: Alignment.center,
                                          margin: EdgeInsets.only(
                                              right: 5, left: 2),
                                          child: Text(
                                            widget.soilmeasure,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w300,
                                              color: Colors.brown,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(13)),
                                      color: Theme.of(context).backgroundColor,
                                      border: Border.all(
                                        width: 0.2,
                                        color: Colors.grey,
                                      ),
                                      //color: Color(0xffc8c8c8),
                                      /*boxShadow: [
                                        BoxShadow(
                                            color: Color(0xfff8f8f8),
                                            blurRadius: 2,
                                            spreadRadius: 2)
                                      ],*/
                                    ),
                                    child: Container(
                                        height: 20,
                                        child: Image.asset("assets/sm.png")),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Stack(
                                children: [
                                  Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      /*border: Border.all(
                                        width: 0,
                                        color: Colors.grey,
                                      ),
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(20),
                                        bottomRight: Radius.circular(10),
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(10),
                                      ),*/
                                    ),
                                    alignment: Alignment.center,
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 40,
                                        ),
                                        Container(
                                          width: 40,
                                          alignment: Alignment.center,
                                          margin: EdgeInsets.only(
                                              right: 5, left: 2),
                                          child: Text(
                                            widget.waterlevel.toString(),
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w300,
                                              color: Colors.blue,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(13)),
                                      color: Theme.of(context).backgroundColor,
                                      border: Border.all(
                                        width: 0.2,
                                        color: Colors.grey,
                                      ),
                                      //color: Color(0xffc8c8c8),
                                      /*boxShadow: [
                                        BoxShadow(
                                            color: Color(0xfff8f8f8),
                                            blurRadius: 2,
                                            spreadRadius: 2)
                                      ],*/
                                    ),
                                    child: Container(
                                        height: 20,
                                        child: Image.asset("assets/wl.png")),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      /*border: Border.all(
                                        width: 0,
                                        color: Colors.grey,
                                      ),
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(20),
                                        bottomRight: Radius.circular(10),
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(10),
                                      ),*/
                                    ),
                                    alignment: Alignment.center,
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 40,
                                        ),
                                        Container(
                                          width: 40,
                                          alignment: Alignment.center,
                                          margin: EdgeInsets.only(
                                              right: 5, left: 2),
                                          child: Text(
                                            widget.floattingtime.toString(),
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w300,
                                              color: Colors.green,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(13)),
                                      color: Theme.of(context).backgroundColor,
                                      border: Border.all(
                                        width: 0.2,
                                        color: Colors.grey,
                                      ),
                                      //color: Color(0xffc8c8c8),
                                      /*boxShadow: [
                                        BoxShadow(
                                            color: Color(0xfff8f8f8),
                                            blurRadius: 2,
                                            spreadRadius: 2)
                                      ],*/
                                    ),
                                    child: Container(
                                        height: 20,
                                        child: Image.asset("assets/sl.png")),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Stack(
                                children: [
                                  Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      /*border: Border.all(
                                        width: 2,
                                        color: Colors.grey,
                                      ),
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(20),
                                        bottomRight: Radius.circular(10),
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(10),
                                      ),*/
                                    ),
                                    alignment: Alignment.center,
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 40,
                                        ),
                                        Container(
                                          width: 40,
                                          alignment: Alignment.center,
                                          margin: EdgeInsets.only(
                                              right: 5, left: 2),
                                          child: Text(
                                            widget.soilmeasure,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w300,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(13)),
                                      color: Theme.of(context).backgroundColor,
                                      border: Border.all(
                                        width: 0.2,
                                        color: Colors.grey,
                                      ),
                                      //color: Color(0xffc8c8c8),
                                      /*boxShadow: [
                                        BoxShadow(
                                            color: Color(0xfff8f8f8),
                                            blurRadius: 2,
                                            spreadRadius: 2)
                                      ],*/
                                    ),
                                    child: Container(
                                        height: 20,
                                        child:
                                            Image.asset("assets/counter.png")),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 5,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        padding: EdgeInsets.only(left: 0),
                        width: 200,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: BouncingScrollPhysics(),
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                          itemCount: widget.pump_h.length,
                          itemBuilder: (context, index) {
                            return Container(
                              padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                              child: Container(
                                //padding: EdgeInsets.all(5.0),
                                width: 70.0,
                                decoration: BoxDecoration(
                                  //color: Theme.of(context).accentColor,
                                  color: index == widget.pump_index
                                      ? Colors.grey
                                      : Colors.transparent,
                                  border: Border.all(
                                    width: 2,
                                    color: Colors.grey,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  widget.pump_h[index].toString() +
                                      ":" +
                                      widget.pump_m[index].toString(),
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Positioned(
              left: 0,
              top: 0,
              child: IconButton(
                icon: Icon(
                  Icons.camera_alt_outlined,
                  color: LightColor.iconColor,
                ),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
