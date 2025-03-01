import 'package:flutter/material.dart';
import 'package:mad_group_project/custom_app_bar.dart';

class SignInSelection extends StatefulWidget{
  const SignInSelection({super.key});


  @override
  State<SignInSelection> createState() => _SignInSelectionState();
}

class _SignInSelectionState extends State<SignInSelection> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: "Sign In Selection",),
      body: Container(// Full screen height
        alignment: Alignment.center,
        padding: const EdgeInsets.fromLTRB(25.0,50,25,25),
        child: CustomScrollView(
                slivers: [
                    SliverFillRemaining( // This will fill the remaining space and center the content
                      hasScrollBody: false, // Ensures content does not scroll and stays centered
                      child: Column(
                        children: [
                          Center(child: Text("Sign In", style: TextStyle(fontSize: 48),)),
                          SizedBox(height: 80,),
                          Container(
                            constraints: BoxConstraints(
                              maxWidth: 380
                            ),
                              child: Align(alignment: Alignment.centerLeft, child: Text("Choose your preferred method to sign in", style: TextStyle(fontSize: 16),))),
                          SizedBox(height: 25,),
                          Container(
                            constraints: BoxConstraints(
                              maxWidth: 380,
                              minHeight: 50,
                            ),
                            child: MaterialButton(
                              onPressed: (){},
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(color: Color(0x33000000),),
                                  borderRadius: BorderRadius.circular(15)
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image(width:35, height:35,image: AssetImage("assets/images/googleIcon.png"),),
                                  SizedBox(width: 15,),
                                  Text("Sign In with Google", style: TextStyle(fontSize: 18),)
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 15,),
                          Container(
                            constraints: BoxConstraints(
                              maxWidth: 380,
                              minHeight: 50,
                            ),
                            child: MaterialButton(
                              onPressed: (){},
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(color: Color(0x33000000),),
                                  borderRadius: BorderRadius.circular(15)
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image(width:35, height:35,image: AssetImage("assets/images/fbIcon.png"),),
                                  SizedBox(width: 15,),
                                  Text("Sign In with Facebook", style: TextStyle(fontSize: 18),)
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 15,),
                          Container(
                            constraints: BoxConstraints(
                              maxWidth: 380,
                              minHeight: 50,
                            ),
                            child: MaterialButton(
                              onPressed: (){},
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(color: Color(0x33000000),),
                                  borderRadius: BorderRadius.circular(15)
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image(width:35, height:35,image: AssetImage("assets/images/microsoftIcon.png"),),
                                  SizedBox(width: 15,),
                                  Text("Sign In with Microsoft", style: TextStyle(fontSize: 18),)
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 30,),
                          Container(
                            constraints: BoxConstraints(
                              maxWidth: 380
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Divider(color: Colors.grey.shade300, thickness: 3,),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Text(
                                      'Or',
                                      style: TextStyle(color: Colors.grey.shade400,fontSize: 24, fontFamily: "Inter"),
                                  ),
                                ),
                                Expanded(
                                  child: Divider(color: Colors.grey.shade300, thickness: 3),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 30,),
                          Container(
                            constraints: BoxConstraints(
                              maxWidth: 380,
                              minHeight: 50,
                            ),
                            child: MaterialButton(
                              color: Colors.black,
                              onPressed: (){},
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(color: Color(0x33000000),),
                                  borderRadius: BorderRadius.circular(15)
                              ),
                              child: Center(child: Text("Using Username and Password", style: TextStyle(fontSize: 20, color: Colors.white),)),
                            ),
                          ),
                          SizedBox(height: 30,),
                        ],
                      ),
      ), ]
    )));
  }
}