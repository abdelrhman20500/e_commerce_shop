
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../../data/models/product_model.dart';
import '../../../../utils/app_color.dart';
import '../cubit/layout_cubit.dart';
import '../cubit/layout_state.dart';

class HomeTab extends StatelessWidget {
  final pageController = PageController();
  HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<LayoutCubit>(context);
    return BlocConsumer<LayoutCubit,LayoutStates>(
        listener: (context,state){},
        builder:(context,state){
          return Scaffold(
              body: Padding(
                padding: const EdgeInsets.symmetric(vertical: 18.0,horizontal: 15),
                child: ListView(
                  shrinkWrap: true,
                  children:
                  [
                    cubit.banners.isEmpty ?
                    const Center(child: CupertinoActivityIndicator(),) :
                    SizedBox(
                      height: 150,
                      width: double.infinity,
                      child: PageView.builder(
                          controller: pageController,
                          physics: const BouncingScrollPhysics(),
                          itemCount: 3,
                          itemBuilder: (context,index){
                            return Image.network(cubit.banners[index].url!,fit: BoxFit.fill,);
                          }
                      ),
                    ),
                    const SizedBox(height: 15,),
                    // Todo: Smooth Page Indicator
                    Center(
                      child: SmoothPageIndicator(
                        controller: pageController,
                        count: 3,
                        axisDirection: Axis.horizontal,
                        effect: const SlideEffect(
                            spacing: 8.0,
                            radius:  25,
                            dotWidth:  16,
                            dotHeight:  16.0,
                            paintStyle: PaintingStyle.stroke,
                            strokeWidth:  1.5,
                            dotColor:  Colors.grey,
                            activeDotColor: secondColor
                        ),
                      ),
                    ),
                    const SizedBox(height: 15,),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:
                      [
                        Text("Categories",style: TextStyle(color: mainColor,fontSize: 20,fontWeight: FontWeight.bold),),
                        Text("View all",style: TextStyle(color: secondColor,fontSize: 14,fontWeight: FontWeight.bold),),
                      ],
                    ),
                    cubit.categories.isEmpty ?
                    const Center(child: CupertinoActivityIndicator(),) :
                    SizedBox(
                      height: 70,
                      width: double.infinity,
                      child: ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          itemCount: cubit.categories.length,
                          scrollDirection: Axis.horizontal,
                          separatorBuilder: (context,index){
                            return const SizedBox(width: 15,);
                          },
                          itemBuilder: (context,index)
                          {
                            return CircleAvatar(
                              radius: 35,
                              backgroundImage: NetworkImage(cubit.categories[index].url!),
                            );
                          }
                      ),
                    ),
                    cubit.products.isEmpty ?
                    const Center(child: CupertinoActivityIndicator(),) :
                    GridView.builder(
                        itemCount: cubit.filteredProducts.isEmpty ?
                        cubit.products.length :
                        cubit.filteredProducts.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 15,
                            childAspectRatio: 0.7
                        ),
                        itemBuilder: (context,index)
                        {
                          return _productItem(
                              model: cubit.filteredProducts.isEmpty ?
                              cubit.products[index] :
                              cubit.filteredProducts[index],
                              cubit: cubit
                          );
                        }
                    )
                  ],
                ),
              )
          );
        }
    );
  }
}

Widget _productItem({required ProductModel model,required LayoutCubit cubit}){
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(4),
      color: Colors.grey.withOpacity(0.2),
    ),
    padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
      [
        Expanded(
          child: Image.network(model.image!,fit: BoxFit.fill,width: double.infinity,height:double.infinity,),
        ),
        const SizedBox(height: 5,),
        Text(model.name!,style: const TextStyle(fontWeight: FontWeight.bold,fontSize:16,overflow: TextOverflow.ellipsis),),
        const SizedBox(height: 2,),
        Row(
          children:
          [
            Expanded(
              child: Row(
                children:
                [
                  FittedBox(fit:BoxFit.scaleDown,child: Text("${model.price!} \$",style: const TextStyle(fontSize:13),)),
                  const SizedBox(width: 5,),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text("${model.oldPrice!} \$",style: const TextStyle(color:Colors.grey,fontSize: 12.5,decoration: TextDecoration.lineThrough),),)
                ],
              ),
            ),
            GestureDetector(
              child: CircleAvatar(
                backgroundColor: Colors.grey,
                child: Icon(
                  cubit.favoritesID.contains(model.id.toString()) ?Icons.favorite:Icons.favorite_border,
                  size: 26,
                  color: cubit.favoritesID.contains(model.id.toString()) ? Colors.red : Colors.white,
                ),
              ),
              onTap: () {
                // Trigger add/remove favorite functionality
                cubit.addOrRemoveFromFavorites(productID: model.id.toString());
              },
            ),
          ],
        )
      ],
    ),
  );
}