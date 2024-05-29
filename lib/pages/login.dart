import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:email_validator/email_validator.dart';
import 'package:diet_tracker/utils/user.dart';
import 'package:diet_tracker/services/api.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:diet_tracker/utils/style.dart';
import 'package:diet_tracker/widgets/button.dart';
import 'package:diet_tracker/widgets/dialog.dart';
import 'package:diet_tracker/utils/entry.dart';
import 'package:diet_tracker/widgets/entry_card.dart';
import 'package:diet_tracker/utils/post.dart';
import 'package:diet_tracker/widgets/post_card.dart';
import 'dart:convert';
import 'package:diet_tracker/services/global_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  late String _account;
  late String _password;
  // late String _registerEmail;
  late String _registerUsername;
  late String _registerPassword;
  late String _registerPasswordConfirmation;
  late String _registerAccount;
  late bool _isSignIn;
  late int _registerGender;
  // late String _registerUserImg;
  bool _isObscured=true;
  bool _isObscuredCheck=true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();

  final List<Map<String, dynamic>> genderList = [
    {
      'value': 1,
      'label': '男',
    },
    {
      'value': 0,
      'label': '女',
    },
  ];

  @override 
  void initState() {
    super.initState();
    _account = '';
    _password = '';
    // _registerEmail = '';
    _registerUsername = '';
    _registerAccount = '';
    _registerPassword = '';
    // _registerUserImg = '';
    _registerPasswordConfirmation = '';
    _registerGender = -1;
    _isSignIn = true;
  }

  Widget _menuItem({required String title, isActive = false, int mode = 0}) {
    // mode:0(regular) / 1(sign in) / 2(register)
    return GestureDetector(
      onTap: (){
        if(mode==1){
          setState(() {
            _isSignIn = true;
          });
        }
        else if(mode==2){
          setState(() {
            _isSignIn = false;
          });
        }
      },
      child: Padding(
        padding: EdgeInsets.only(right: MediaQuery.of(context).size.width*0.05),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Column(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isActive ? Colors.deepPurple : Colors.grey,
                ),
              ),
               SizedBox(height: MediaQuery.of(context).size.width*0.01),
              isActive
                  ? Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(30),
                      ),
                    )
                  : const SizedBox()
            ],
          ),
        ),
      ),
    );
  }

  Widget _loginWithButton({required String image, bool isActive = false}) {
      return MouseRegion(
        child: Container(
          width: MediaQuery.of(context).size.width*0.08,
          height: MediaQuery.of(context).size.width*0.06,
          decoration: isActive
              ? BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      spreadRadius: 10,
                      blurRadius: 30,
                    )
                  ],
                  borderRadius: BorderRadius.circular(15),
                )
              : BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.grey.shade400),
                ),
          child: Center(
              child: Container(
            decoration: isActive
                ? BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(35),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade400,
                        spreadRadius: 2,
                        blurRadius: 15,
                      )
                    ],
                  )
                : BoxDecoration(),
            child: Image.asset(
              '$image',
              width: 35,
            ),
          )),
        ),
      );
    }

  Future<void> submitLoginForm(context) async {
    // await ApiService().deleteUser('andy');
    // await ApiService().createFakeUser();
    if (!_formKey.currentState!.validate()) {
      print('The login form is invalid.');
      return;
    }
    print('The login form is valid!');
    _formKey.currentState?.save();  // At this time, onSave is activated to store corresponding values into variables
    
    var response1 = await ApiService().login(_account, _password);
    if(response1['statusCode']==200){
      // User
      var response2 = await ApiService().getUser(_account);
      final _global = GlobalService();
      var json = jsonDecode(response2['body']);
      var user = User.fromJson(json);
      _global.setUserData = user;
      
      // Entry
      final List<EntryBlock> entryList = [];
      Entry emptyEntry = Entry(entryID: 0, user: User(account: '', userName: '', /*email: '',*/ password: ''), foodName: '', restoName: '', price: 0, calories: 0, date: DateTime.now());
      final List<EntryBlock> entryListWithEmpty = [EntryBlock(entry: emptyEntry,)];
      final Map<String, dynamic> entryListString = await ApiService().getEntriesOfUser(user);
      List<dynamic> response = jsonDecode(entryListString['body']);
      if (response.isNotEmpty){
        for (var entry in response){
          entryList.add(
            EntryBlock(entry: Entry.fromJson(entry), imgFirst: true)//_entryList.length.isEven)
          );
          entryListWithEmpty.add(
            EntryBlock(entry: Entry.fromJson(entry), imgFirst: true)//_entryList.length.isEven)
          );
        }
      }
      _global.setEntryData = entryList;
      _global.setEntryDataWithEmpty = entryListWithEmpty;

      // Post
      int entryCnt = 0;
      int postCnt = 0;
      int likeCnt = 0;
      final List<PostBlock> postList = [];
      final Map<String, dynamic>postListString = await ApiService().getPostsAll();
      List<dynamic> response3 = jsonDecode(postListString['body']);
      

      final Map<String, dynamic>postListStringUser = await ApiService().getPostsOfUser(user);
      List<dynamic> response4 = jsonDecode(postListStringUser['body']);
      entryCnt = response.isEmpty ? 0 : response.length;
      postCnt = response4.isEmpty ? 0 : response4.length;

      if (response3.isNotEmpty){
        for (var post in response3){
          // Post postObject = Post.fromJson(post);
          postList.add(
            PostBlock(post: Post.fromJson(post))
          );
          if(Post.fromJson(post).user.account == user.account){
            likeCnt += Post.fromJson(post).likeCnt!;
          }
        }
      }
      _global.setPostData = postList;
      _global.setEntryCnt = entryCnt;
      _global.setPostCnt = postCnt;
      _global.setLikeCnt = likeCnt;

      Navigator.pushNamed(context, '/home');
    }
    else{
      await showDialog(
              context: context,
              builder:(context) {
                var content = [
                  CustomText(
                      label: '帳號 或 密碼輸入錯誤',
                      color: Theme.of(context).primaryColorDark,
                      type: 'desc'),
                  const SizedBox(height: 20),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomOutlinedButton(
                            text: 'ＯＫ',
                            borderColor: Theme.of(context).primaryColor,
                            onClick: () => {Navigator.pop(context, false)}),
                        const SizedBox(width: 20),
                      ]),
                ];
                return CustomDialog(title: '登入失敗', content: content);
              }
          );
    }
  }

  Future<void> submitRegisterForm(context) async {
    if (!_registerFormKey.currentState!.validate()) {
      print('The register form is invalid.');
      return;
    }
    print('The register form is valid!');
    _registerFormKey.currentState?.save();  // At this time, onSave is activated to store corresponding values into variables
    // if(_registerUserImg==''){
    //   if(_registerGender==0){
    //     _registerUserImg = 'assets/headshot_female.jpg';
    //   }
    //   else{
    //     _registerUserImg = 'assets/headshot_male.jpg';
    //   }
    // }
    final newUser = User(
      account: _registerAccount, 
      // email: _registerEmail, 
      password: _registerPassword, 
      userName: _registerUsername,
      gender: _registerGender,
      // userImg: _registerUserImg,
      postCnt: 0,
      entryCnt: 0,
      likeCnt: 0,
    );
    var response = await ApiService().register(newUser);
    if(response['statusCode']==201){
      await showDialog(
      context: context,
      builder:(context) {
        var content = [
          CustomText(
              label: '註冊成功，請至登入頁面登入帳號。',
              color: Theme.of(context).primaryColorDark,
              type: 'desc'),
          const SizedBox(height: 20),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomOutlinedButton(
                    text: 'ＯＫ',
                    borderColor: Theme.of(context).primaryColor,
                    onClick: () => {Navigator.pop(context, false)}),
                const SizedBox(width: 20),
              ]),
        ];
        return CustomDialog(title: '註冊成功', content: content);
      });
      Navigator.pushNamed(context, '/login');
    }
    else{ 
      String message = jsonDecode(response['body'])['message'];
      if(response['statusCode']==409){
        message = '帳號已存在，請嘗試登入，或更換不同帳號名稱。';
      }
      await showDialog(
              context: context,
              builder:(context) {
                var content = [
                  CustomText(
                      label: message,
                      color: Theme.of(context).primaryColorDark,
                      type: 'desc'),
                  const SizedBox(height: 20),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomOutlinedButton(
                            text: 'ＯＫ',
                            borderColor: Theme.of(context).primaryColor,
                            onClick: () => {Navigator.pop(context, false)}),
                        const SizedBox(width: 20),
                      ]),
                ];
                return CustomDialog(title: '註冊失敗', content: content);
              }
          );
      _isSignIn = false;
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf5f5f5),
      body: ListView(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width / 8),
        children: [
          // Menu
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _menuItem(title: 'Home'),
                    _menuItem(title: 'About us'),
                    // _menuItem(title: 'Contact us'),
                    // _menuItem(title: 'Help'),
                  ],
                ),
                Row(
                  children: [
                    _isSignIn? _menuItem(title: 'Sign In', isActive: true, mode: 1):_menuItem(title: 'Sign In', isActive: false, mode: 1),
                    _isSignIn? _menuItem(title: 'Register', isActive: false, mode: 2):_menuItem(title: 'Register', isActive: true, mode: 2),
                  ],
                ),
              ],
            ),
          ),
          // Body
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width*0.2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    Image.asset(
                      'assets/images/diet.png',
                      width: MediaQuery.of(context).size.width*0.08,
                    ),
                    const SizedBox(height: 25),
                    const Text(
                      'Sign in \nDiet Tracker',
                      style: TextStyle(
                        fontSize: 45,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "If you don't have an account",
                      style: TextStyle(
                          color: Colors.black54, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
                        children: <TextSpan>[
                          const TextSpan(text: 'You can  '),
                          TextSpan(
                              text: 'Register here!',
                              style: const TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold),
                              recognizer:
                                  TapGestureRecognizer()
                                    ..onTap = () {
                                      setState(() {
                                        _isSignIn = false;
                                      });
                                    }),
                        ],
                      ),
                    ),
                    
                  ],
                ),
              ),
              Image.asset(
                'assets/images/illustration-1.png',
                width: MediaQuery.of(context).size.width*0.2,
              ),
              _isSignIn ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.height/25),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width*0.3,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // standard sign-in
                            TextFormField(
                              decoration: InputDecoration(
                                hintText: 'Username',
                                filled: true,
                                fillColor: Colors.blueGrey[50],
                                labelStyle: const TextStyle(fontSize: 12),
                                contentPadding: const EdgeInsets.only(left: 30),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blueGrey.shade50),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blueGrey.shade50),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              validator:(value) {
                                if(value!.isEmpty){
                                  return '請輸入使用者名稱';
                                }
                                return null;
                              },
                              onSaved: (newValue) {
                                _account = newValue!.trim();
                              },
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              obscureText: _isObscured,
                              decoration: InputDecoration(
                                hintText: 'Password',
                                suffixIcon:IconButton(
                                  onPressed: () => setState(() => _isObscured = !_isObscured),
                                  icon: Icon(
                                    _isObscured
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.grey,
                                  )),
                                filled: true,
                                fillColor: Colors.blueGrey[50],
                                labelStyle: const TextStyle(fontSize: 12),
                                contentPadding: const EdgeInsets.only(left: 30),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blueGrey.shade50),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blueGrey.shade50),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              validator:(value) {
                                if(value!.isEmpty){
                                  return '請輸入密碼';
                                }
                                return null;
                              },
                              onSaved: (newValue) {
                                _password = newValue!.trim();
                              },
                            ),
                            const SizedBox(height: 40),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.deepPurple.shade100,
                                    spreadRadius: 10,
                                    blurRadius: 20,
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                onPressed: (){
                                  submitLoginForm(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.deepPurple,
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                child:const SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: Center(child: Text("Sign In"))),
                              ),
                            ),
                            const SizedBox(height: 40),
                            // other sign-in ways 
                            // Row(children: [
                            //   Expanded(
                            //     child: Divider(
                            //       color: Colors.grey[300],
                            //       height: 50,
                            //     ),
                            //   ),
                            //   const Padding(
                            //     padding: EdgeInsets.symmetric(horizontal: 20),
                            //     child: Text("Or continue with"),
                            //   ),
                            //   Expanded(
                            //     child: Divider(
                            //       color: Colors.grey[400],
                            //       height: 50,
                            //     ),
                            //   ),
                            // ]),
                            // const SizedBox(height: 40),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //   children: [
                            //     // TODO
                            //     _loginWithButton(image: 'images/google.png'),
                            //     _loginWithButton(image: 'images/github.png', isActive: true),
                            //     _loginWithButton(image: 'images/facebook.png'),
                            //   ],
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
              : Padding(
                padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height/25),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width*0.3,
                  child:Form(
                    key: _registerFormKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SelectFormField(
                          decoration: InputDecoration(
                            hintText: 'Choose a gender',
                            filled: true,
                            fillColor: Colors.blueGrey[50],
                            labelStyle: const TextStyle(fontSize: 12),
                            contentPadding: const EdgeInsets.only(left: 30),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blueGrey.shade50),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blueGrey.shade50),
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          type: SelectFormFieldType
                              .dropdown,
                          items: genderList,
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return '請選擇一個性別';
                            }
                            return null;
                          },
                          onSaved: (String? value) {
                            _registerGender = int.parse(value!);
                          },
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Enter account',
                            filled: true,
                            fillColor: Colors.blueGrey[50],
                            labelStyle: const TextStyle(fontSize: 12),
                            contentPadding: const EdgeInsets.only(left: 30),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blueGrey.shade50),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blueGrey.shade50),
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          validator:(value) {
                            if(value!.isEmpty){
                              return '請輸入帳號';
                            }
                            if (value.contains(' ')) {
                              return '請勿包含空白格';
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            _registerAccount = newValue!.trim();
                          },
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          obscureText: _isObscured,
                          decoration: InputDecoration(
                            hintText: 'Enter password',
                            suffixIcon:IconButton(
                              onPressed: () => setState(() => _isObscured = !_isObscured),
                              icon: Icon(
                                _isObscured
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.grey,
                              )),
                            filled: true,
                            fillColor: Colors.blueGrey[50],
                            labelStyle: const TextStyle(fontSize: 12),
                            contentPadding: const EdgeInsets.only(left: 30),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blueGrey.shade50),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blueGrey.shade50),
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          validator:(value) {
                            setState(() {
                              _registerPassword = value!.trim();
                            });
                            if(value!.isEmpty){
                              return '請輸入密碼';
                            }
                            if (value.contains(' ')) {
                              return '請勿包含空白格';
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            _registerPassword = newValue!.trim();
                          },
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          obscureText: _isObscuredCheck,
                          decoration: InputDecoration(
                            hintText: 'Enter password again',
                            suffixIcon:IconButton(
                              onPressed: () => setState(() => _isObscuredCheck = !_isObscuredCheck),
                              icon: Icon(
                                _isObscuredCheck
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.grey,
                              )),
                            filled: true,
                            fillColor: Colors.blueGrey[50],
                            labelStyle: const TextStyle(fontSize: 12),
                            contentPadding: const EdgeInsets.only(left: 30),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blueGrey.shade50),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blueGrey.shade50),
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          validator:(value) {
                            if (value!.isEmpty) {
                              return '請再次輸入密碼';
                            } else if (value != _registerPassword) {
                              return '密碼不一致';
                            }
                            if (value.contains(' ')) {
                              return '請勿包含空白格';
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            _registerPasswordConfirmation = newValue!.trim();
                          },
                        ),
                        const SizedBox(height: 15),
                        // TextFormField(
                        //   decoration: InputDecoration(
                        //     hintText: 'Enter email',
                        //     filled: true,
                        //     fillColor: Colors.blueGrey[50],
                        //     labelStyle: const TextStyle(fontSize: 12),
                        //     contentPadding: const EdgeInsets.only(left: 30),
                        //     enabledBorder: OutlineInputBorder(
                        //       borderSide: BorderSide(color: Colors.blueGrey.shade50),
                        //       borderRadius: BorderRadius.circular(15),
                        //     ),
                        //     focusedBorder: OutlineInputBorder(
                        //       borderSide: BorderSide(color: Colors.blueGrey.shade50),
                        //       borderRadius: BorderRadius.circular(15),
                        //     ),
                        //   ),
                        //   validator:(value) {
                        //     if(value!.isEmpty){
                        //       return '請輸入信箱';
                        //     }
                        //     if (value.isNotEmpty && !EmailValidator.validate(value)){
                        //       return '請輸入正確信箱格式';
                        //     }
                        //     if (value.contains(' ')) {
                        //       return '請勿包含空白格';
                        //     }
                        //     return null;
                        //   },
                        //   onSaved: (newValue) {
                        //     _registerEmail = newValue!.trim();
                        //   },
                        // ),
                        // const SizedBox(height: 15),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Enter username',
                            filled: true,
                            fillColor: Colors.blueGrey[50],
                            labelStyle: const TextStyle(fontSize: 12),
                            contentPadding: const EdgeInsets.only(left: 30),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blueGrey.shade50),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blueGrey.shade50),
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          validator:(value) {
                            if(value!.isEmpty){
                              return '請輸入使用者名稱';
                            }
                            if (value.contains(' ')) {
                              return '請勿包含空白格';
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            _registerUsername = newValue!.trim();
                          },
                        ),
                        const SizedBox(height: 30),
                        
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.deepPurple.shade100,
                                spreadRadius: 10,
                                blurRadius: 20,
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: (){
                              submitRegisterForm(context);
                              // submit(context);
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.deepPurple,
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child:const SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: Center(child: Text("Register"))),
                          ),
                        ),
                        
                      ])
                    ),
                  )
                ),
            ],
          )
        ],
      ),
    );
  }
}
