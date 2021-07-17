import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ItemCardHp extends StatelessWidget {
  final String name;
  final String price;
  final String stock;
  final String date;

  ItemCardHp(this.name, this.price, this.stock, this.date);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.blue)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Text(name,
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600, fontSize: 16)),
              ),
              Text(
                "Stok : $stock ",
                style: GoogleFonts.poppins(),
              ),
              Text(
                "Harga : $price ",
                style: GoogleFonts.poppins(),
              )
            ],
          ),
          Row(
            children: [
              SizedBox(
                height: 40,
                width: 60,
                child: Text("Tanggal : $date"),
              ),
            ],
          )
        ],
      ),
    );
  }
}