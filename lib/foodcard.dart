import 'package:flutter/material.dart';
import 'package:sahyadri_food_court/widgets/food_details.dart';
import 'authentication/auth.dart';
import 'package:flutter/rendering.dart';

class Foodcard extends StatefulWidget{
  Foodcard({
    required this.auth, required this.img,required this.name, required this.price,required this.available,required this.added
  });
  final BaseAuth auth;
  final String img;
  final String name;
  final int price;
  final int available;
  final bool added;
  @override
  _FoodcardState createState()=>_FoodcardState();
}

class _FoodcardState extends State<Foodcard>{
  @override
  Widget build(BuildContext context) {
      bool fav = false;
      bool notFav = false;
  return InkWell( 
    onTap: (){
      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Food_Details(
                            auth:widget.auth, img:widget.img, name:widget.name, price:widget.price,available:widget.available, added: true,
                              ),
                        ),
                      );
    },
    child:Container(
    child: Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              widget.img,
              height: 55.0,
            ),
            Text(
              widget.name,
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "${widget.price} ₹",
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Expanded(
                  child: widget.added
                      ? IconButton(
                          onPressed: () {
                            widget.auth.deleteUserFav(widget.name);
                            notFav = true;
                          },
                          icon:!notFav? Icon(
                            Icons.favorite,
                            color: Colors.red,
                          ):Icon(
                            Icons.favorite,
                            color: Colors.black,
                          )
                          )
                      : IconButton(
                          onPressed: () {
                            widget.auth.addUserFav(widget.name,'i',3);
                          },
                          icon: Icon(
                            Icons.favorite_outline_rounded,
                            color: Colors.black,
                          ),
                        ),
                )
              ],
            ),
            widget.available>0?Text('Available....',
            style:TextStyle(color: Colors.green),):Text(' Not Available!',
            style:TextStyle(color: Colors.red),),
          ],
        ),
      ),
    ),
  ));
}
}