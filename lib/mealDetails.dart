import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';


class MealDetails extends StatefulWidget {
  final data;
  MealDetails({this.data});
  @override
  _MealDetailsState createState() => _MealDetailsState(data: data);
}

class _MealDetailsState extends State<MealDetails> {
_MealDetailsState({this.data});
final data;
//String mealId = data["idMeal"];

  String mealDetailsUrl = 'https://www.themealdb.com/api/json/v1/1/lookup.php?i=';
  List meal;
  List ingrediants = [];
  List strMeasure = [];
  List ingrediantsImage = [];
  bool mealsLoad = true;
  Future<String> getMealDetails() async {

    var response = await http.get(Uri.encodeFull(mealDetailsUrl + data["idMeal"]), headers: {"Accept": "application/json"});
    
    setState(() {
    var extractData = json.decode(response.body);
    meal = extractData["meals"];
    print(meal);
    mealsLoad = false;
    filterIngMsr();
    });

    return response.body;

  }

   filterIngMsr() {
    for(int i = 1;i <= 20;i++ ){
      if(meal[0]["strIngredient"+ i.toString()] != '' && meal[0]["strIngredient"+ i.toString()] != null ) {
        ingrediants.add(meal[0]["strIngredient"+ i.toString()]);
        strMeasure.add(meal[0]["strMeasure"+ i.toString()]);
        ingrediantsImage.add('https://www.themealdb.com/images/ingredients/' + meal[0]["strIngredient"+ i.toString()] +'.png');
        print("strIngredient"+ i.toString()+meal[0]["strIngredient"+ i.toString()]);
      }
    }
  } 
  
  @override
  void initState() {
    super.initState();
    getMealDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 360.0,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(tag: data["strMeal"], child: Image.network(data["strMealThumb"])),
              title: Text(data["strMeal"],
              style: TextStyle(
                backgroundColor: Colors.orange,
                color: Colors.white,
                fontWeight: FontWeight.bold
              ),
              ),
              collapseMode: CollapseMode.parallax
            ),
            backgroundColor: Colors.orange,
            pinned: true,
          ),
          Visibility(
            visible: meal == null && ingrediants == null && strMeasure == null? false: true,
            child: SliverToBoxAdapter(
            child: Stack(
            children: <Widget>[
              Visibility(
                visible: mealsLoad == true? true: false,
                child: Center(
                  child: Container(
                    padding: EdgeInsets.only(top: 180.0),
                    child: CircularProgressIndicator(
                    backgroundColor: Colors.transparent,
                  ),
                  ),
                )
              ),
              Container(
                padding: EdgeInsets.all(20),
                child: Row(
                  children: <Widget>[
                    Stack(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(meal == null? '':meal[0]["strCategory"],style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                            Text(meal == null? '':meal[0]["strArea"],style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        SizedBox(width: 225),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(left: 270),
                            height: 85,
                            width: 85,
                            child: IconButton(
                              icon: Image.network('https://images.vexels.com/media/users/3/137425/isolated/preview/f2ea1ded4d037633f687ee389a571086-youtube-icon-logo-by-vexels.png'), 
                              onPressed: () {
                                _launchURL(meal[0]["strYoutube"]);
                              }),
                          )
                          ],
                        )
                      ],
                    ),
                  ],
                ) 
              ),
              Container(
                padding: EdgeInsets.only(left: 20.0, bottom: 0.0,right: 20.0,top: 125.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(meal == null? '':'Ingredients',style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
                  ],
                ),
              ),
              Container(
                height: 300,
                padding: EdgeInsets.only(top: 170.0),
                child: getList(),
              ),
              Container(
                padding: EdgeInsets.only(left: 20.0, bottom: 0.0,right: 20.0,top: 320.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(meal == null? '':'Instructions',style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 20.0, bottom: 25.0,right: 20.0,top: 370.0),
                child: Text(meal == null? '':meal[0]["strInstructions"],
                style: TextStyle(fontSize: 20.0),),
              )
            ],
          ),
          )
          ),
/*           Stack(
            children: <Widget>[
              Container(
                child: Text('meal[0]["strInstructions"]'),
              )
            ],
          ) */
        ],
      ),
    );
  }

    Widget getList() {
    return ListView.builder(
      itemCount: ingrediants.length,
      scrollDirection: Axis.horizontal,
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
            child: Image.network(ingrediantsImage[i])
            ),
            SizedBox(height: 1),
            Container(
              child: Column(
                children: <Widget>[
                 Text(meal == null? '':ingrediants[i], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),),
                Text(meal == null? '':'(' + strMeasure[i] + ')', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),),                                  
                ],

            ),
            )
          ],
        );
      },
    );
  }

_launchURL(url) async {
  print(url);
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

}