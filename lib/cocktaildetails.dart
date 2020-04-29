import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';


class CocktailDetails extends StatefulWidget {
  final data;
  CocktailDetails({this.data});
  @override
  _CocktailDetailsState createState() => _CocktailDetailsState(data: data);
}

class _CocktailDetailsState extends State<CocktailDetails> {
_CocktailDetailsState({this.data});
final data;
//String mealId = data["idMeal"];

  String drinkDetailsUrl = 'https://www.thecocktaildb.com/api/json/v1/1/lookup.php?i=';
  List drinks;
  List ingrediants = [];
  List strMeasure = [];
  List ingrediantsImage = [];
  bool mealsLoad = true;
  Future<String> getMealDetails() async {

    var response = await http.get(Uri.encodeFull(drinkDetailsUrl + data["idDrink"]), headers: {"Accept": "application/json"});
    
    setState(() {
    var extractData = json.decode(response.body);
    drinks = extractData["drinks"];
    print(drinks);
    mealsLoad = false;
    filterIngMsr();
    });

    return response.body;

  }

   filterIngMsr() {
    for(int i = 1;i <= 20;i++ ){
      if(drinks[0]["strIngredient"+ i.toString()] != '' && drinks[0]["strIngredient"+ i.toString()] != null) {
        ingrediants.add(drinks[0]["strIngredient"+ i.toString()]);
        if(drinks[0]["strMeasure"+ i.toString()] != '' && drinks[0]["strMeasure"+ i.toString()] != null ) {
          strMeasure.add(drinks[0]["strMeasure"+ i.toString()]);
          print("strMeasure"+ i.toString()+drinks[0]["strMeasure"+ i.toString()]);
          print(strMeasure.length.toString());
        }
        ingrediantsImage.add('https://www.thecocktaildb.com/images/ingredients/' + drinks[0]["strIngredient"+ i.toString()] +'.png');
        print("strIngredient"+ i.toString()+drinks[0]["strIngredient"+ i.toString()]);
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
              background: Hero(tag: data["strDrink"], child: Image.network(data["strDrinkThumb"])),
              title: Text(data["strDrink"],
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
            visible: drinks == null && ingrediants == null && strMeasure == null? false: true,
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
                            Text(drinks == null? '':drinks[0]["strAlcoholic"],style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                            Text(drinks == null? '':drinks[0]["strGlass"],style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          ],
                        ),
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
                    Text(drinks == null? '':'Ingredients',style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
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
                    Text(drinks == null? '':'Instructions',style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 20.0, bottom: 25.0,right: 20.0,top: 370.0),
                child: Text(drinks == null? '':drinks[0]["strInstructions"],
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
                 Text(drinks == null? '':ingrediants[i], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),),
                 Text(i >= strMeasure.length? '':'(' + strMeasure[i] + ')', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),),                                  
                   
                ],

            ),
            )
          ],
        );
      },
    );
  }

}