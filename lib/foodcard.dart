import 'package:flutter/material.dart';

import 'authentication/auth.dart';

Widget foodCard(BaseAuth auth, String img, String title, int price) {
  bool add = false;
  return Container(
    child: Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              img,
              height: 55.0,
            ),
           
             Text(
                title,
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
                    "${price} ₹",
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Expanded(
                  child: IconButton(
                    onPressed: () {
                   
                    },
                    icon: Icon(
                      Icons.favorite_border,
                      color: Colors.black,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    ),
  );
}
