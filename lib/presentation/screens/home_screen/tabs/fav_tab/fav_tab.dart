import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utils/app_color.dart';
import '../cubit/layout_cubit.dart';
import '../cubit/layout_state.dart';



class FavTab extends StatelessWidget {
  const FavTab({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<LayoutCubit>(context);
    return BlocConsumer<LayoutCubit,LayoutStates>(
      listener: (context,state)
      {

      },
      builder: (context,state){
        return  Padding(
          padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 12.5),
          child: Column(
            children:
            [
              TextFormField(
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 7.5,horizontal: 12),
                    prefixIcon: const Icon(Icons.search),
                    hintText: "Search",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50)
                    )
                ),
              ),
              const SizedBox(height: 5,),
              Expanded(
                child: ListView.builder(
                    itemCount: cubit.favorites.length,
                    itemBuilder: (context,index)
                    {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: fourthColor,
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 12.5),
                        child: Row(
                          children:
                          [
                            Image.network(
                              cubit.favorites[index].image!,
                              width: 100,
                              height: 100,
                              fit: BoxFit.fill,
                            ),
                            const SizedBox(width: 15,),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children:
                                [
                                  Text(cubit.favorites[index].name!,maxLines: 1,style: const TextStyle(fontSize: 16.5,fontWeight: FontWeight.bold,color: mainColor,overflow: TextOverflow.ellipsis),),
                                  const SizedBox(height: 7,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children:
                                    [
                                      Text("${cubit.favorites[index].price!} \$"),
                                      const SizedBox(width: 5,),
                                      Text("${cubit.favorites[index].oldPrice!} \$",style: const TextStyle(color: Colors.grey,decoration: TextDecoration.lineThrough),),
                                    ],
                                  ),
                                  const SizedBox(height: 5,),
                                  MaterialButton(
                                    onPressed: ()
                                    {
                                      // add | remove
                                      cubit.addOrRemoveFromFavorites(productID: cubit.favorites[index].id.toString());
                                    },
                                    child: const Text("Remove"),
                                    textColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25)
                                    ),
                                    color: mainColor,
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    }
                ),
              )
            ],
          ),
        );
      },
    );
  }
}