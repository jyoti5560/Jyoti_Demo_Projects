import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled3/pages/multiple_language/localization_service.dart';

class MultipleLanguages extends StatefulWidget {
  const MultipleLanguages({Key? key}) : super(key: key);

  @override
  MultipleLanguagesState createState() => MultipleLanguagesState();
}

class MultipleLanguagesState extends State<MultipleLanguages> {

  String _selectedLang = LocalizationService.langs.first;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('languages'.tr),
        centerTitle: true,
        //backgroundColor: CustomColor.kOrangeColor,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('hello'.tr),
            SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.only(left: 10),
              margin: EdgeInsets.only(left: 20, right: 20),
              height: 55,  //gives the height of the dropdown button
              width: MediaQuery.of(context).size.width, //gives the width of the dropdown button
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(3)),
                  color: Color(0xFFF2F2F2)
              ),
              child: Theme(
                data: Theme.of(context).copyWith(
                    canvasColor: Colors.grey.shade100, // background color for the dropdown items
                    buttonTheme: ButtonTheme.of(context).copyWith(
                      alignedDropdown: true,  //If false (the default), then the dropdown's menu will be wider than its button.
                    )
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    icon: Icon(Icons.arrow_drop_down),
                    value: _selectedLang,
                    items: LocalizationService.langs.map((String lang) {
                      return DropdownMenuItem(value: lang, child: Text(lang));
                    }).toList(),
                    onChanged: (String ? value) {
                      // updates dropdown selected value
                      setState(() => _selectedLang = value!);
                      // gets language and changes the locale
                      LocalizationService().changeLocale(value!);
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
