import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:food_recipie/Search.dart';
import 'package:food_recipie/model.dart';
import 'package:food_recipie/recipeView.dart';
import 'package:http/http.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  bool isLoading = true;
  List<RecipeModel> recipeList = <RecipeModel>[];
  TextEditingController searchController = new TextEditingController();
  List recipCatList=[{"imgUrl" : "https://images.unsplash.com/photo-1593560704563-f176a2eb61db", "heading": "Mexican"},{"imgUrl": "https://images.unsplash.com/photo-1593560704563-f176a2eb61db", "heading": "American"},{"imgUrl": "https://images.unsplash.com/photo-1593560704563-f176a2eb61db", "heading": "Chinese"},{"imgUrl": "https://images.unsplash.com/photo-1593560704563-f176a2eb61db", "heading": "Indian"}];

  getRecipes(String query) async {
    String url =
        "https://api.edamam.com/search?q=$query&app_id=ebb6041c&app_key=3c33ad913ab23b8554082bfb5fdd78b5";
    Response response = await get(Uri.parse(url));
    Map data = jsonDecode(response.body);

    data["hits"].forEach((element) {
      RecipeModel recipeModel = new RecipeModel();
      recipeModel = RecipeModel.fromMap(element["recipe"]);
      recipeList.add(recipeModel);
      setState(() {
        isLoading =false;
      });
      log(recipeList.toString());
    });

    recipeList.forEach((Recipe) {
      print(Recipe.applabel);
      print(Recipe.appcalories);
    });

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRecipes("Ladoo");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Color(0xff213A50), Color(0xff071938)]),
              ),
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  //Search Bar
                  SafeArea(
                    child: Container(
                      //Search Wala Container

                      padding: EdgeInsets.symmetric(horizontal: 8),
                      margin:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24)),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              if ((searchController.text).replaceAll(" ", "") ==
                                  "") {
                                print("Blank search");
                              } else {
                                Navigator.push(context, MaterialPageRoute(builder: (context)=> Search(searchController.text)));
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
                                  border: InputBorder.none,
                                  hintText: "Let's Cook Something!"),
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
                        Text(
                          "WHAT DO YOU WANT TO COOK TODAY?",
                          style: TextStyle(fontSize: 33, color: Colors.white),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Let's Cook Something New!",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        )
                      ],
                    ),
                  ),

                  Container(
                    child: isLoading ? CircularProgressIndicator() : ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap:
                            true, // If List View Is Inside some container or something to make it match the parent
                        itemCount: recipeList.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> RecipeView(recipeList[index].appurl)));
                            },
                            child: Card(
                              margin: EdgeInsets.all(20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 0.0,
                              child: Stack(
                                children: [
                                  ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: Image.network(
                                        recipeList[index].appimgUrl,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: 250,
                                      )),
                                  Positioned(
                                      left: 0,
                                      bottom: 0,
                                      right: 0,
                                      child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 10),
                                          decoration: BoxDecoration(
                                            color: Colors.black26,
                                          ),
                                          child: Text(recipeList[index].applabel,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20)
                                          ))),

                                    Positioned(
                                      right: 0,
                                      width: 80,
                                      height: 40,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(10),
                                            bottomLeft: Radius.circular(10),
                                          )
                                        ),
                                          child: Center(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.local_fire_department,size: 15),
                                                  Text(recipeList[index].appcalories.toString().substring(0,6)),
                                                ]
                                            ),
                                          )),
                                    )
                                ],
                              ),
                            ),
                          );
                        })),

                 Container(
                   height: 100,
                   child: ListView.builder(
                       itemCount: recipCatList.length,
                       shrinkWrap: true,
                       scrollDirection: Axis.horizontal,
                       itemBuilder: (context,index){

                         return Container(
                           child: InkWell(
                             onTap: () {
                               Navigator.push(context, MaterialPageRoute(builder: (context)=> Search(recipCatList[index]["heading"])));
                             } ,
                             child: Card(
                               margin: EdgeInsets.all(20),
                               shape: RoundedRectangleBorder(
                                 borderRadius: BorderRadius.circular(18),
                               ),
                               elevation: 0.0,
                               child: Stack(
                                 children: [
                                   ClipRRect(
                                     borderRadius: BorderRadius.circular(18.0),
                                     child: Image.network(
                                         recipCatList[index]["imgUrl"],
                                         fit: BoxFit.cover,
                                          width: 200,
                                          height: 250,
                                     ),
                                   ),
                                   Positioned(
                                     left: 0,
                                     right: 0,
                                     bottom: 0,
                                     top: 0,
                                     child: Container(
                                       padding: EdgeInsets.symmetric(
                                         vertical: 5,horizontal: 10),
                                       decoration: BoxDecoration(
                                         color: Colors.black26),
                                       child: Column(
                                         mainAxisAlignment: MainAxisAlignment.center,
                                         children: [
                                           Text(recipCatList[index]["heading"],
                                           style: TextStyle(
                                             color: Colors.white,
                                             fontSize: 28,
                                           ),
                                           )
                                         ],

                                       ),
                                     ),
                                   )
                                 ],
                               ),
                             ),
                           ),
                         );
                   }),
                 )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
