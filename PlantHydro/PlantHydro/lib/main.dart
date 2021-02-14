import 'dart:ui';

import 'package:PlantHydro/product_detail.dart';
import 'package:PlantHydro/themes/light_color.dart';
import 'package:PlantHydro/themes/theme.dart';
import 'package:PlantHydro/wigets/product_card.dart';
import 'package:PlantHydro/wigets/product_icon.dart';
import 'package:PlantHydro/wigets/title_text.dart';
import 'package:clay_containers/widgets/clay_containers.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:PlantHydro/data/data.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    //SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
    return FutureBuilder(
      future: _initialization,
      // ignore: missing_return
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return SomethingWentWrong();
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            theme: AppTheme.lightTheme.copyWith(
              textTheme: GoogleFonts.muliTextTheme(
                Theme.of(context).textTheme,
              ),
            ),
            debugShowCheckedModeBanner: false,
            //home: MainPage(),
            home: SplashPage(),
          );
        }
        return SomethingWentDontKnow();
      },
    );
  }
}

class SplashPage extends StatefulWidget {
  SplashPage({Key key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  List<SliderModel> mySLides = new List<SliderModel>();
  int slideIndex = 0;
  PageController controller;

  Widget _buildPageIndicator(bool isCurrentPage) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2.0),
      height: isCurrentPage ? 10.0 : 6.0,
      width: isCurrentPage ? 10.0 : 6.0,
      decoration: BoxDecoration(
        color: isCurrentPage ? Colors.grey : Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mySLides = getSlides();
    controller = new PageController();
  }

  TextEditingController phone = new TextEditingController();
  TextEditingController pass = new TextEditingController();

  bool _obscureText = true;

  GlobalKey<FormState> _formKeypass = GlobalKey<FormState>();
  GlobalKey<FormState> _formKeyphone = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Future<Widget> buildPageAsync(
        {String idacc,
        String nameuser,
        String pass,
        String phone,
        String iduser}) async {
      return Future.microtask(() {
        print("IOT/plants/idacc_" + idacc);
        return MainPage(
          path: "IOT/plants/idacc_" + idacc,
          nameuser: nameuser,
          pass: pass,
          phone: phone,
          iduser: iduser,
        );
      });
    }

    int loginb = -1;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
              // height: AppTheme.fullHeight(context) - 50,
              decoration: BoxDecoration(
                //color: LightColor.lightGrey.withAlpha(20),
                gradient: LinearGradient(
                  colors: [
                    Color(0xfffbfbfb),
                    Color(0xfff7f7f7),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Scaffold(
                //backgroundColor: Colors.white,
                body: Container(
                  height: MediaQuery.of(context).size.height - 100,
                  child: PageView(
                    physics: BouncingScrollPhysics(),
                    controller: controller,
                    onPageChanged: (index) {
                      setState(() {
                        slideIndex = index;
                      });
                    },
                    children: <Widget>[
                      SlideTile(
                        imagePath: mySLides[0].getImageAssetPath(),
                        title: mySLides[0].getTitle(),
                        desc: mySLides[0].getDesc(),
                      ),
                      SlideTile(
                        imagePath: mySLides[1].getImageAssetPath(),
                        title: mySLides[1].getTitle(),
                        desc: mySLides[1].getDesc(),
                      ),
                      SlideTile(
                        imagePath: mySLides[2].getImageAssetPath(),
                        title: mySLides[2].getTitle(),
                        desc: mySLides[2].getDesc(),
                      ),
                      SingleChildScrollView(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          alignment: Alignment.center,
                          // height: AppTheme.fullHeight(context) - 50,
                          decoration: BoxDecoration(
                            //color: LightColor.lightGrey.withAlpha(20),
                            gradient: LinearGradient(
                              colors: [
                                Color(0xfffbfbfb),
                                Color(0xfff7f7f7),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                height: 100,
                              ),
                              Image.asset(
                                'assets/login.png',
                                height: 120,
                                width: 120,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Form(
                                key: _formKeyphone,
                                child: TextFormField(
                                  controller: phone,
                                  autofocus: false,
                                  validator: (value) {
                                    return value.isNotEmpty
                                        ? null
                                        : "Invalid Field";
                                  },
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25.0),
                                      borderSide: BorderSide(
                                        color: Colors.green,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25.0),
                                      borderSide: BorderSide(
                                        color: Colors.green,
                                        width: 2.0,
                                      ),
                                    ),
                                    labelText: "Phone",
                                    labelStyle: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 30.0,
                              ),
                              Form(
                                key: _formKeypass,
                                child: TextFormField(
                                  controller: pass,
                                  autofocus: false,
                                  obscureText: _obscureText,
                                  validator: (value) {
                                    return value.isNotEmpty
                                        ? null
                                        : "Invalid Field";
                                  },
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25.0),
                                      borderSide: BorderSide(
                                        color: Colors.green,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25.0),
                                      borderSide: BorderSide(
                                        color: Colors.green,
                                        width: 2.0,
                                      ),
                                    ),
                                    labelText: 'Password',
                                    labelStyle: TextStyle(color: Colors.black),
                                    suffixIcon: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _obscureText = !_obscureText;
                                        });
                                      },
                                      child: Icon(
                                        _obscureText
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        semanticLabel: _obscureText
                                            ? 'show password'
                                            : 'hide password',
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 15.0),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 16.0),
                                child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  onPressed: () {
                                    if ((_formKeypass.currentState
                                            .validate()) &&
                                        (_formKeyphone.currentState
                                            .validate())) {
                                      dbref.child("IOT/accounts").once().then(
                                        (DataSnapshot dataSnapshot) async {
                                          for (var e in dataSnapshot.value) {
                                            if ((phone.text ==
                                                    e["phone"].toString()) &&
                                                (pass.text ==
                                                    e["pass"].toString())) {
                                              await Future.delayed(
                                                const Duration(
                                                    microseconds: 500),
                                                () {
                                                  setState(() {
                                                    loginb = 1;
                                                  });
                                                },
                                              );
                                              var page = await buildPageAsync(
                                                  idacc: e["idacc"].toString(),
                                                  nameuser:
                                                      e["name"].toString(),
                                                  pass: e["pass"].toString(),
                                                  phone: e["phone"].toString(),
                                                  iduser:
                                                      e["idacc"].toString());
                                              var route = MaterialPageRoute(
                                                  builder: (_) => page);
                                              Navigator.pushReplacement(
                                                  context, route);
                                            } else {
                                              setState(() {
                                                phone.text = "";
                                                pass.text = "";
                                                loginb = 0;
                                              });
                                            }
                                          }
                                        },
                                      );
                                    }
                                  },
                                  padding: EdgeInsets.all(12),
                                  color: Colors.green.withOpacity(0.5),
                                  child: Text('Log In',
                                      style: TextStyle(color: Colors.white)),
                                ),
                              ),
                              Text(
                                loginb == 1
                                    ? "Login"
                                    : loginb == 0
                                        ? "Wrong"
                                        : "Waiting",
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              loginb == 1
                                  ? Container(
                                      height: 50,
                                      width: 50,
                                      alignment: Alignment.center,
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.black54),
                                        backgroundColor: Colors.white,
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                bottomSheet: slideIndex != 3
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Container(
                          //padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(13)),
                              color: Colors.white,
                              boxShadow: AppTheme.shadow),
                          height: 60,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                FlatButton(
                                  onPressed: () {
                                    controller.animateToPage(3,
                                        duration: Duration(milliseconds: 200),
                                        curve: Curves.linear);
                                  },
                                  splashColor: Colors.blue[50],
                                  child: Text(
                                    "SKIP",
                                    style: TextStyle(
                                        color: Color(0xFF0074E4),
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                Container(
                                  child: Row(
                                    children: [
                                      for (int i = 0; i < 4; i++)
                                        i == slideIndex
                                            ? _buildPageIndicator(true)
                                            : _buildPageIndicator(false),
                                    ],
                                  ),
                                ),
                                FlatButton(
                                  onPressed: () {
                                    controller.animateToPage(slideIndex + 1,
                                        duration: Duration(milliseconds: 200),
                                        curve: Curves.linear);
                                  },
                                  splashColor: Colors.blue[50],
                                  child: Text(
                                    slideIndex != 2 ? "NEXT" : "LOGIN",
                                    style: TextStyle(
                                        color: Color(0xFF0074E4),
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Container(
                          //padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(13)),
                              color: Colors.white,
                              boxShadow: AppTheme.shadow),
                          height: 60,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                FlatButton(
                                  onPressed: () {
                                    controller.animateToPage(0,
                                        duration: Duration(milliseconds: 200),
                                        curve: Curves.linear);
                                  },
                                  splashColor: Colors.blue[50],
                                  child: Text(
                                    "Back",
                                    style: TextStyle(
                                        color: Color(0xFF0074E4),
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                Container(
                                  child: Row(
                                    children: [
                                      for (int i = 0; i < 4; i++)
                                        i == slideIndex
                                            ? _buildPageIndicator(true)
                                            : _buildPageIndicator(false),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 90,
                                ),
                                /*FlatButton(
                                  onPressed: () async {
                                    var page = await buildPageAsync();
                                    var route =
                                        MaterialPageRoute(builder: (_) => page);
                                    Navigator.push(context, route);
                                  },
                                  splashColor: Colors.blue[50],
                                  child: Text(
                                    "",
                                    style: TextStyle(
                                        color: Color(0xFF0074E4),
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),*/
                              ],
                            ),
                          ),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SlideTile extends StatelessWidget {
  String imagePath, title, desc;

  SlideTile({this.imagePath, this.title, this.desc});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.center,
      // height: AppTheme.fullHeight(context) - 50,
      decoration: BoxDecoration(
        //color: LightColor.lightGrey.withAlpha(20),
        gradient: LinearGradient(
          colors: [
            Color(0xfffbfbfb),
            Color(0xfff7f7f7),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(imagePath),
          SizedBox(
            height: 40,
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 20,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            desc,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class SomethingWentWrong extends StatelessWidget {
  const SomethingWentWrong({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.amber,
    );
  }
}

class SomethingWentDontKnow extends StatelessWidget {
  const SomethingWentDontKnow({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
    );
  }
}

final dbref = FirebaseDatabase.instance.reference();

int selectedIndexcolonnade = 0;

String selectedStringcolonnade = "All";

Key d;

String state = "idle";

class MainPage extends StatefulWidget {
  final String path;
  final String nameuser;
  final String phone;
  final String pass;
  final String iduser;
  MainPage(
      {Key key,
      this.title,
      this.path,
      this.nameuser,
      this.pass,
      this.phone,
      this.iduser})
      : super(key: key);

  final String title;

  @override
  _MainPageState createState() => _MainPageState();
}

ScrollController s_controller = ScrollController(
  initialScrollOffset: 0.0,
  keepScrollOffset: true,
);

int pagestate = 0;

class _MainPageState extends State<MainPage> {
  bool isHomePageSelected = true;

  GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();

  Future<void> change(BuildContext context,
      {String iduser, String nameuser, String pass, String phone}) async {
    void change(setState, name, pass, phone) {
      setState(() {});
    }

    TextEditingController textn = TextEditingController();
    TextEditingController texts = TextEditingController();
    TextEditingController textp = TextEditingController();

    return await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, StateSetter setState) {
            return AlertDialog(
              title: Text("Change your information"),
              content: Form(
                key: _formKey2,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      TitleText(
                        text: "Name",
                      ),
                      TextFormField(
                        validator: (value) {
                          return value.isNotEmpty ? null : "Invalid Field";
                        },
                        keyboardType: TextInputType.name,
                        controller: textn,
                        decoration: InputDecoration(
                          hintText: "Enter new name",
                          hintStyle: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TitleText(
                        text: "phone",
                      ),
                      TextFormField(
                        validator: (value) {
                          return value.isNotEmpty ? null : "Invalid Field";
                        },
                        keyboardType: TextInputType.number,
                        controller: texts,
                        decoration: InputDecoration(
                          hintText: "Enter new phone",
                          hintStyle: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TitleText(
                        text: "Pass",
                      ),
                      TextFormField(
                        validator: (value) {
                          return value.isNotEmpty ? null : "Invalid Field";
                        },
                        keyboardType: TextInputType.number,
                        controller: textp,
                        decoration: InputDecoration(
                          hintText: "Enter new pass",
                          hintStyle: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text("Click button change to take effect"),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    if (_formKey2.currentState.validate()) {
                      print(iduser);
                      int k = 0;
                      DatabaseReference d = dbref
                          .child("IOT/accounts")
                          .orderByChild("idacc")
                          .equalTo(iduser)
                          .reference();
                      d.once().then((value) {
                        for (var e in value.value) {
                          if (e["idacc"].toString() == iduser) {
                            break;
                          } else {
                            k++;
                          }
                        }
                      });
                      print(k);
                      dbref.child("IOT/accounts").child(k.toString()).update({
                        'name': textn.text,
                        'phone': textp.text,
                        'pass': texts.text
                      });
                      //await Future.delayed(const Duration(microseconds: 500), () {});
                      Navigator.of(context).pop();
                    }
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

  Future<void> newtopic(BuildContext context, {String name}) async {
    void change(setState) {
      setState(() {});
    }

    TextEditingController textn = TextEditingController();
    TextEditingController textp = TextEditingController();

    return await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, StateSetter setState) {
            return AlertDialog(
              title: Text("Adding new topic"),
              content: Form(
                key: _formKey2,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      TitleText(
                        text: "Name of topic",
                      ),
                      TextFormField(
                        validator: (value) {
                          return value.isNotEmpty ? null : "Invalid Field";
                        },
                        keyboardType: TextInputType.name,
                        controller: textn,
                        decoration: InputDecoration(
                          hintText: "Enter name of topic",
                          hintStyle: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TitleText(
                        text: "Content",
                      ),
                      TextFormField(
                        validator: (value) {
                          return value.isNotEmpty ? null : "Invalid Field";
                        },
                        keyboardType: TextInputType.text,
                        controller: textp,
                        maxLines: 5,
                        minLines: 3,
                        decoration: InputDecoration(
                          hintText: "Enter content",
                          hintStyle: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text("Click button to take effect"),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    if (_formKey2.currentState.validate()) {
                      dbref.child("IOT/forums").child(textn.text).update({
                        'name': name,
                        'nametopic': textn.text,
                        'contenttopic': textp.text,
                      });
                      /*print(iduser);
                      int k = 0;
                      DatabaseReference d = dbref
                          .child("IOT/accounts")
                          .orderByChild("idacc")
                          .equalTo(iduser)
                          .reference();
                      d.once().then((value) {
                        for (var e in value.value) {
                          if (e["idacc"].toString() == iduser) {
                            break;
                          } else {
                            k++;
                          }
                        }
                      });
                      print(k);
                      dbref.child("IOT/accounts").child(k.toString()).update({
                        'name': textn.text,
                        'phone': textp.text,
                        
                      });*/
                      //await Future.delayed(const Duration(microseconds: 500), () {});
                      Navigator.of(context).pop();
                    }
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

  Widget _appBar() {
    return Container(
      padding: AppTheme.padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RotatedBox(
                quarterTurns: 4,
                child: //Icon(ds == true ? Icons.keyboard_arrow_up : Icons.sort),
                    _icon(
                        pagestate == 0
                            ? Icons.sort
                            : pagestate == 1
                                ? Icons.account_circle
                                : Icons.forum_sharp,
                        //Icons.sort,
                        color: Colors.black54),
              ),
              SizedBox(
                width: 10,
              ),
              Container(
                child: Text(
                  //ds == true ? "Home" : "Group",
                  pagestate == 0
                      ? "Home"
                      : pagestate == 1
                          ? "Profile"
                          : "Forum",
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          pagestate == 0
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 10),
                      child: Text(
                        //ds == true ? "Home" : "Group",
                        state == "idle"
                            ? "State"
                            : state == "pump"
                                ? "Pump water"
                                : state == "release"
                                    ? "release water"
                                    : state == "float"
                                        ? "Float water"
                                        : "State",
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          switch (state) {
                            case "idle":
                              state = "pump";
                              break;
                            case "pump":
                              state = "float";
                              break;
                            case "float":
                              state = "release";
                              break;
                            case "release":
                              state = "idle";
                              break;
                          }
                        });
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(13)),
                          color: Theme.of(context).backgroundColor,
                          /*this.isSelected
                        ? LightColor.background
                        :*/
                          border: Border.all(
                            color: /*this.isSelected ? LightColor.orange :*/
                                state == "idle"
                                    ? LightColor.grey
                                    : state == "pump"
                                        ? LightColor.orange
                                        : state == "release"
                                            ? LightColor.orange
                                            : state == "float"
                                                ? LightColor.orange
                                                : LightColor.grey,
                            width: /*this.isSelected ? 2 :*/ state == "idle"
                                ? 1.5
                                : state == "pump"
                                    ? 2
                                    : state == "release"
                                        ? 2
                                        : state == "float"
                                            ? 2
                                            : 1.5,
                          ),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: /*this.isSelected ? Color(0xfffbf2ef) :*/ Colors
                                  .white,
                              blurRadius: 10,
                              spreadRadius: 5,
                              offset: Offset(5, 5),
                            ),
                          ],
                          //color: Color(0xffc8c8c8),
                          //sboxShadow: AppTheme.shadow,
                        ),
                        child: Container(
                          //padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                          child: Image.asset(
                            state == "idle"
                                ? "assets/waterup.png"
                                : state == "pump"
                                    ? "assets/waterup.png"
                                    : state == "release"
                                        ? "assets/waterdown.png"
                                        : state == "float"
                                            ? "assets/waterfloat.png"
                                            : "assets/waterup.png",
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : pagestate == 1
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 10),
                          child: Text(
                            "Editing",
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            await change(
                              context,
                              iduser: widget.iduser,
                              nameuser: widget.nameuser,
                              pass: widget.pass,
                              phone: widget.phone,
                            );
                          },
                          child: Container(
                            height: 40,
                            width: 40,
                            padding: EdgeInsets.only(bottom: 0),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(13)),
                              color: Theme.of(context).backgroundColor,
                              border: Border.all(
                                color: LightColor.grey,
                                width: 1.5,
                              ),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: /*this.isSelected ? Color(0xfffbf2ef) :*/ Colors
                                      .white,
                                  blurRadius: 10,
                                  spreadRadius: 5,
                                  offset: Offset(5, 5),
                                ),
                              ],
                              //color: Color(0xffc8c8c8),
                              //sboxShadow: AppTheme.shadow,
                            ),
                            child: RotatedBox(
                              quarterTurns: 4,
                              child: Icon(Icons.edit),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 10),
                          child: Text(
                            "Adding new topic",
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            await newtopic(context, name: widget.nameuser);
                          },
                          child: Container(
                            height: 40,
                            width: 40,
                            padding: EdgeInsets.only(bottom: 0),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(13)),
                              color: Theme.of(context).backgroundColor,
                              border: Border.all(
                                color: LightColor.grey,
                                width: 1.5,
                              ),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: /*this.isSelected ? Color(0xfffbf2ef) :*/ Colors
                                      .white,
                                  blurRadius: 10,
                                  spreadRadius: 5,
                                  offset: Offset(5, 5),
                                ),
                              ],
                              //color: Color(0xffc8c8c8),
                              //sboxShadow: AppTheme.shadow,
                            ),
                            child: RotatedBox(
                              quarterTurns: 4,
                              child: Icon(Icons.add),
                            ),
                          ),
                        ),
                      ],
                    ),
        ],
      ),
    );
  }

  Widget _categoryWidget() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      width: AppTheme.fullWidth(context),
      height: 80,
      child: FirebaseAnimatedList(
        defaultChild: Container(
          height: 60,
          width: 60,
          alignment: Alignment.center,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.black54),
            backgroundColor: Colors.white,
          ),
        ),
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        query: dbref.child("IOT/groups"),
        itemBuilder: (context, snapshot, animation, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedIndexcolonnade = int.parse(snapshot.key);
                selectedStringcolonnade = snapshot.value.toString();
                d = Key(DateTime.now().millisecondsSinceEpoch.toString());
              });
            },
            child: ProductIcon(
              imagePath: "assets/plantss.png",
              text: snapshot.value.toString(),
              isSelected: index == selectedIndexcolonnade ? true : false,
            ),
          );
        },
      ),
    );
  }

  TextEditingController searchcontrol = new TextEditingController(text: "");

  bool searchcheck = false;

  Widget _search() {
    return Container(
      margin: AppTheme.padding,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: LightColor.lightGrey.withAlpha(100),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: TextField(
                controller: searchcontrol,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Search Products",
                    hintStyle: TextStyle(fontSize: 12),
                    contentPadding:
                        EdgeInsets.only(left: 10, right: 10, bottom: 0, top: 5),
                    prefixIcon: Icon(Icons.search, color: Colors.black54)),
              ),
            ),
          ),
          SizedBox(width: 20),
          _icons(Icons.filter_list, color: Colors.black54)
        ],
      ),
    );
  }

  Widget _icons(IconData icon, {Color color = LightColor.iconColor}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (searchcontrol.text == "") {
            d = Key(DateTime.now().millisecondsSinceEpoch.toString());
            searchcheck = false;
          } else {
            d = Key(DateTime.now().millisecondsSinceEpoch.toString());
            searchcheck = true;
          }
          print(searchcheck);
        });
      },
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

  Widget _title() {
    return Container(
        padding: EdgeInsets.only(top: 70),
        margin: AppTheme.padding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TitleText(
                  text: pagestate == 0
                      ? 'Our'
                      : pagestate == 1
                          ? 'Your'
                          : pagestate == 2
                              ? "Our"
                              : "",
                  fontSize: 27,
                  fontWeight: FontWeight.w400,
                ),
                TitleText(
                  text: pagestate == 0
                      ? 'Plants'
                      : pagestate == 1
                          ? 'Profile'
                          : pagestate == 2
                              ? "Forum"
                              : "",
                  fontSize: 27,
                  fontWeight: FontWeight.w700,
                ),
              ],
            ),
            Spacer(),
            !isHomePageSelected
                ? Icon(
                    Icons.delete_outline,
                    color: LightColor.orange,
                  )
                : SizedBox()
          ],
        ));
  }

  void onBottomIconPressed(int index) {
    if (index == 0 || index == 1) {
      setState(() {
        isHomePageSelected = true;
      });
    } else {
      setState(() {
        isHomePageSelected = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
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
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          controller: s_controller,
                          physics: BouncingScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _title(),
                              pagestate == 0
                                  ? Column(
                                      children: [
                                        _search(),
                                        _categoryWidget(),
                                        productwidget(
                                          context: context,
                                          path: widget.path,
                                          parent: this,
                                        ),
                                      ],
                                    )
                                  : pagestate == 1
                                      ? Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height -
                                              200,
                                          child: FirebaseAnimatedList(
                                            shrinkWrap: true,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            query: dbref
                                                .child("IOT/accounts")
                                                .orderByChild("idacc")
                                                .equalTo(
                                                    widget.iduser.toString()),
                                            itemBuilder: (context, snapshot,
                                                animation, index) {
                                              String nameuser = snapshot
                                                  .value["name"]
                                                  .toString();
                                              String iduser = snapshot
                                                  .value["idacc"]
                                                  .toString();
                                              String phone = snapshot
                                                  .value["phone"]
                                                  .toString();
                                              String pass = snapshot
                                                  .value["pass"]
                                                  .toString();
                                              return Column(
                                                /* crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,*/
                                                children: [
                                                  Center(
                                                    child: CircleAvatar(
                                                      radius: 50,
                                                      backgroundColor:
                                                          Colors.green.shade100,
                                                      child: Text(
                                                        nameuser == null ||
                                                                nameuser.length >=
                                                                    6
                                                            ? "USER"
                                                            : nameuser
                                                                .toUpperCase(),
                                                        style: TextStyle(
                                                            fontSize: 25),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      Container(
                                                        //margin: EdgeInsets.all(10),
                                                        child: Column(
                                                          children: [
                                                            TitleText(
                                                              text:
                                                                  "Name of user",
                                                            ),
                                                            Text(
                                                              nameuser,
                                                              style: TextStyle(
                                                                  fontSize: 30),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        //margin: EdgeInsets.all(10),
                                                        child: Column(
                                                          children: [
                                                            TitleText(
                                                              text:
                                                                  "ID of user",
                                                            ),
                                                            Text(
                                                              iduser,
                                                              style: TextStyle(
                                                                  fontSize: 30),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  Container(
                                                    //margin: EdgeInsets.all(10),
                                                    child: Column(
                                                      children: [
                                                        TitleText(
                                                          text: "Phone of user",
                                                        ),
                                                        Text(
                                                          phone,
                                                          style: TextStyle(
                                                              fontSize: 30),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  Container(
                                                    //margin: EdgeInsets.all(10),
                                                    child: Column(
                                                      children: [
                                                        TitleText(
                                                          text: "Pass of user",
                                                        ),
                                                        Text(
                                                          pass,
                                                          style: TextStyle(
                                                              fontSize: 30),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        )
                                      : Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height +
                                              200,
                                          padding: EdgeInsets.all(10),
                                          child: FirebaseAnimatedList(
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            query: dbref.child("IOT/forums"),
                                            itemBuilder: (context, snapshot,
                                                animation, index) {
                                              String name =
                                                  snapshot.value["name"];
                                              String nametopic =
                                                  snapshot.value["nametopic"];
                                              String contenttopic = snapshot
                                                  .value["contenttopic"];
                                              return Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  CircleAvatar(
                                                    radius: 25,
                                                    backgroundColor:
                                                        Colors.green.shade100,
                                                    child: Text(
                                                      name == null ||
                                                              name.length >= 6
                                                          ? "USER"
                                                          : name.toUpperCase(),
                                                      style: TextStyle(
                                                          fontSize: 10),
                                                    ),
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.all(10),
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width -
                                                            100,
                                                    margin: EdgeInsets.all(10),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  13)),
                                                      color: Theme.of(context)
                                                          .backgroundColor,
                                                      //color: Color(0xffc8c8c8),
                                                      boxShadow:
                                                          AppTheme.shadow,
                                                    ),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          name,
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        TitleText(
                                                          text: nametopic,
                                                          fontSize: 25,
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width -
                                                              100,
                                                          child: Text(
                                                            contenttopic,
                                                            style: TextStyle(
                                                              fontSize: 18,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        ),
                              SizedBox(
                                height: 75,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 0,
                    child: Container(
                      width: AppTheme.fullWidth(context),
                      height: 60,
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
                  _appBar(),
                  Padding(
                    padding: EdgeInsets.only(top: 580),
                    child: _BottomBar(
                      parent: this,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class productwidget extends StatefulWidget {
  productwidget({
    this.path,
    this.parent,
    Key key,
    @required this.context,
  }) : super(key: key);

  final BuildContext context;
  final String path;

  _MainPageState parent;

  @override
  _productwidgetState createState() => _productwidgetState();
}

class _productwidgetState extends State<productwidget> {
  Widget _single_plant({Map<dynamic, dynamic> plant, String imagestring}) {
    Future<Widget> buildPageAsync() async {
      return Future.microtask(() {
        return ProductDetailPage(
          dbref: dbref,
          dbref_query: dbref
              .child(widget.path)
              .orderByChild("name")
              .equalTo(plant["name"].toString()),
          path: widget.path,
        );
      });
    }

    //List<dynamic> pump_h = plant["pump_water_h"];
    var pump_water_h = [];
    plant.forEach((key, value) {
      if (key.toString() == "pump_water_h") {
        for (var values in value) {
          pump_water_h.add(values);
        }
      }
    });
    var pump_water_m = [];
    plant.forEach((key, value) {
      if (key.toString() == "pump_water_m") {
        for (var values in value) {
          pump_water_m.add(values);
        }
      }
    });
    int selectedindex = int.parse(plant["index_pump"].toString());

    int like = int.parse(plant["like"].toString());

    return InkWell(
      onTap: () async {
        if (state != "idle") {
          if (state != plant["water_state"].toString()) {
            dbref
                .child(widget.path + "/pr_" + plant["id"].toString())
                .update({'water_state': state});
          }
        } else {
          var page = await buildPageAsync();
          var route = MaterialPageRoute(builder: (_) => page);
          Navigator.push(context, route);
        }
      },
      onDoubleTap: () async {
        if (state != "idle") {
          var page = await buildPageAsync();
          var route = MaterialPageRoute(builder: (_) => page);
          Navigator.push(context, route);
        }
      },
      child: Container(
        width: AppTheme.fullWidth(context),
        height: 185,
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
          decoration: BoxDecoration(
            border: state == "idle"
                ? null
                : Border.all(
                    color: plant["water_state"].toString() == state
                        ? Colors.red
                        : LightColor.grey,
                    width: 1.5,
                  ),
            borderRadius:
                state == "idle" ? null : BorderRadius.all(Radius.circular(10)),
          ),
          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              LiquidLinearProgressIndicator(
                value: double.parse(plant["water_level"].toString()) == null
                    ? -0.5
                    : double.parse(plant["water_level"].toString()) == 0
                        ? -0.05
                        : double.parse(plant["water_level"].toString()) / 100,
                direction: Axis.vertical,
                backgroundColor: Colors.white,
                valueColor:
                    AlwaysStoppedAnimation(Colors.blue.withOpacity(0.2)),
                borderRadius: 12.0,
              ),
              Positioned(
                right: 10,
                top: 0,
                child: IconButton(
                  icon: Icon(
                    like == 1 ? Icons.favorite : Icons.favorite_border,
                    color: like == 1 ? LightColor.red : LightColor.iconColor,
                  ),
                  onPressed: () {
                    if (like == 1) {
                      like = 0;
                    } else {
                      like = 1;
                    }
                    dbref
                        .child(widget.path + "/pr_" + plant["id"].toString())
                        .update({'like': like});
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
                        Container(
                          height: 120,
                          width: 120,
                          child: Hero(
                              tag: plant["name"].toString(),
                              child: Image.asset(imagestring)),
                        )
                      ],
                    ),
                  ),
                  // SizedBox(height: 5),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 2),
                        width: 120,
                        child: Text(
                          plant["name"].toString(),
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 2),
                        width: 100,
                        child: Text(
                          plant["water_state"].toString()[0].toUpperCase() +
                              plant["water_state"].toString().substring(1),
                          style: TextStyle(
                            fontSize: 12.0,
                            color: Colors.black.withOpacity(0.5),
                            //fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 8),
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
                                              plant["soil_measure"].toString(),
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(13)),
                                        color:
                                            Theme.of(context).backgroundColor,
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
                                              plant["water_level"].toString(),
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(13)),
                                        color:
                                            Theme.of(context).backgroundColor,
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
                                            width: 50,
                                            alignment: Alignment.center,
                                            margin: EdgeInsets.only(
                                                right: 5, left: 2),
                                            child: Text(
                                              plant["float_time"].toString() +
                                                  " min",
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(13)),
                                        color:
                                            Theme.of(context).backgroundColor,
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
                                            width: 50,
                                            alignment: Alignment.center,
                                            margin: EdgeInsets.only(
                                                right: 5, left: 2),
                                            child: Text(
                                              plant["float_time_counter"]
                                                      .toString() +
                                                  " s",
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(13)),
                                        color:
                                            Theme.of(context).backgroundColor,
                                        border: Border.all(
                                          width: 0.2,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      child: Container(
                                          height: 20,
                                          child: Image.asset(
                                              "assets/counter.png")),
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
                            itemCount: pump_water_h.length,
                            itemBuilder: (context, index) {
                              return Container(
                                padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                                child: Container(
                                  //padding: EdgeInsets.all(5.0),
                                  width: 70.0,
                                  decoration: BoxDecoration(
                                    //color: Theme.of(context).accentColor,
                                    color: index ==
                                            int.parse(
                                                plant["index_pump"].toString())
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
                                    ((pump_water_h[index] < 10) &&
                                            (pump_water_m[index] > 10))
                                        ? "0" +
                                            pump_water_h[index].toString() +
                                            ":" +
                                            pump_water_m[index].toString()
                                        : ((pump_water_h[index] < 10) &&
                                                (pump_water_m[index] < 10))
                                            ? "0" +
                                                pump_water_h[index].toString() +
                                                ":" +
                                                "0" +
                                                pump_water_m[index].toString()
                                            : ((pump_water_h[index] > 10) &&
                                                    (pump_water_m[index] > 10))
                                                ? pump_water_h[index]
                                                        .toString() +
                                                    ":" +
                                                    pump_water_m[index]
                                                        .toString()
                                                : ((pump_water_h[index] > 10) &&
                                                        (pump_water_m[index] <
                                                            10))
                                                    ? pump_water_h[index]
                                                            .toString() +
                                                        ":" +
                                                        "0" +
                                                        pump_water_m[index]
                                                            .toString()
                                                    : pump_water_h[index]
                                                            .toString() +
                                                        ":" +
                                                        pump_water_m[index]
                                                            .toString(),
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //print(widget.searchcheck);
    return Container(
      alignment: Alignment.center,
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
        key: d,
        sort: (a, b) => (b.key.compareTo(a.key)),
        //padding: EdgeInsets.only(top: 140.0, bottom: 15.0),
        query: widget.parent.searchcheck != false
            ? dbref
                .child(widget.path)
                .orderByChild("name")
                .equalTo(widget.parent.searchcontrol.text)
            : selectedStringcolonnade == "All"
                ? dbref.child(widget.path)
                : selectedStringcolonnade == "Favorite"
                    ? dbref.child(widget.path).orderByChild("like").equalTo(1)
                    : dbref
                        .child(widget.path)
                        .orderByChild("group")
                        .equalTo(selectedStringcolonnade),
        itemBuilder: (BuildContext context, DataSnapshot snapshot,
            Animation<double> animation, int index) {
          Map<dynamic, dynamic> data = snapshot.value;
          return SlideTransition(
            position:
                animation.drive(Tween(begin: Offset(1, 0), end: Offset(0, 0))),
            child: _single_plant(
                imagestring: "assets/" + data["avt"].toString(), plant: data),
          );
        },
      ),
    );
  }
}

class _BottomBar extends StatefulWidget {
  _MainPageState parent;
  _BottomBar({Key key, this.parent}) : super(key: key);

  @override
  __BottomBarState createState() => __BottomBarState();
}

class __BottomBarState extends State<_BottomBar> {
  int selectedIndex = 0;

  void onItemTapped(int tappedItemIndex, setState) {
    widget.parent.setState(() {
      selectedIndex = tappedItemIndex;
      pagestate = tappedItemIndex;
      print(pagestate);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        //padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(13)),
            color: Colors.white,
            boxShadow: AppTheme.shadow),
        height: 60,
        /*borderRadius: 10,
        color: Colors.white,
        spread: 10,
        depth: 40,*/
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _BarItem(
                icon: Icons.home,
                title: 'Home',
                isSelected: selectedIndex == 0,
                onTap: () {
                  onItemTapped(0, setState);
                  s_controller.animateTo(
                    0,
                    duration: Duration(milliseconds: 400),
                    curve: Curves.easeIn,
                  );
                },
              ),
              _BarItem(
                icon: Icons.person,
                title: 'Profile',
                isSelected: selectedIndex == 1,
                onTap: () {
                  onItemTapped(1, setState);
                },
              ),
              _BarItem(
                icon: Icons.forum,
                title: 'Forum',
                isSelected: selectedIndex == 2,
                onTap: () {
                  onItemTapped(2, setState);
                },
              ),
              /*_BarItem(
                icon: Icons.bookmark,
                title: 'Wishlist',
                isSelected: selectedIndex == 3,
                onTap: () {
                  onItemTapped(3);
                },
              ),*/
            ],
          ),
        ),
      ),
    );
  }
}

class _BarItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isSelected;
  final Function onTap;

  const _BarItem({Key key, this.icon, this.title, this.isSelected, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(13)),
          color: isSelected ? Color(0xCC2372F0) : Colors.white,
          //boxShadow: AppTheme.shadow
        ),
        /*decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: isSelected ? Color(0xCC2372F0) : Colors.white,
        ),*/
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              icon,
              color: isSelected ? Colors.white : Color(0xffa8a09b),
            ),
            if (isSelected)
              VerticalDivider(
                color: Color(0xFF647082),
              ),
            if (isSelected)
              Flexible(
                fit: FlexFit.loose,
                child: Text(
                  title,
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
