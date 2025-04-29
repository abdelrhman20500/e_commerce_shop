import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../data/models/category_model.dart';
import '../cubit/layout_cubit.dart';

class CategoryTab extends StatelessWidget {
  const CategoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    List<CategoryModel> categoriesData = BlocProvider.of<LayoutCubit>(context).categories;
    return Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 12),
          child: GridView.builder(
              itemCount: categoriesData.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 15
              ),
              itemBuilder: (context,index){
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 4),
                  child: Column(
                    children:
                    [
                      Expanded(
                        child: Image.network(categoriesData[index].url!,fit: BoxFit.fill,),
                      ),
                      const SizedBox(height: 10,),
                      Text(categoriesData[index].title!)
                    ],
                  ),
                );
              }
          ),
        )
    );
  }
}