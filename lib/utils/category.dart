import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:vivaviseu/config/router.dart';
import 'package:vivaviseu/utils/responsive.dart';


/*class GroupButtons{
  int? selectedCategory = 999;

  GroupButtons();

  setSelected(int selectedCat){
    this.selectedCategory = selectedCat;
  }

  getSelected(){
    return this.selectedCategory;
  }

  removeSelected(){
    this.selectedCategory = 999;
  }

  bool isSelected(int num){
    return num == this.selectedCategory;
  }

}*/

class GroupButtons{
  int? selectedCategory = 999;

  GroupButtons();

  setSelected(int selectedCat){
    if(this.selectedCategory == selectedCat){
      removeSelected();
      return;
    }else{
      this.selectedCategory = selectedCat;
      return;
    }
  }

  getSelected(){
    return this.selectedCategory;
  }

  removeSelected(){
    this.selectedCategory = 999;
  }

  bool isSelected(int num){
    return num == this.selectedCategory;
  }
}



class CategoryTab extends StatefulWidget {
  final String categoryname;
  final int? id;
  final bool? preselected;
  final Function(int) selected;
  final GroupButtons buttons;
  const CategoryTab({
    Key? key,
    required this.categoryname,
    this.id,
    this.preselected,
    required this.selected, required this.buttons,
  }) : super(key: key);
  @override
  _CategoryTabState createState() => _CategoryTabState();
}

class _CategoryTabState extends State<CategoryTab> {
  bool selected = false;

  @override
  void initState() {
    if(widget.preselected != null){
      if(widget.preselected != selected)
      selected = widget.preselected!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32 * SizeConfig.widthMultiplier!,
      height: 4 * SizeConfig.heightMultiplier!,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        child: TextButton(
          child: Text('${widget.categoryname}',
              style: Theme.of(context)
                  .textTheme
                  .headline4!
                  .copyWith(fontSize: SizeConfig.textMultiplier! * 1.5)),
          style: ButtonStyle(
              backgroundColor: widget.buttons.isSelected(widget.id!)
                  ? MaterialStateProperty.all<Color>(
                      Color.fromRGBO(233, 168, 3, 1.0))
                  : MaterialStateProperty.all<Color>(
                      Color.fromARGB(255, 47, 59, 76)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(2.1 * SizeConfig.heightMultiplier!),
              ))),
          onPressed: () {
            setState(() {
              /*if(widget.buttons.getSelected() == widget.id){
                widget.buttons.removeSelected();
              }*/
              widget.buttons.setSelected(widget.id!);
              if(widget.buttons.isSelected(widget.id!)){
                print('Selected Category id: ${widget.id}');
                widget.selected(widget.buttons.getSelected());
                return;
              }else{
                widget.selected(widget.buttons.getSelected());
                return;
              }
            });
          },
        ),
      ),
    );
  }
}

class CategoryTabSimple extends StatefulWidget {
  final String categoryname;
  final int? id;
  final bool? preselected;
  final Function(int)? teste1;
  const CategoryTabSimple({
    Key? key,
    required this.categoryname,
    this.teste1,
    this.id,
    this.preselected,
  }) : super(key: key);
  @override
  _CategoryTabSimple createState() => _CategoryTabSimple();
}

class _CategoryTabSimple extends State<CategoryTabSimple> {
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32 * SizeConfig.widthMultiplier!,
      height: 4 * SizeConfig.heightMultiplier!,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        child: TextButton(
          child: Text('${widget.categoryname}',
              style: Theme.of(context)
                  .textTheme
                  .headline4!
                  .copyWith(fontSize: SizeConfig.textMultiplier! * 1.5)),
          style: ButtonStyle(
              backgroundColor: selected == true
                  ? MaterialStateProperty.all<Color>(
                      Color.fromRGBO(233, 168, 3, 1.0))
                  : MaterialStateProperty.all<Color>(
                      Color.fromARGB(255, 47, 59, 76)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(2.1 * SizeConfig.heightMultiplier!),
              ))),
          onPressed: () {
            print('Selected Category: ${widget.id} e selected = $selected');
                       Router_.router.navigateTo(context, '/listagemgeral?categoryid=${widget.id}');
          },
        ),
      ),
    );
  }
}


class CategoryTabSimpleNoNetwork extends StatefulWidget {
  const CategoryTabSimpleNoNetwork({
    Key? key,
  }) : super(key: key);
  @override
  _CategoryTabSimpleNoNetwork createState() => _CategoryTabSimpleNoNetwork();
}

class _CategoryTabSimpleNoNetwork extends State<CategoryTabSimpleNoNetwork> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32 * SizeConfig.widthMultiplier!,
      height: 4 * SizeConfig.heightMultiplier!,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        child: TextButton(
          child: Text('Arte',
              style: Theme.of(context)
                  .textTheme
                  .headline4!
                  .copyWith(fontSize: SizeConfig.textMultiplier! * 1.5, color: Color.fromRGBO(47, 59, 76,1))),
          style: ButtonStyle(
              backgroundColor:MaterialStateProperty.all<Color>(
                      Color.fromARGB(255, 47, 59, 76)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(2.1 * SizeConfig.heightMultiplier!),
              ))),
          onPressed: () {
          },
        ),
      ),
    );
  }
}



class CategoryTab2 extends StatefulWidget {
  final String categoryname;
  final bool? selected;
  const CategoryTab2({
    Key? key,
    required this.categoryname,
    this.selected,
  }) : super(key: key);
  @override
  _CategoryTab2State createState() => _CategoryTab2State();
}

class _CategoryTab2State extends State<CategoryTab2> {
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        width: 90,
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(100)),
          child: TextButton(
            onPressed: () {
              setState(() {
                selected = !selected;
                Router_.router.navigateTo(context,
                    '/allevents/category?categoryname=${widget.categoryname}');
              });
            },
            child: Text(
              '${widget.categoryname}',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.normal),
            ),
            style: ButtonStyle(
                backgroundColor: selected == true
                    ? MaterialStateProperty.all<Color>(
                        Color.fromRGBO(233, 168, 3, 1.0))
                    : MaterialStateProperty.all<Color>(
                        Color.fromARGB(255, 47, 59, 76)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ))),
          ),
        ),
      );
    });
  }
}

class CategoryBasic extends StatelessWidget {
  const CategoryBasic({Key? key, required this.name}) : super(key: key);
  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.widthMultiplier! * 29,
      height: SizeConfig.heightMultiplier! * 4,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(100)),
        child: TextButton(
          onPressed: () {
            /*setState(() {
                  selected = !selected;
                  Router_.router.navigateTo(context, '/allevents/category?categoryname=${widget.categoryname}');
                });*/
          },
          child: Text('${name}', style: Theme.of(context).textTheme.headline4!),
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                  Color.fromRGBO(233, 168, 3, 1.0)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ))),
        ),
      ),
    );
  }
}
