import 'dart:collection';
import 'dart:convert';


import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:http/http.dart' as http;
import 'package:practical_task/Model/categoryModel.dart';

class TileListScreen extends StatefulWidget {
  @override
  _TileListScreenState createState() => _TileListScreenState();
}

class _TileListScreenState extends State<TileListScreen> with TickerProviderStateMixin {
  TabController _tabController;
  List<String> category = List();
  List<String> subcategory = List();
List<Widget> categoryWidget = List();
  List<Widget> _generalWidgets = List<Widget>();

  void initState() {
    subcategoryapi();
    super.initState();
  }

   Future<List<Category>> getCategories() async {
     Map<String, dynamic> request = new HashMap();

     request["CategoryId"] = "0";
     request["DeviceManufacturer"] = "Google";
     request["DeviceModel"] = "Android SDK built for x86";
     request["DeviceToken"] = "";
     request["PageIndex"] = "1";
     final http.Response response = await http.post(
         'http://esptiles.imperoserver.in/api/API/Product/DashBoard',
         headers: {
           "Accept": "application/json",
         },

         body: request
     );

     // print(response.body);

    List<Category> list = [];

    try {
      if (response.statusCode == 200) {
        CategoryResponse catresp = CategoryResponse.fromJson(jsonDecode(response.body));

        catresp.result.category.forEach((value) {
          setState(() {
            list.add(Category(name: value.name));
            category.add(value.name);

          });


          });



        // value.subCategories.forEach((element) {
        //   //   setState(() {
        //   //     // categoryWidget.add(Container(
        //   //     //   child: Text(value.name,style: TextStyle(fontSize: 8),
        //   //     //   ),
        //   //     // ));
        //   _tabController = new TabController(length: categoryWidget.length, vsync: this);
        //   //   });
        // });

      }
    } catch (e, _) {
      debugPrint(e.toString());
    }
    return list;
  }

  List<Widget> getWidgets(List<Tab> tabss , ) {
    _generalWidgets.clear();
    print(tabss.length);
    for (int i = 0; i < tabss.length; i++) {
      _generalWidgets.add(getWidget(i));
    }
    return _generalWidgets;
  }
  Widget getWidget(int widgetNumber) {
    return subcategory.length != 0 ? Container(
            child: ListView.builder(
                itemCount: subcategory.length,
                itemBuilder: (BuildContext context , int index){
              return ListTile(
                title: Text(subcategory[index]),
              );
            }),
          ) : Container(
            child:Center(
              child:Text("Loading the data")
            )
          );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Category>>(
      future: getCategories(),
      builder: (c, s) {
        if (s.hasData) {
          List<Tab> tabs = new List<Tab>();


          for (int i = 0; i < s.data.length; i++) {
            tabs.add(Tab(

              child: Text(
                s.data[i].name,
                // style: TextStyle(color: Colors.white),
              ),
            ));

          }
          _tabController = new TabController(length: tabs.length, vsync: this);

          return DefaultTabController(
            length: s.data.length,
            child: Scaffold(

              appBar: AppBar(
              centerTitle: true,

                title: Text("Tile"),
                backgroundColor: Colors.black,
                bottom: TabBar(
                  indicatorColor: Colors.transparent,
                  labelStyle:TextStyle(fontSize: 17) ,
unselectedLabelStyle: TextStyle(fontSize: 15),
                  onTap: (val){
                    print(val);
                  },
                  isScrollable: true,
                  tabs: tabs,
                ),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.filter_alt_outlined,color: Colors.white,),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.search,color: Colors.white,),
                )
              ],
              ),

              body: TabBarView(
                dragStartBehavior: DragStartBehavior.start,
                controller: _tabController,
                children:[_cat1Body(),Text("data"),Text("data"),Text("data"),Text("data"),Text("data"),Text("data"),Text("data"),Text("data"),Text("data"),Text("data")],
              ),
            ),
          );
        }
        if (s.hasError) print(s.error.toString());
        return Scaffold(
          body: Center(
              child: Text(s.hasError ? s.error.toString() : "Loading...")),
        );
      },
    );
  }



  Future subcategoryapi() async {
      Map<String, dynamic> request = new HashMap();

      request["CategoryId"] = "56";
      request["PageIndex"] = "2";
      final http.Response response = await http.post(
          'http://esptiles.imperoserver.in/api/API/Product/DashBoard',
          headers: {
            "Accept": "application/json",
          },

          body: request
      );

      print(response.body);
      // print(response.statusCode);
      // print(response.request);

      if (response.statusCode == 200) {
        CategoryResponse catresp = CategoryResponse.fromJson(
            jsonDecode(response.body));
        print(catresp);
      }
    }

  _cat1Body() {
    return  category.length != 0 ? Container(
      child: ListView.builder(
          itemCount: category.length,
          itemBuilder: (BuildContext context , int index){
        return Column(
          children: [
            ListTile(
              title: Text(category[index],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),),
            ),
                        _horizontalScrollView()

          ],
        );
      }),
    ) : Container(
      child:Center(
        child:Text("Loading the data")
      )
    );
  }

  _horizontalScrollView(){
    return Container(
      height: 110,
      child: ListView.builder(
          padding: const EdgeInsets.fromLTRB(18.0,0.0,0.0,0.0),
          scrollDirection: Axis.horizontal,
          itemCount: 10,
          shrinkWrap: true,
          itemBuilder: (BuildContext context , int index){
        return Padding(
          padding: const EdgeInsets.fromLTRB(0.0,0.0,15.0,0.0),
          child: Column(
            children: [
              Container(
                height: 80,
                  width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),

                  image: DecorationImage(
                    fit: BoxFit.cover,

                   image: NetworkImage("https://picsum.photos/200/300")
                  )
                ),
              ),
              SizedBox(height: 5,),
              Text("Data",style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.w400),)
            ],
          ),
        );
      }),
    );
  }
}
