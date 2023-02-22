import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtpForm extends StatelessWidget {
  const OtpForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              width: 56,
              height: 62,
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: Colors.grey,width: 2.0),
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: TextFormField(
                onSaved: (pin1) {},
                onChanged: (value) {
                  if (value.length == 1) {
                    FocusScope.of(context).nextFocus();
                  }
                },
                style: Theme.of(context).textTheme.headline6,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: InputDecoration(hintText: "0", border: InputBorder.none),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(1),
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              width: 56,
              height: 62,
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: Colors.grey,width: 2.0),
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: TextFormField(
                onSaved: (pin2) {},
                onChanged: (value) {
                  if (value.length == 1) {
                    FocusScope.of(context).nextFocus();
                  }
                },
                style: Theme.of(context).textTheme.headline6,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: InputDecoration(hintText: "0", border: InputBorder.none),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(1),
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              width: 56,
              height: 62,
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: Colors.grey,width: 2.0),
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: TextFormField(
                onSaved: (pin3) {},
                onChanged: (value) {
                  if (value.length == 1) {
                    FocusScope.of(context).nextFocus();
                  }
                },
                style: Theme.of(context).textTheme.headline6,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: InputDecoration(hintText: "0", border: InputBorder.none),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(1),
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              width: 56,
              height: 62,
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: Colors.grey,width: 2.0),
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: TextFormField(
                onSaved: (pin4) {},
                onChanged: (value) {
                  if (value.length == 1) {
                    FocusScope.of(context).nextFocus();
                  }
                },
                style: Theme.of(context).textTheme.headline6,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: InputDecoration(hintText: "0", border: InputBorder.none),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(1),
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              width: 56,
              height: 62,
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: Colors.grey,width: 2.0),
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: TextFormField(
                onSaved: (pin5) {},
                onChanged: (value) {
                  if (value.length == 1) {
                    FocusScope.of(context).nextFocus();
                  }
                },
                style: Theme.of(context).textTheme.headline6,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: InputDecoration(hintText: "0", border: InputBorder.none),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(1),
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              width: 56,
              height: 62,
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: Colors.grey,width: 2.0),
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: TextFormField(
                onSaved: (pin6) {},
                onChanged: (value) {
                  if (value.length == 1) {
                    FocusScope.of(context).nextFocus();
                  }
                },
                style: Theme.of(context).textTheme.headline6,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: InputDecoration(hintText: "0", border: InputBorder.none),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(1),
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}