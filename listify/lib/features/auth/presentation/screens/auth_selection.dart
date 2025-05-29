import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'sign_in_selection_screen.dart';
import 'sign_up_selection_screen.dart';

class AuthSelection extends StatefulWidget {
  const AuthSelection({super.key});

  @override
  State<AuthSelection> createState() => _AuthSelectionState();
}

class _AuthSelectionState extends State<AuthSelection> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  void dispose() {
    // Reset orientation when leaving this screen
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage("assets/images/welcomeImg.jpg"),
        fit: BoxFit.cover,
      )),
      child: CustomScrollView(slivers: [
        SliverFillRemaining(
          // This will fill the remaining space and center the content
          hasScrollBody: false,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ClipPath(
                clipper: EnvelopeClipper(),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                  child: Container(
                    width: double.infinity,
                    height: 204,
                    decoration: BoxDecoration(
                      color: Color(0x4D0A0A0A),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(
                              0, 0, 0, 0.25), // Shadow color with opacity
                          blurRadius: 4, // The spread of the shadow
                          offset: Offset(0, 4), // Shadow position (x, y)
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 20, 15, 15),
                          child: Text(
                            "Welcome to",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20,
                                fontFamily: "InknutAntiqua",
                                color: Colors.white),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 5, 15, 15),
                          child: Text(
                            "My Shopping List",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 36,
                                fontFamily: "InknutAntiqua",
                                color: Colors.white),
                          ),
                        )
                      ],
                    ), // Transparent to blend with blur
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: 279,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(0, 0, 0, 0.4),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Container(
                        constraints: BoxConstraints(minWidth: 380),
                        height: 60,
                        child: MaterialButton(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled:
                                  true, // Allows the modal to take full height if needed
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(25.0)),
                              ),
                              builder: (context) =>
                                  const SignInSelectionScreen(),
                            );
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)),
                          color: Colors.white,
                          child: Text(
                            "Sign In",
                            style:
                                TextStyle(fontSize: 22, fontFamily: "Pacifico"),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Container(
                        constraints: BoxConstraints(minWidth: 380),
                        height: 60,
                        child: MaterialButton(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(25.0)),
                              ),
                              builder: (context) =>
                                  const SignUpSelectionScreen(),
                            );
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                              side: BorderSide(color: Colors.white, width: 3)),
                          color: Colors.transparent,
                          child: Text(
                            "Sign up",
                            style: TextStyle(
                                fontSize: 22,
                                fontFamily: "Pacifico",
                                color: Colors.white),
                          ),
                        ),
                      ),
                    )
                  ],
                ), // Transparent to blend with blur
              ),
            ],
          ),
        ),
      ]),
    ));
  }
}

class EnvelopeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height - 20);
    path.lineTo(size.width / 2, size.height); // Peak at center
    path.lineTo(0, size.height - 20);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
