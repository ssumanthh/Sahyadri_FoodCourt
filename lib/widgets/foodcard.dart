import 'package:flutter/material.dart';
import 'package:sahyadri_food_court/widgets/food_details.dart';
import '../authentication/auth.dart';
import 'package:flutter/rendering.dart';
import 'package:auto_size_text/auto_size_text.dart';
class Foodcard extends StatefulWidget {
  Foodcard(
      {required this.auth,
      required this.fd,
      required this.img,
      required this.name,
      required this.price,
      required this.available,
      required this.added});
  final BaseAuth auth;
  final String fd;
  final String img;
  final String name;
  final int price;
  final int available;
  final bool added;
  @override
  _FoodcardState createState() => _FoodcardState();
}

class _FoodcardState extends State<Foodcard> {
  bool click = false;
  @override
  Widget build(BuildContext context) {
   
    return InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Food_Details(
                auth: widget.auth,
                foodId: widget.fd,
                img: widget.img,
                name: widget.name,
                price: widget.price,
                available: widget.available,
                added: true,
              ),
            ),
          );
        },
       child:  Card(margin: EdgeInsets.all(2),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.network(
                    widget.img,
                    height: 55.0,
                    errorBuilder: (BuildContext context, Object exception,
                        StackTrace? stackTrace) {
                      // Appropriate logging or analytics, e.g.
                      // myAnalytics.recordError(
                      //   'An error occurred loading "https://example.does.not.exist/image.jpg"',
                      //   exception,
                      //   stackTrace,
                      // );
                      return const Opacity(
                          opacity: 0.8, child: Icon(Icons.image));
                    },
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }
                      return Opacity(opacity: 0.8, child: Icon(Icons.image));
                      // CircularProgressIndicator(
                      //     value: loadingProgress.expectedTotalBytes != null
                      //         ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                      //         : null,

                      // );
                    },
                  ),
                  Flexible(
                    child: AutoSizeText(
                      widget.name.toUpperCase(),
                     
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  // SizedBox(
                  //   height: 2.0,
                  // ),
                  Flexible(
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "${widget.price} ₹",
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Expanded(
                          child: widget.added
                              ? IconButton(
                                  onPressed: () {
                                    widget.auth.deleteUserFav(widget.name);
                                    setState(() {
                                      click = true;
                                    });
                                  },
                                  icon: !click
                                      ? Icon(
                                          Icons.favorite,
                                          color: Colors.red,
                                        )
                                      :                                       Icon(
                                    Icons.favorite_outline_rounded,
                                    color: Colors.black,
                                  )
                              )
                              : IconButton(
                                  onPressed: () {
                                    setState(() {
                                      click = true;
                                    });
                                    widget.auth.addUserFav(widget.name);
                                  },
                                  icon:click?Icon(
                                          Icons.favorite,
                                          color: Colors.red,
                                        ):
                                        Icon(
                                    Icons.favorite_outline_rounded,
                                    color: Colors.black,
                                  ),
                                ),
                        )
                      ],
                    ),
                  ),
                  widget.available > 0
                      ? Flexible(
                        child: Text(
                            'Available....',
                            style: TextStyle(color: Colors.green),
                          ),
                      )
                      : Flexible(
                        child: Text(
                            ' Not Available!',
                            style: TextStyle(color: Colors.red),
                          ),
                      ),
                ],
              ),
            
          ),
        ));
  }
}
