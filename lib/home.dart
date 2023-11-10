import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:food_recipie/model.dart';
import 'package:http/http.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<RecipieModel> recipeList=<RecipieModel>[];
  TextEditingController searchController = new TextEditingController();

  getRecipie(String query) async{
    String url="https://api.edamam.com/search?q=$query&app_id=38fb29b1&app_key=8ca6d4935583df3405fe601d9eb114e1&from=0&to=3&calories=591-722&health=alcohol-free";
    Response response=await get(Uri.parse(url));
    Map data=jsonDecode(response.body);
    log(data.toString());

    data["hits"].forEach((element){
      RecipieModel recipieModel= new RecipieModel();
      recipieModel=RecipieModel.fromMap(element["recipe"])
    })
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRecipie("Ladoo");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    Color(0xff213A50),
                    Color(0xff071938)
                  ]
              ),
            ),
          ),
          Column(
            children: [


              //Search Bar
              SafeArea(
                child: Container(
                  //Search Wala Container

                  padding: EdgeInsets.symmetric(horizontal: 8),
                  margin: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24)),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if((searchController.text).replaceAll(" ", "") == "")
                          {
                            print("Blank search");
                          }else{
                            getRecipie(searchController.text);
                          }

                        },
                        child: Container(
                          child: Icon(
                            Icons.search,
                            color: Colors.blueAccent,
                          ),
                          margin: EdgeInsets.fromLTRB(3, 0, 7, 0),
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          controller: searchController,
                          decoration: InputDecoration(
                              border: InputBorder.none, hintText: "Let's Cook Something!"),
                        ),
                      )
                    ],
                  ),
                ),
              ),

              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("WHAT DO YOU WANT TO COOK TODAY?", style: TextStyle(fontSize: 33, color: Colors.white),),
                    SizedBox(height: 10,),
                    Text("Let's Cook Something New!", style: TextStyle(fontSize: 20,color: Colors.white),)
                  ],
                ),
              )


            ],
          )
        ],
      ),
    );
  }
}