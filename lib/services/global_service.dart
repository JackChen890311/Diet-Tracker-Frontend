import 'package:diet_tracker/utils/user.dart';

class GlobalService {
  static final GlobalService _instance = GlobalService._internal();

  // passes the instantiation to the _instance object
  factory GlobalService() => _instance;

  //initialize variables in here
  GlobalService._internal() {
    user = null;
  }

  User? user;

  //short getter for my variable
  User get getUserData => user!;

  // List<String> get userAchievement => achievement;

  //short setter for my variable
  set setUserData(User value) => user = value;

  // set userAchievement(List<String> value) => achievement = value;
}