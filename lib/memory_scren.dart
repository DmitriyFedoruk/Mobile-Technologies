import 'dart:async';

import 'package:flip_card/flip_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class Memory extends StatefulWidget {
  @override
  _MemoryState createState() => _MemoryState();
}

class _MemoryState extends State<Memory> {
  List<GlobalKey<FlipCardState>> cardStateKeys = [
    GlobalKey<FlipCardState>(),
    GlobalKey<FlipCardState>(),
    GlobalKey<FlipCardState>(),
    GlobalKey<FlipCardState>(),
    GlobalKey<FlipCardState>(),
    GlobalKey<FlipCardState>(),
    GlobalKey<FlipCardState>(),
    GlobalKey<FlipCardState>(),
    GlobalKey<FlipCardState>(),
    GlobalKey<FlipCardState>(),
    GlobalKey<FlipCardState>(),
    GlobalKey<FlipCardState>(),
    GlobalKey<FlipCardState>(),
    GlobalKey<FlipCardState>(),
    GlobalKey<FlipCardState>(),
    GlobalKey<FlipCardState>(),
  ];
  int number=0;
  double counter=0;
  var listUsedIndex = [];
  bool tap = false;
  double point = 0;

  double time = 0;
  Timer timer;
  startTimer(){
    setState(() {
      timer = Timer.periodic(Duration(seconds: 1), (t) {
      time = time+1;
     });
    });
    
  }
  var image = 'assets/question.png';
      var listOfImage = [
      'assets/fox.png','assets/hippo.png',
      'assets/horse.png','assets/monkey.png',
      'assets/panda.png','assets/parrot.png',
      'assets/rabbit.png','assets/zoo.png',
      'assets/fox.png','assets/hippo.png',
      'assets/horse.png','assets/monkey.png',
      'assets/panda.png','assets/parrot.png',
      'assets/rabbit.png','assets/zoo.png'
      ];
      var listOfResult = ['assets/correct.png','question.png'];
      
      sortImage(){
        listOfImage.shuffle();
        return listOfImage;
      }

  @override
  void initState() {
    super.initState();
    sortImage();
    startTimer();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Memory",
        style: TextStyle(fontSize: 24.0)),
        centerTitle: true,
        backgroundColor: Colors.cyan,
      ),
      body: SafeArea(
            child: Column(children: [ Container(
              child: Text('$counter',
               style: Theme.of(context).textTheme.display2,),
            ),
            Expanded(child:
            GridView.builder(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,),
              itemCount: listOfImage.length,
              itemBuilder: (context,index)=>
              FlipCard(
                key: cardStateKeys[index],
                onFlip: (){
                  for(int i = 0; i<listUsedIndex.length;i++){
                    if(index==listUsedIndex[i]){
                      cardStateKeys[index]
                      .currentState
                      .toggleCard();
                    }
                  }
                  
                  if(!tap){
                    tap=true;
                    number = index;
                  }
                  else {
                    tap = false;
                    if(number != index){
                      if(listOfImage[number] != listOfImage[index])
                      {
                        cardStateKeys[number]
                        .currentState
                        .toggleCard();
                      number=index;
                      Timer(Duration(seconds: 1), () {
                         cardStateKeys[number]
                        .currentState
                        .toggleCard();
                      });
                      }
                      else {
                        if(listOfImage[number] == listOfImage[index])
                        {
                          listUsedIndex.add(number);
                          listUsedIndex.add(index);
                          setState(() {
                            counter++;
                          }); 

                          if(counter==8){
                            if(time>60){
                              point=30;
                            }else{
                              if(time>30){
                                point=100-time;
                              }
                              else{
                                double t=time/2;
                                point = 100-t; 
                              }
                            }
                            showResult();
                          }
                        }
                      }
                    }
                  }
                },
                direction: FlipDirection.HORIZONTAL,
                flipOnTouch: true,
                front:Container(
                  margin: EdgeInsets.all(5.0),
                  child: Image.asset('assets/question.png'),
                ),
                back:Container(
                  margin: EdgeInsets.all(5.0),
                  child: Image.asset(listOfImage[index]),)
              )
              //Cell(number: index, counter: counter, first: first, second: second,)
                )
    ),
    RaisedButton(
      onPressed: (){
        setState(() {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context)=>Memory()));
        });
      },
      color: Colors.cyan[300],
      child: Text('Заново',
      style: TextStyle(
        color:Colors.white
      ),)
    )])));
  }

  showResult(){
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('You won'),
        content: Text('You get $point point,\nYou spent $time second'),
        actions: [
          FlatButton(onPressed: (){
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => Memory())
            );
          }, child: Text('Начать заново',
          style: TextStyle(
            color: Colors.black
          )))
        ],
      ));
  }
}
