import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_test_app/test/filter_fruit_bloc.dart';
import 'package:my_test_app/test/filter_fruit_event.dart';
import 'package:my_test_app/test/filter_fruit_state.dart';

class FruitScreen extends StatelessWidget {
   FruitScreen({super.key});
  
  @override
   final List<String> fruits = [
    'Apple',
    'Banana',
    'Orange',
    'Mango',
  ];
  Widget build(BuildContext context) {
    return  BlocProvider(
      create: (context) => FilterFruitBloc(),
      
      child:BlocBuilder<FilterFruitBloc,FilterFruitState>
      (builder: (context,state)=>Scaffold(
        appBar: AppBar(),
        body: Column(
          children:[
             Wrap(
            children:fruits.map((fruit) {
              return FilterChip(
                selected: state.fruits.contains(fruit),
                label: Text(fruit),
                onSelected: (value) {
                 context.read<FilterFruitBloc>().add(
                  SelectFruitEvent(fruits: fruits)
                 );
                },
              );
            }).toList(),
            
          ),
          ElevatedButton(onPressed: (){
            context.read<FilterFruitBloc>().add(
             SelectAllFruitsEvent(fruits: fruits.map((e) => e,).toList())
            );
          }, child: Text('Select All')),
          const SizedBox(height: 10,),
          ElevatedButton(onPressed: (){
             context.read<FilterFruitBloc>().add(
             ClearAllFruitsEvent()
            );
          }, child: Text('Clear All')),
          ]
        ),
      ),
    ));
  }
}