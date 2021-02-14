import 'dart:ui';

import 'package:PlantHydro/main.dart';
import 'package:PlantHydro/themes/light_color.dart';
import 'package:PlantHydro/themes/theme.dart';
import 'package:PlantHydro/wigets/custom_drop_down.dart';
import 'package:PlantHydro/wigets/extentions.dart';
import 'package:PlantHydro/wigets/title_text.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ProductDetailPage extends StatefulWidget {
  final Query dbref_query;
  final DatabaseReference dbref;
  final String path;

  ProductDetailPage({Key key, this.dbref_query, this.dbref, this.path})
      : super(key: key);

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage>
    with TickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;
  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    animation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInToLinear));
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  bool realorimage = false;
  String statevalue;
  List statelist = ["idle", "pump", "release", "float"];
  GlobalKey dropdownKey = GlobalKey();

  Widget _appBar({int like, String id}) {
    return Container(
      padding: AppTheme.padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 40,
                  width: 40,
                  //padding: EdgeInsets.all(10),
                  padding: EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(13)),
                    color: Theme.of(context).backgroundColor,
                    border: Border.all(
                      color: LightColor.grey,
                      width: 1.5,
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.white,
                        blurRadius: 5,
                        spreadRadius: 5,
                        offset: Offset(5, 5),
                      ),
                    ],
                  ),
                  child: RotatedBox(
                    quarterTurns: 4,
                    child: Icon(
                      Icons.arrow_back_ios,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Container(
                child: Text(
                  //ds == true ? "Home" : "Group",
                  "Back",
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    if (realorimage)
                      realorimage = false;
                    else
                      realorimage = true;
                  });
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 40,
                  width: 40,
                  //padding: EdgeInsets.all(10),
                  //padding: EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(13)),
                    color: Theme.of(context).backgroundColor,
                    border: Border.all(
                      color: LightColor.grey,
                      width: 1.5,
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.white,
                        blurRadius: 5,
                        spreadRadius: 5,
                        offset: Offset(5, 5),
                      ),
                    ],
                  ),
                  child: RotatedBox(
                    quarterTurns: 4,
                    child: Icon(
                        realorimage == true
                            ? Icons.camera_alt
                            : Icons.camera_alt_outlined,
                        color: Colors.black54),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              GestureDetector(
                onTap: () {
                  if (like == 1) {
                    like = 0;
                  } else {
                    like = 1;
                  }
                  widget.dbref
                      .child(widget.path + "/pr_" + id)
                      .update({'like': like});
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 40,
                  width: 40,
                  //padding: EdgeInsets.all(10),
                  //padding: EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(13)),
                    color: Theme.of(context).backgroundColor,
                    border: Border.all(
                      color: LightColor.grey,
                      width: 1.5,
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.white,
                        blurRadius: 5,
                        spreadRadius: 5,
                        offset: Offset(5, 5),
                      ),
                    ],
                  ),
                  child: RotatedBox(
                    quarterTurns: 4,
                    child: Icon(
                      like == 1 ? Icons.favorite : Icons.favorite_border,
                      color: like == 1 ? LightColor.red : LightColor.iconColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _icon(IconData icon, {Color color = LightColor.iconColor}) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(13)),
          color: Theme.of(context).backgroundColor,
          //color: Color(0xffc8c8c8),
          boxShadow: AppTheme.shadow,
        ),
        child: Icon(
          icon,
          color: color,
        ),
      ),
    );
  }

  Widget _productImage({String tag, String avt}) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        TitleText(
          text: realorimage == false ? "IMG" : "REAL",
          fontSize: 130,
          color: LightColor.lightGrey,
        ),
        Hero(
          tag: tag,
          child: Image.asset('assets/' + avt),
        )
      ],
    );
  }

  Widget _categoryWidget() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 0),
      width: AppTheme.fullWidth(context),
      height: 80,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            color: Colors.red,
            height: 40,
            width: 50,
          ),
        ],
      ),
      //AppData.showThumbnailList.map((x) => _thumbnail(x)).toList()),
    );
  }

  Widget _thumbnail(String image) {
    return AnimatedBuilder(
      animation: animation,
      //  builder: null,
      builder: (context, child) => AnimatedOpacity(
        opacity: animation.value,
        duration: Duration(milliseconds: 500),
        child: child,
      ),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: Container(
          height: 40,
          width: 50,
          decoration: BoxDecoration(
            border: Border.all(
              color: LightColor.grey,
            ),
            borderRadius: BorderRadius.all(Radius.circular(13)),
            // color: Theme.of(context).backgroundColor,
          ),
          child: Image.asset(image),
        ).ripple(() {}, borderRadius: BorderRadius.all(Radius.circular(13))),
      ),
    );
  }

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();

  Future<void> addfloattime(BuildContext context,
      {String id, int pump_i, List pump_m, List pump_h}) async {
    List mm = [for (var i = 0; i < 60; i += 1) i];
    List hh = [for (var i = 0; i < 24; i += 1) i];
    int h = 0;
    int m = 0;
    int pumphre = 0;
    int pumpmre = 0;

    void hourchange(setState, value) {
      setState(() {
        h = value;
      });
    }

    void minchange(setState, value) {
      setState(() {
        m = value;
      });
    }

    void floatimechange(setState, pump_h, pump_m, index, id) {
      setState(() {
        pumphre = pump_h[index];
        pumpmre = pump_m[index];
        pump_h.removeAt(index);
        pump_m.removeAt(index);
        widget.dbref
            .child(widget.path + "/pr_" + id)
            .update({"pump_water_h": pump_h});
        widget.dbref
            .child(widget.path + "/pr_" + id)
            .update({"pump_water_m": pump_m});
        print(pump_h);
        print(pump_m);
      });
    }

    void addtimechane(setState, pump_h, pump_m, hh, mm) {
      setState(() {
        pump_h.add(hh);
        pump_m.add(mm);
      });
    }

    return await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, StateSetter setState) {
            return AlertDialog(
              title: Text("Adding Float Time Scheduler"),
              content: Form(
                //key: _formKey2,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Hour",
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Container(
                              height: 40,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: LightColor.iconColor,
                                    style: BorderStyle.solid),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(13)),
                                color: Theme.of(context).backgroundColor,
                              ),
                              child: DropdownButton(
                                underline: Container(),
                                style: TextStyle(
                                  color: LightColor.titleTextColor,
                                  fontSize: 16,
                                ),
                                iconSize: 0.0,
                                value: h,
                                onChanged: (value) {
                                  hourchange(setState, value);
                                  print(h);

                                  /*if (value != state)
                                                  widget.dbref
                                                      .child("IOT/plants/pr_" + id)
                                                      .update({'water_state': value});*/
                                  /*setState(() {
                                                  statevalue = value;
                                                  print(statevalue);
                                                });*/
                                },
                                items: hh.map((e) {
                                  return DropdownMenuItem(
                                    child: Container(
                                      child: Text(e < 10
                                          ? "0" + e.toString() + " h"
                                          : e.toString() + " h"),
                                    ),
                                    value: e,
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Minute",
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Container(
                              height: 40,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: LightColor.iconColor,
                                    style: BorderStyle.solid),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(13)),
                                color: Theme.of(context).backgroundColor,
                              ),
                              child: CustomDropdownButton(
                                underline: Container(),
                                style: TextStyle(
                                  color: LightColor.titleTextColor,
                                  fontSize: 16,
                                ),
                                iconSize: 0.0,
                                value: m,
                                onChanged: (value) async {
                                  minchange(setState, value);
                                  print(m);
                                  /*if (value != state)
                                                  widget.dbref
                                                      .child("IOT/plants/pr_" + id)
                                                      .update({'water_state': value});*/
                                  /*setState(() {
                                                  statevalue = value;
                                                  print(statevalue);
                                                });*/
                                },
                                items: mm.map((e) {
                                  return CustomDropdownMenuItem(
                                    child: Container(
                                      child: Text(e < 10
                                          ? "0" + e.toString() + " m"
                                          : e.toString() + " m"),
                                    ),
                                    value: e,
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Float time scheduler"),
                    SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        padding: EdgeInsets.only(left: 0),
                        width: 200,
                        height: 30,
                        child: GridView.builder(
                          padding: EdgeInsets.only(bottom: 40),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 5.0,
                            mainAxisSpacing: 5.0,
                          ),
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: (pump_h.length + pump_m.length) ~/ 2,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                print(index);
                                //if (pump_i != index) {
                                floatimechange(
                                    setState, pump_h, pump_m, index, id);
                                /*widget.dbref
                                    .child("IOT/plants/pr_" + id)
                                    .update({"pump_water_h": pump_h});
                                widget.dbref
                                    .child("IOT/plants/pr_" + id)
                                    .update({"pump_water_m": pump_m});*/
                                /*widget.dbref
                                    .child(
                                        "IOT/plants/pr_" + id + "/pump_water_h")
                                    .child(index.toString())
                                    .remove();
                                widget.dbref
                                    .child(
                                        "IOT/plants/pr_" + id + "/pump_water_m")
                                    .child(index.toString())
                                    .remove();*/
                                //}
                              },
                              child: Container(
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: Container(
                                  width: 60.0,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: index == pump_i
                                        ? Colors.grey
                                        : Colors.transparent,
                                    border: Border.all(
                                      width: 2,
                                      color: Colors.grey,
                                    ),
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    ((pump_h[index] < 10) &&
                                            (pump_m[index] > 10))
                                        ? "0" +
                                            pump_h[index].toString() +
                                            ":" +
                                            pump_m[index].toString()
                                        : ((pump_h[index] < 10) &&
                                                (pump_m[index] < 10))
                                            ? "0" +
                                                pump_h[index].toString() +
                                                ":" +
                                                "0" +
                                                pump_m[index].toString()
                                            : ((pump_h[index] > 10) &&
                                                    (pump_m[index] > 10))
                                                ? pump_h[index].toString() +
                                                    ":" +
                                                    pump_m[index].toString()
                                                : ((pump_h[index] > 10) &&
                                                        (pump_m[index] < 10))
                                                    ? pump_h[index].toString() +
                                                        ":" +
                                                        "0" +
                                                        pump_m[index].toString()
                                                    : pump_h[index].toString() +
                                                        ":" +
                                                        pump_m[index]
                                                            .toString(),
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Click button "
                        "Add"
                        " to adding new float time scheduler, Click any time in time scheduler to remove it from list, Click restore to restore the backup value"),
                  ],
                ),
              ),
              actions: [
                if (pumphre != -1)
                  TextButton(
                    onPressed: () {
                      ftaddcheck = false;
                      addtimechane(setState, pump_h, pump_m, pumphre, pumpmre);
                      widget.dbref
                          .child(widget.path + "/pr_" + id + "/pump_water_h")
                          //.child((pump_h.length + 1).toString())
                          .update({(pump_h.length - 1).toString(): pumphre});
                      widget.dbref
                          .child(widget.path + "/pr_" + id + "/pump_water_m")
                          //.child((pump_m.length + 1).toString());
                          .update({(pump_m.length - 1).toString(): pumpmre});
                      //if (_formKey2.currentState.validate()) {
                      /*widget.dbref
                        .child("IOT/plants/pr_" + id + "/pump_water_h")
                        .child((pump_h.length + 1).toString()).update()
                    widget.dbref
                        .child("IOT/plants/pr_" + id + "/pump_water_m")
                        .child((pump_m.length + 1).toString());*/
                      //await Future.delayed(const Duration(microseconds: 500), () {});
                      //Navigator.of(context).pop();
                      //}
                    },
                    child: Text("Restore"),
                  ),
                TextButton(
                  onPressed: () {
                    ftaddcheck = false;
                    addtimechane(setState, pump_h, pump_m, h, m);
                    //if (_formKey2.currentState.validate()) {
                    widget.dbref
                        .child(widget.path + "/pr_" + id + "/pump_water_h")
                        //.child((pump_h.length + 1).toString())
                        .update({(pump_h.length - 1).toString(): h});
                    widget.dbref
                        .child(widget.path + "/pr_" + id + "/pump_water_m")
                        //.child((pump_m.length + 1).toString());
                        .update({(pump_m.length - 1).toString(): m});
                    //await Future.delayed(const Duration(microseconds: 500), () {});
                    //Navigator.of(context).pop();
                    //}
                  },
                  child: Text("Add"),
                ),
                TextButton(
                  onPressed: () {
                    ftaddcheck = false;
                    //if (_formKey2.currentState.validate()) {
                    /*widget.dbref
                        .child("IOT/plants/pr_" + id)
                        .update({'float_time': int.parse(text.text)});*/
                    //await Future.delayed(const Duration(microseconds: 500), () {});
                    Navigator.of(context).pop();
                    //}
                  },
                  child: Text("Okay"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> changefloattime(BuildContext context, {String id}) async {
    return await showDialog(
      context: context,
      builder: (context) {
        final TextEditingController text = TextEditingController();
        int time;
        return AlertDialog(
          title: Text("Change Float Time"),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  validator: (value) {
                    return value.isNotEmpty ? null : "Invalid Field";
                  },
                  keyboardType: TextInputType.number,
                  controller: text,
                  decoration: InputDecoration(
                    hintText: "Enter float time in minute",
                    hintStyle: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text("Click button okay to change float time")
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                ftcheck = false;
                if (_formKey.currentState.validate()) {
                  widget.dbref
                      .child(widget.path + "/pr_" + id)
                      .update({'float_time': int.parse(text.text)});
                  await Future.delayed(
                      const Duration(microseconds: 500), () {});
                  Navigator.of(context).pop();
                }
              },
              child: Text("Okay"),
            )
          ],
        );
      },
    );
  }

  bool ftcheck = false;

  bool ftaddcheck = false;

  Widget _detailWidget({
    String name,
    String state,
    String id,
    String sm,
    String wl,
    String sl,
    String ct,
    List pump_h,
    List pump_m,
    int pump_select,
    String des,
  }) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Container(
        height: AppTheme.fullHeight(context) + 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              height: 290,
            ),
            Expanded(
              child: Container(
                padding: AppTheme.padding.copyWith(bottom: 0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                    color: Colors.white),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    SizedBox(height: 5),
                    Container(
                      alignment: Alignment.center,
                      child: Container(
                        width: 50,
                        height: 5,
                        decoration: BoxDecoration(
                            color: LightColor.iconColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          TitleText(text: name, fontSize: 30),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              TitleText(
                                text: "State",
                                fontSize: 18,
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              GestureDetector(
                                onTap: () {
                                  GestureDetector detector;
                                  void searchForGestureDetector(
                                      BuildContext element) {
                                    element.visitChildElements((element) {
                                      if (element.widget != null &&
                                          element.widget is GestureDetector) {
                                        detector = element.widget;
                                        return false;
                                      } else {
                                        searchForGestureDetector(element);
                                      }

                                      return true;
                                    });
                                  }

                                  searchForGestureDetector(
                                      dropdownKey.currentContext);
                                  assert(detector != null);

                                  detector.onTap();
                                },
                                child: Container(
                                  height: 40,
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: LightColor.iconColor,
                                        style:
                                            /*!isSelected
                                            ? BorderStyle.solid
                                            : */
                                            BorderStyle.solid),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(13)),
                                    color:
                                        /*isSelected
                                        ? LightColor.orange
                                        : */
                                        Theme.of(context).backgroundColor,
                                  ),
                                  child: CustomDropdownButton(
                                    key: dropdownKey,
                                    underline: Container(),
                                    style: TextStyle(
                                      color: LightColor.titleTextColor,
                                      fontSize: 16,
                                    ),
                                    iconSize: 0.0,
                                    value: state,
                                    onChanged: (value) {
                                      if (value != state)
                                        widget.dbref
                                            .child(widget.path + "/pr_" + id)
                                            .update({'water_state': value});
                                      /*setState(() {
                                        statevalue = value;
                                        print(statevalue);
                                      });*/
                                    },
                                    items: statelist.map((e) {
                                      return CustomDropdownMenuItem(
                                        child: Container(
                                          child: Text(e[0].toUpperCase() +
                                              e.substring(1)),
                                        ),
                                        value: e,
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        TitleText(
                          text: "Soil Measure",
                          fontSize: 16,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 40,
                          width: 100,
                          padding: EdgeInsets.fromLTRB(0, 0, 10, 10),
                          /*decoration: BoxDecoration(
                                border: Border.all(
                                    color: LightColor.iconColor,
                                    style: BorderStyle.solid),
                                borderRadius: BorderRadius.all(Radius.circular(13)),
                                color: Theme.of(context).backgroundColor,
                              ),*/
                          child: Row(
                            children: [
                              Image.asset("assets/sm.png"),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                sm,
                                style: TextStyle(
                                  color: LightColor.titleTextColor,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            TitleText(
                              text: "Water level",
                              fontSize: 16,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: 40,
                              width: 100,
                              padding: EdgeInsets.fromLTRB(0, 0, 10, 10),
                              /*decoration: BoxDecoration(
                                    border: Border.all(
                                        color: LightColor.iconColor,
                                        style: BorderStyle.solid),
                                    borderRadius: BorderRadius.all(Radius.circular(13)),
                                    color: Theme.of(context).backgroundColor,
                                  ),*/
                              child: Row(
                                children: [
                                  Image.asset("assets/wl.png"),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    wl + " %",
                                    style: TextStyle(
                                      color: LightColor.titleTextColor,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        if (double.parse(wl) != 0)
                          Container(
                            padding: EdgeInsets.all(10),
                            child: CircularPercentIndicator(
                              radius: 60.0,
                              lineWidth: 5.0,
                              animation: true,
                              percent: double.parse(wl) / 100,
                              center: Text(wl + "%"),
                              circularStrokeCap: CircularStrokeCap.round,
                              backgroundColor: Colors.white,
                              progressColor: Colors.blue.withOpacity(0.5),
                            ),
                          ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            TitleText(
                              text: "Float time",
                              fontSize: 16,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            GestureDetector(
                              onTap: () async {
                                setState(() {
                                  ftcheck = true;
                                });
                                await changefloattime(context, id: id);
                              },
                              child: Container(
                                height: 40,
                                width: 110,
                                padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: ftcheck == true
                                        ? LightColor.orange
                                        : LightColor.iconColor,
                                    style: BorderStyle.solid,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(13)),
                                  color: Theme.of(context).backgroundColor,
                                ),
                                child: Row(
                                  children: [
                                    Image.asset("assets/sl.png"),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      int.parse(sl) > 60
                                          ? (int.parse(sl) / 60)
                                                  .toInt()
                                                  .toString() +
                                              "h" +
                                              (int.parse(sl) % 60)
                                                  .toInt()
                                                  .toString() +
                                              "m"
                                          : sl + " min",
                                      style: TextStyle(
                                        color: LightColor.titleTextColor,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            TitleText(
                              text: "Counter float time",
                              fontSize: 16,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: 40,
                              width: 110,
                              padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                              /*decoration: BoxDecoration(
                                border: Border.all(
                                    color: LightColor.iconColor,
                                    style: BorderStyle.solid),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(13)),
                                color: Theme.of(context).backgroundColor,
                              ),*/
                              child: Row(
                                children: [
                                  Image.asset("assets/counter.png"),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    int.parse(ct) > 60
                                        ? (int.parse(ct) / 60)
                                                .toInt()
                                                .toString() +
                                            "m" +
                                            (int.parse(ct) % 60)
                                                .toInt()
                                                .toString() +
                                            "s"
                                        : ct + " s",
                                    style: TextStyle(
                                      color: LightColor.titleTextColor,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        TitleText(
                          text: "Float time Schedule",
                          fontSize: 16,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: BouncingScrollPhysics(),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 50,
                                //color: Colors.red,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  //physics: BouncingScrollPhysics(),
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                                  itemCount:
                                      (pump_h.length + pump_m.length) ~/ 2,
                                  itemBuilder: (context, index) {
                                    return Row(
                                      //crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          //padding: EdgeInsets.all(10),
                                          height: 50,
                                          width: 80,
                                          alignment: Alignment.center,
                                          padding: EdgeInsets.fromLTRB(
                                              10, 10, 10, 10),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: LightColor.iconColor,
                                                style: index != pump_select
                                                    ? BorderStyle.solid
                                                    : BorderStyle.none),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(13)),
                                            color: index == pump_select
                                                ? LightColor.orange
                                                : Theme.of(context)
                                                    .backgroundColor,
                                          ),
                                          child: TitleText(
                                            text: ((pump_h[index] < 10) &&
                                                    (pump_m[index] > 10))
                                                ? "0" +
                                                    pump_h[index].toString() +
                                                    ":" +
                                                    pump_m[index].toString()
                                                : ((pump_h[index] < 10) &&
                                                        (pump_m[index] < 10))
                                                    ? "0" +
                                                        pump_h[index]
                                                            .toString() +
                                                        ":" +
                                                        "0" +
                                                        pump_m[index].toString()
                                                    : ((pump_h[index] > 10) &&
                                                            (pump_m[index] >
                                                                10))
                                                        ? pump_h[index]
                                                                .toString() +
                                                            ":" +
                                                            pump_m[index]
                                                                .toString()
                                                        : ((pump_h[index] >
                                                                    10) &&
                                                                (pump_m[index] <
                                                                    10))
                                                            ? pump_h[index]
                                                                    .toString() +
                                                                ":" +
                                                                "0" +
                                                                pump_m[index]
                                                                    .toString()
                                                            : pump_h[index]
                                                                    .toString() +
                                                                ":" +
                                                                pump_m[index]
                                                                    .toString(),
                                            fontSize: 16,
                                            color: index == pump_select
                                                ? LightColor.background
                                                : LightColor.titleTextColor,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    ftaddcheck = true;
                                  });
                                  await addfloattime(
                                    context,
                                    id: id,
                                    pump_h: pump_h,
                                    pump_i: pump_select,
                                    pump_m: pump_m,
                                  );
                                },
                                child: Container(
                                  //padding: EdgeInsets.all(10),
                                  height: 50,
                                  width: 80,
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: ftaddcheck
                                            ? LightColor.orange
                                            : LightColor.iconColor,
                                        style: BorderStyle.solid),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(13)),
                                    color:
                                        /*index == pump_select
                                            ? LightColor.orange
                                            : */
                                        Theme.of(context).backgroundColor,
                                  ),
                                  child: Icon(
                                    Icons.add_alarm,
                                    color:
                                        /*index == pump_select
                                            ? LightColor.background
                                            : */
                                        LightColor.titleTextColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        TitleText(
                          text: "Description",
                          fontSize: 14,
                        ),
                        SizedBox(height: 20),
                        Text(des),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _stateWidget(String text,
      {Color color = LightColor.iconColor, bool isSelected = false}) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(
            color: LightColor.iconColor,
            style: !isSelected ? BorderStyle.solid : BorderStyle.none),
        borderRadius: BorderRadius.all(Radius.circular(13)),
        color:
            isSelected ? LightColor.orange : Theme.of(context).backgroundColor,
      ),
      child: TitleText(
        text: text,
        fontSize: 16,
        color: isSelected ? LightColor.background : LightColor.titleTextColor,
      ),
    ).ripple(() {}, borderRadius: BorderRadius.all(Radius.circular(13)));
  }

  Widget _availableSize() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TitleText(
          text: "Available Size",
          fontSize: 14,
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _sizeWidget("US 6"),
            _sizeWidget("US 7", isSelected: true),
            _sizeWidget("US 8"),
            _sizeWidget("US 9"),
          ],
        )
      ],
    );
  }

  Widget _sizeWidget(String text,
      {Color color = LightColor.iconColor, bool isSelected = false}) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(
            color: LightColor.iconColor,
            style: !isSelected ? BorderStyle.solid : BorderStyle.none),
        borderRadius: BorderRadius.all(Radius.circular(13)),
        color:
            isSelected ? LightColor.orange : Theme.of(context).backgroundColor,
      ),
      child: TitleText(
        text: text,
        fontSize: 16,
        color: isSelected ? LightColor.background : LightColor.titleTextColor,
      ),
    ).ripple(() {}, borderRadius: BorderRadius.all(Radius.circular(13)));
  }

  Widget _availableColor() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TitleText(
          text: "Available Size",
          fontSize: 14,
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _colorWidget(LightColor.yellowColor, isSelected: true),
            SizedBox(
              width: 30,
            ),
            _colorWidget(LightColor.lightBlue),
            SizedBox(
              width: 30,
            ),
            _colorWidget(LightColor.black),
            SizedBox(
              width: 30,
            ),
            _colorWidget(LightColor.red),
            SizedBox(
              width: 30,
            ),
            _colorWidget(LightColor.skyBlue),
          ],
        )
      ],
    );
  }

  Widget _colorWidget(Color color, {bool isSelected = false}) {
    return CircleAvatar(
      radius: 12,
      backgroundColor: color.withAlpha(150),
      child: isSelected
          ? Icon(
              Icons.check_circle,
              color: color,
              size: 18,
            )
          : CircleAvatar(radius: 7, backgroundColor: color),
    );
  }

  Widget _description({String des}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TitleText(
          text: "Description",
          fontSize: 14,
        ),
        SizedBox(height: 20),
        Text(des),
      ],
    );
  }

  FloatingActionButton _flotingButton() {
    return FloatingActionButton(
      onPressed: () {},
      backgroundColor: LightColor.orange,
      child: Icon(Icons.shopping_basket,
          color: Theme.of(context).floatingActionButtonTheme.backgroundColor),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FirebaseAnimatedList(
          defaultChild: Container(
            height: 100,
            width: 100,
            alignment: Alignment.center,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.black54),
              backgroundColor: Colors.white,
            ),
          ),
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          //padding: EdgeInsets.only(top: 140.0, bottom: 15.0),
          query: widget.dbref_query,
          itemBuilder: (BuildContext context, DataSnapshot snapshot,
              Animation<double> animation, int index) {
            //if (index == 0) print(snapshot.value);
            Map<dynamic, dynamic> data = snapshot.value;
            var pump_h = [];
            data.forEach((key, value) {
              if (key.toString() == "pump_water_h") {
                for (var values in value) {
                  pump_h.add(values);
                }
              }
            });
            var pump_m = [];
            data.forEach((key, value) {
              if (key.toString() == "pump_water_m") {
                for (var values in value) {
                  pump_m.add(values);
                }
              }
            });
            int pump_select = int.parse(data["index_pump"].toString());

            return Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xfffbfbfb),
                    Color(0xfff7f7f7),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Stack(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      SizedBox(
                        height: 60,
                      ),
                      Center(
                        child: _productImage(
                          tag: data["name"].toString(),
                          avt: data["avt"].toString(),
                        ),
                      ),
                      //Center(child: _categoryWidget()),
                    ],
                  ),
                  _detailWidget(
                    name: data["name"].toString(),
                    state: data["water_state"].toString(),
                    id: data["id"].toString(),
                    sm: data["soil_measure"].toString(),
                    wl: data["water_level"].toString(),
                    sl: data["float_time"].toString(),
                    ct: data["float_time_counter"].toString(),
                    pump_h: pump_h,
                    pump_m: pump_m,
                    pump_select: pump_select,
                    des: data["des"].toString(),
                  ),
                  //_detailWidget(name: data["name"].toString()),
                  Positioned(
                    top: 0,
                    child: Container(
                      width: AppTheme.fullWidth(context),
                      height: 60,
                      //color: Colors.red,
                      child: ClipRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  _appBar(
                    like: int.parse(data["like"].toString()),
                    id: data["id"].toString(),
                  ),
                  //_detailWidget(name: data["name"].toString()),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
