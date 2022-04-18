import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:researchfin/Constants/constants.dart';

// Constants for staggered grid
const int countStaggered = 4;
const double mainAxisSpacing = 4.0;
const double crossAxisSpacing = 4.0;

class Squares extends StatefulWidget {
  const Squares({Key? key}) : super(key: key);

  @override
  State<Squares> createState() => _SquaresState();
}

class _SquaresState extends State<Squares> {
  List<String> sizes = ["2x2", "2x2"];

// Add widget in grid
  void addWidget(String newValue) {
    setState(() {
      sizes.add(newValue);
    });
  }

// Resize widget in grid
  void resizeWidget(String newValue, int index) {
    setState(() {
      sizes[index] = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: addWidgetPopupButton(),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: staggeredGridView(),
        ),
      ],
    );
  }

// Get CrossAxis Count
  int getCrossAxisCount(double width) {
    if (width < 400) {
      return 1;
    }
    if (width < 700) {
      return 2;
    }
    return 4;
  }

// Get Popup list for widget dimentions
  List<String> getPopUpList(double width) {
    if (width < 400) {
      return Constants.choicesMobile;
    }
    if (width < 700) {
      return Constants.choicesResponsive;
    }
    return Constants.choicesDesktop;
  }

  Widget staggeredGridView() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return StaggeredGrid.count(
          crossAxisCount: getCrossAxisCount(constraints.maxWidth),
          mainAxisSpacing: mainAxisSpacing,
          crossAxisSpacing: crossAxisSpacing,
          children: [
            ...sizes.asMap().entries.map((entry) {
              int index = entry.key;
              String val = entry.value;
              return StaggeredGridTile.count(
                crossAxisCellCount: int.parse(val[2]),
                mainAxisCellCount: int.parse(val[0]),
                child: Container(
                  color: Colors.grey,
                  child: Column(
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                width: MediaQuery.of(context).size.width * 0.1,
                                height:
                                    MediaQuery.of(context).size.height * 0.04,
                                color: Colors.blue,
                                child: addWidgetPopupButtonSquare(
                                    index, getPopUpList(constraints.maxWidth))),
                          ]),
                      Expanded(
                        child: Center(
                            child: Text(
                          val,
                          style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.black26),
                        )),
                      )
                    ],
                  ),
                ),
              );
            })
          ],
        );
      },
    );
  }

  Widget addWidgetPopupButton() {
    return LayoutBuilder(builder: (context, constraints) {
      List<String> popUpList = getPopUpList(constraints.maxWidth);
      return PopupMenuButton<String>(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.2,
          height: MediaQuery.of(context).size.height * 0.04,
          color: Colors.blue,
          child: const Center(
              child: FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(
              "ADD WIDGET",
              style: TextStyle(color: Colors.white),
            ),
          )),
        ),
        onSelected: (String? newValue) {
          addWidget(newValue ?? "1x1");
        },
        itemBuilder: (BuildContext context) {
          return popUpList.map((String choice) {
            return PopupMenuItem<String>(
              value: choice,
              child: Text(choice),
            );
          }).toList();
        },
      );
    });
  }

  Widget addWidgetPopupButtonSquare(int index, List<String> popUpList) {
    return PopupMenuButton<String>(
      child: Container(
        width: 100,
        height: 40,
        color: Colors.blue,
        child: const Center(
            child: FittedBox(
          fit: BoxFit.fitWidth,
          child: Text(
            "RESIZE",
            style: TextStyle(color: Colors.white),
          ),
        )),
      ),
      onSelected: (String? newValue) {
        resizeWidget(newValue ?? "1x1", index);
      },
      itemBuilder: (BuildContext context) {
        return popUpList.map((String choice) {
          return PopupMenuItem<String>(
            value: choice,
            child: Text(choice),
          );
        }).toList();
      },
    );
  }
}
