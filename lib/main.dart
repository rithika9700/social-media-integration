import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'dart:convert' as JSON;

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> {
  bool _isLoggedInn = false;



  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  _login() async{
    try{
      await _googleSignIn.signIn();
      setState(() {
        _isLoggedInn = true;
      });
    } catch (err){
      print(err);
    }
  }

  _logout(){
    _googleSignIn.signOut();
    setState(() {
      _isLoggedInn = false;
    });
  }





  bool _isLoggedIn = false;
  Map userProfile;
  final facebookLogin = FacebookLogin();

  _loginWithFB() async{


    final result = await facebookLogin.logIn(['email']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final token = result.accessToken.token;
        final graphResponse = await http.get('https://graph.facebook.com/v2.12/me?fields=name,picture,email&access_token=${token}');
        final profile = JSON.jsonDecode(graphResponse.body);
        print(profile);
        setState(() {
          userProfile = profile;
          _isLoggedIn = true;
        });
        break;

      case FacebookLoginStatus.cancelledByUser:
        setState(() => _isLoggedIn = false );
        break;
      case FacebookLoginStatus.error:
        setState(() => _isLoggedIn = false );
        break;
    }

  }

  _logoutWithFB(){
    facebookLogin.logOut();
    setState(() {
      _isLoggedIn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.pinkAccent,
          title: Text('Social Media Integration',style: TextStyle(fontSize: 20,fontFamily: 'NerkoOne'),),


        ),
        body:



        Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors:[
                      Colors.blueAccent,
                      Colors.pink,
                    ],

                ),


            ),





            child: Column(

             mainAxisAlignment: MainAxisAlignment.center,



              children: [
                Text('The Sparks Foundation',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.white,fontFamily: 'NerkoOne')),



                if(_isLoggedIn==false && _isLoggedInn==false)
                  Image.asset("assets/sparrk.png"),



                SizedBox(
                  height: 50,
                ),
                if(_isLoggedInn == true )

                      Center(
                        child: Column(
                             mainAxisAlignment: MainAxisAlignment.center,

                        children: [
                          Text("Google Login",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black,fontFamily: 'NerkoOne'),),
                          SizedBox(
                            height: 20,
                          ),

                           Image.network(_googleSignIn.currentUser.photoUrl, height: 200, width: 200,),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(_googleSignIn.currentUser.displayName,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.deepPurpleAccent,fontSize: 20,fontFamily: 'NerkoOne'),),
                            SizedBox(
                              height: 20,
                            ),
                        Text(_googleSignIn.currentUser.email,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.deepPurpleAccent,fontSize: 20,fontFamily: 'NerkoOne'),),




                            RaisedButton( child: Text("Logout",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 10,fontFamily: 'NerkoOne'),), onPressed: () {
                              _logout();
                            }
                            ),


    ],
                        ),
                      ),






               if(_isLoggedInn==false && _isLoggedIn==false)
                 Center(
                   child: Column(


                       children: [
                         Container(
                           height: 50,
                           child:  RaisedButton(
                             child: Text('Continue with Google',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,fontFamily: 'NerkoOne')),
                             color: Colors.orangeAccent,


                             onPressed: (){
                               _login();
                             },

                           ),
                         )




                       ],

                        ),
                 ),




                SizedBox(
                  height: 40,
                ),
                if(_isLoggedIn==true)




                     Center(
                       child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("FACEBOOK LOGIN",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black,fontFamily: 'NerkoOne'),),

                               Image.network(
                                userProfile["picture"]["data"]["url"],
                                height: 100,
                                width: 100,
                              ),





                         Text(userProfile["name"],style: TextStyle(fontWeight: FontWeight.bold,color: Colors.indigo,fontSize: 20,fontFamily: 'NerkoOne'),),
                         SizedBox(
                          height: 20,
                          ),
                          Text(userProfile["email"],style: TextStyle(fontWeight: FontWeight.bold,color: Colors.indigo,fontSize: 20,fontFamily: 'NerkoOne'),),
                          SizedBox(
                            height: 20,
                          ),
                          RaisedButton( child: Text("Logout",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 10,fontFamily: 'NerkoOne'),), onPressed: (){
                            _logoutWithFB();
                          },)

                        ],
                    ),
                     ),


                if(_isLoggedIn == false && _isLoggedInn == false)

                  Center(
                    child: Column(

                       mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 50,
                            child: (

                              RaisedButton(
                                child:Text('Continue with Facebook',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,fontFamily: 'NerkoOne')),
                                color: Colors.blue,

                                onPressed: () {
                                  _loginWithFB();
                                },

                              )
                            ),
    ),
                            ],


    ),


                    ),
    ],






            ),








        ),


      ),


    );

  }
}



