import 'package:flutter/material.dart';

import 'authentication/auth.dart';

Widget foodCard(
    BaseAuth auth, String img, String name, int price, bool added) {
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
              name,
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
                  child: added
                      ? IconButton(
                          onPressed: () {
                            auth.deleteUserFav(name);
                          },
                          icon: Icon(
                            Icons.favorite,
                            color: Colors.red,
                          ))
                      : IconButton(
                          onPressed: () {
                            auth.addUserFav(name,'i',3);
                          },
                          icon: Icon(
                            Icons.favorite_outline_rounded,
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
