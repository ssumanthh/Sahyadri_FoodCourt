import 'package:flutter/material.dart';

import 'authentication/auth.dart';

Widget foodCard(BaseAuth auth, String img, String title, String price) {
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
              height: 100.0,
            ),
            SizedBox(
              height: 8.0,
            ),
            Flexible(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
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
                      auth.addUserFav(title,img,price).then((emailid){
                        print("email:$emailid");
                      });
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
