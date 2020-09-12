import 'package:Selfsahaf/controller/admin_service.dart';
import 'package:Selfsahaf/controller/cart_service.dart';
import 'package:Selfsahaf/controller/mail_service.dart';
import 'package:Selfsahaf/controller/category_controller.dart';
import 'package:Selfsahaf/controller/order_service.dart';
import 'package:Selfsahaf/controller/search_service.dart';
import 'package:Selfsahaf/controller/shipping_company_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:Selfsahaf/controller/product_services.dart';
import 'package:Selfsahaf/views/registration/login.dart';
import 'package:Selfsahaf/controller/user_controller.dart';
import 'controller/rating_controller.dart';
import 'package:Selfsahaf/controller/book_controller.dart';


void setupServiseLocator() {
  GetIt.I.registerLazySingleton(() => BookService());
  GetIt.I.registerLazySingleton(() => ProductService());
  GetIt.I.registerLazySingleton(() => AuthService());
  GetIt.I.registerLazySingleton(() => CartService());
  GetIt.I.registerLazySingleton(() => ShippingCompanyService());
  GetIt.I.registerLazySingleton(() => OrderService());
  GetIt.I.registerLazySingleton(() => SearchService());
  GetIt.I.registerLazySingleton(() => RatingService());
  GetIt.I.registerLazySingleton(() => MailService());
  GetIt.I.registerLazySingleton(() => CategoryService());
  GetIt.I.registerLazySingleton(() => AdminService());
}

void main() {
  setupServiseLocator();
  runApp(SelfSahaf());
}

class SelfSahaf extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SelfSahaf',
      theme: ThemeData(
        primaryColor: Color(0xffe65100),
        accentColor: Color(0xff833a),
        textSelectionColor: Color(0xffac1900),
        canvasColor: Color(0xffe65100),
        cardColor: Color(0xffe65100),

        // Butun uygulamadaki font ailesi
        fontFamily: 'Roboto',

        // Figmadaki sayfa tasarımlarına bakarak hangisinin kullanmanilmasi gerektigine bakman lazim kanka
        // Bunlari istedigin bir font size ile kullanmak icin copyWith metodunu kullanabilirsin, meselam:
        // Theme.of(context).textTheme.title.copyWith(fontSize: 18.0)
        textTheme: TextTheme(
          title: TextStyle(
              color: Color.fromRGBO(47, 19, 8, 1),
              fontWeight: FontWeight.w700), // Montserrat bold
          display1: TextStyle(
              color: Color.fromRGBO(47, 19, 8, 1),
              fontWeight: FontWeight.w500), // Montserrat medium
          body1: TextStyle(
              color: Color.fromRGBO(47, 19, 8, 1), fontWeight: FontWeight.w600),
          body2: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          //white body elements
        ),
      ),
      // home:MainPage(),
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
      // initialRoute: '/',
      // routes: <String, WidgetBuilder>{
      //   '/': (context) => LoginPage(),
      //   '/signup': (context) => Signup(),
      //   '/mainPage': (context) => MainPage(),
      //   '/adminMain': (context) => AdminMainPage(),
      //   '/searchPage': (context) => SearchPage(),
      //   '/notifications': (context) => NotificationsPage(),
      //   '/profilePage': (context) => ProfilePage(),
      //   '/addbooks': (context) => AddBook(),
      // },
    );
  }
}
