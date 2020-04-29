import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_swiper/flutter_swiper.dart';
//import 'package:recipe/cocktaildetails.dart';
import './mealDetails.dart';
import './cocktailDetails.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'recipe',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String categoryUrl = 'https://www.themealdb.com/api/json/v1/1/categories.php';
  String categoryItemsUrl = 'https://www.themealdb.com/api/json/v1/1/filter.php?c=';
  String drinksUrl = 'https://www.thecocktaildb.com/api/json/v1/1/filter.php?a=';
  List data;
  List meals;
  List cocktails;
  String mCategory = 'Beef';
  bool mealsLoad = true;
  num selectedCategory = 0;
  List catType = ['Icons.fastfood','Icons.local_bar'];
  bool isFood = true;
  String drinkType = 'Alcoholic';
  final _scrollController = new ScrollController();

  Future<String> getCategories() async {

    var response = await http.get(Uri.encodeFull(categoryUrl), headers: {"Accept": "application/json"});

    setState(() {
    var extractData = json.decode(response.body);
    data = extractData["categories"];
    });

    return response.body;

  }

    Future<String> getCategoriesItems() async {

      if(isFood) {

        var response = await http.get(Uri.encodeFull(categoryItemsUrl + mCategory), headers: {"Accept": "application/json"});

        setState(() {
        var extractData = json.decode(response.body);
        meals = extractData["meals"];
        mealsLoad = false;
        print(meals);
        });
        return response.body;

      } else {
        
        var response = await http.get(Uri.encodeFull(drinksUrl + drinkType), headers: {"Accept": "application/json"});

        setState(() {
        var extractData = json.decode(response.body);
        cocktails = extractData["drinks"];
        mealsLoad = false;
        print(cocktails);
        });
        return response.body;
      }

  }

  @override
  void initState() {
    super.initState();
    getCategories();
    getCategoriesItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
/*       appBar: new AppBar(
        title: new Text('Food!e', style: new TextStyle(color: Colors.purple),),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
      ), */
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[

          Stack(
            children: <Widget>[
              Align(
                    alignment: Alignment.topRight,
                    child: Container(
                    //margin: EdgeInsets.only(left: 76),
                    height: 90.0,
                    width: 90.0,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(50)
                      )
                    ),
                    child: Center(
                      //child: Icon(Icons.local_bar, color: Colors.white,),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isFood = !isFood;
                            mealsLoad = true;
                            getCategoriesItems();
                          });
                        },
                        child: Icon(isFood == true? Icons.fastfood : Icons.local_bar, color: Colors.white),
                      )
                    ),
                  ),
                  ),
              Row(
                children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(25.0, 30.0, 0.0, 0.0),
                    child: Text(
                      'Simple way to find',
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(25.0, 1.0, 0.0, 0.0),
                    child: Text(
                      'tasty recipes',
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [


                ],
              ),
                ],
              ),
              Visibility(
                visible: isFood == true? true: false,
                child: Container(
                    height: 200,
                    padding: EdgeInsets.only(top: 100.0),
                    child: getList(),
                  ),
                ),
                Visibility(
                  visible: isFood == false? true: false,
                  child: Container(
                      height: 200,
                      padding: EdgeInsets.only(top: 100.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                              Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        mealsLoad = true;
                                        drinkType = 'Alcoholic';
                                        getCategoriesItems(); 
                                      });
                                    },
                                    child:  Container(
                                    //margin: EdgeInsets.only(left: 25),
                                    height: 100,
                                    width: 180,
                                    decoration: BoxDecoration(
                                      color: Colors.transparent
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Alcoholic',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: drinkType == 'Alcoholic'? Colors.orange: Colors.black,
                                          fontWeight: FontWeight.bold
                                        ),
                                      
                                      ),
                                    )
                                  )
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        mealsLoad = true;
                                        drinkType = 'Non_Alcoholic';
                                        getCategoriesItems();
                                      });
                                    },
                                    child:  Container(
                                    //margin: EdgeInsets.only(left: 200),
                                    height: 100,
                                    width: 180,
                                    decoration: BoxDecoration(
                                      color: Colors.transparent
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Non Alcoholic',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: drinkType == 'Non_Alcoholic'? Colors.orange: Colors.black,
                                          fontWeight: FontWeight.bold
                                        ),
                                      
                                      ),
                                    )
                                  )
                                  ),
                                ],
                              )
                        ],
                      ),
                    ),
                ),
                Visibility(
                  visible: mealsLoad == true? true: false,
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.only(top: 400.0),
                      child: CircularProgressIndicator(
                      backgroundColor: Colors.transparent,
                    ),
                    ),
                  )
                  ),
          Visibility(
            visible: mealsLoad == false? true: false,
            child: Container(
            height: 400,
            margin: EdgeInsets.only(top: 250.0),
            child: swiperkjj(),
          ) 
          ),
            ],
          ),

        ],
      ) 
    );
  }

  Widget getList() {
    return ListView.builder(
      itemCount: data == null? 0: data.length,
      scrollDirection: Axis.horizontal,
      controller: _scrollController,
      itemBuilder: (BuildContext context, i) {
        return Column(
          children: <Widget>[
            SizedBox(width: 115),
            Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50)
            ),
            child: GestureDetector(
              child: Image.network(data[i]["strCategoryThumb"]),
              onTap: () {
                setState(() {
                  mealsLoad = true;
                  selectedCategory = i;
                  //_scrollController.animateTo(i * 1.0, duration: new Duration(seconds: 2), curve: Curves.ease);
                });
                mCategory = data[i]["strCategory"];
                getCategoriesItems();
              },
            )
            ),
            SizedBox(height: 1),
            Container(
              child: Center(
                child: Text(data[i]["strCategory"], style: TextStyle(fontWeight: FontWeight.bold, color: i == selectedCategory? Colors.orange : Colors.black),
              ),
            ),
            )
          ],
        );
      },
    );
  }

  Widget swiperkjj() {
    return new Swiper(
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: <Widget>[
            Stack(
              overflow: Overflow.visible,
              children: <Widget>[
                Hero(
                  tag: isFood == true? meals[index]["strMeal"]: cocktails[index]["strDrink"],
                  child: Container(
                    height: 300,
                    width: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.grey,
                      image: new DecorationImage(
                        image: NetworkImage(isFood == true? meals[index]["strMealThumb"]:  cocktails[index]["strDrinkThumb"]),
                        fit: BoxFit.fill
                      )
                    ),
                  ),
                  ),
                Positioned(
                  height: 80.0,
                  top: 275.0,
                  child: Container(
                    height: 100.0,
                    width: 300.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                      color: Colors.orange,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 1.0,
                          color: Colors.black12,
                          spreadRadius: 2.0  
                        )
                      ]
                    ),
                    child: Container(
                      padding: EdgeInsets.all(7.0),
                      child: 
                          Column(
                            children: <Widget>[
                            Container(
                              child: Text(isFood == true? meals[index]["strMeal"]: cocktails[index]["strDrink"],
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                            ),),
                            )
                            ],
                          )
                    ),
                  ),
                ),
              ],
            )
          ],
        );
      },
      itemCount: meals == null? 0: meals.length,
      itemWidth: 300.0,
      itemHeight: 400.0,
      layout: SwiperLayout.TINDER,
      onTap: (int index) {
        if(isFood) {
          Navigator.push(
            context, 
            new MaterialPageRoute(
            builder: (BuildContext context) => 
            MealDetails(data: meals[index])
          ));
        } else {
          Navigator.push(
            context, 
            new MaterialPageRoute(
            builder: (BuildContext context) => 
            CocktailDetails(data: cocktails[index])
          ));
        }
      },
    );
  }

  Widget sliderImg(i) {
    return Image.network(
      meals[i]["strMealThumb"],
      fit: BoxFit.fill,
    );
  }

}

/* class MealDetails extends StatelessWidget {
  MealDetails(this.data);
  final data;

  @override
  Widget build(BuildContext context) => new Scaffold(
    appBar: new AppBar(
      title: new Text('data'),
    ),
    body: Container(
      height: 25.0,
      width: 25.0,
      child: Hero(
        tag: 'mealsId',
        child: Image.network(data[])
        ),
    ),
  );
} */
