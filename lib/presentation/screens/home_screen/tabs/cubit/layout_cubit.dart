import 'package:e_commerce_shop/widgets/shared_pref.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import '../../../../../data/models/banner_model.dart';
import '../../../../../data/models/category_model.dart';
import '../../../../../data/models/product_model.dart';
import 'layout_state.dart';

class LayoutCubit extends Cubit<LayoutStates> {
  LayoutCubit() : super(LayoutInitialState());

  // List to store fetched banners
  List<BannerModel> banners = [];

  /// Fetch banner data from the API using Dio
  Future<void> getBannersData() async {
    emit(GetBannersLoadingState());
    try {
      Dio dio = Dio(
        BaseOptions(
          baseUrl: 'https://student.valuxapps.com/api',
          // Base URL
          receiveDataWhenStatusError: true,
          // Receive errors if status is non-success
          headers: {
            'Content-Type': 'application/json',
            'lang': 'en', // Language preference
          },
        ),
      );
      Response response = await dio.get(
          "https://student.valuxapps.com/api/banners");

      if (response.data['status'] == true) {
        // Clear the current banners list

        for (var item in response.data['data']) {
          banners.add(BannerModel.fromJson(data: item));
        }
        emit(GetBannersSuccessState());
      } else {
        emit(GetBannersFailureState());
      }
    } catch (e) {
      emit(GetBannersFailureState());
      print("Error fetching banners: $e");
    }
  }


  List<CategoryModel> categories = []; // List to store category data

  /// Fetch category data using Dio
  void getCategoriesData() async {
    try {
      // Initialize Dio instance
      Dio dio = Dio(
        BaseOptions(
          baseUrl: 'https://student.valuxapps.com/api', // Base URL
          receiveDataWhenStatusError: true,
          headers: {
            'Content-Type': 'application/json',
            'lang': 'en', // Language header
          },
        ),
      );

      // GET request to fetch categories
      final response = await dio.get('/categories');

      if (response.statusCode == 200) {
        final responseBody = response.data;

        if (responseBody['status'] == true) {
          // Parse response data into CategoryModel instances
          categories = responseBody['data']['data']
              .map<CategoryModel>((item) => CategoryModel.fromJson(data: item))
              .toList();

          emit(GetCategoriesSuccessState()); // Emit success state
        } else {
          emit(FailedToGetCategoriesState()); // Emit failure state with message
        }
      } else {
        emit(FailedToGetCategoriesState()); // Emit failure state
      }
    } catch (e) {
      emit(FailedToGetCategoriesState()); // Emit failure state on exception
    }
  }

  /// Fetch products using Dio
  List<ProductModel> products = [];

  void getProducts() async {
    try {
      // Initialize Dio instance
      Dio dio = Dio(
        BaseOptions(
          baseUrl: 'https://student.valuxapps.com/api',
          receiveDataWhenStatusError: true,
          headers: {
            'Authorization': SharedPref.getToken(),
            // Token header for authorization
            'lang': 'en',
            // Language preference
          },
        ),
      );

      // GET request to fetch products
      final response = await dio.get('/home');

      if (response.statusCode == 200) {
        final responseBody = response.data;

        if (responseBody['status'] == true) {
          // Parse product data into ProductModel instances
          products = responseBody['data']['products']
              .map<ProductModel>((item) => ProductModel.fromJson(data: item))
              .toList();

          emit(GetProductsSuccessState()); // Emit success state
        } else {
          emit(FailedToGetProductsState()); // Emit failure state
        }
      } else {
        emit(FailedToGetProductsState()); // Emit failure state
      }
    } catch (e) {
      emit(FailedToGetProductsState()); // Emit failure state on exception
    }
  }

  List<ProductModel> filteredProducts = [];

  void filterProducts({required String input}) {
    filteredProducts = products.where((element) =>
        element.name!.toLowerCase().startsWith(input.toLowerCase())).toList();
    emit(FilterProductsSuccessState());
  }
  List<ProductModel> favorites = []; // List to store favorite products
  Set<String> favoritesID = {}; // Set to ensure no duplicates

  /// Fetch favorites using Dio
  Future<void> getFavorites() async {

    try {
      // Initialize Dio instance
      Dio dio = Dio(
        BaseOptions(
          baseUrl: 'https://student.valuxapps.com/api',
          receiveDataWhenStatusError: true,
          headers: {
            "lang": "en",
            "Authorization": SharedPref.getToken(),
          },
        ),
      );

      // GET request to fetch favorites
      final response = await dio.get('/favorites');

      if (response.statusCode == 200) {
        final responseBody = response.data;

        if (responseBody['status'] == true) {
          // Clear previous favorites
          favorites.clear();
          favoritesID.clear();

          // Loop through and parse favorites
          for (var item in responseBody['data']['data']) {
            favorites.add(ProductModel.fromJson(data: item["product"]));
            favoritesID.add(item['product']['id'].toString());
          }

          print("Favorites number is : ${favorites.length}");
          emit(GetFavoritesSuccessState()); // Emit success state
        } else {
          emit(FailedToGetFavoritesState()); // Emit failure state with message
        }
      } else {
        emit(FailedToGetFavoritesState()); // Emit failure state
      }
    } catch (e) {
      emit(FailedToGetFavoritesState()); // Emit exception failure state
    }
  }


  /// Add or Remove product from favorites
  void addOrRemoveFromFavorites({required String productID}) async {

    try {
      // Initialize Dio instance
      Dio dio = Dio(
        BaseOptions(
          baseUrl: 'https://student.valuxapps.com/api', // Base URL
          receiveDataWhenStatusError: true,
          headers: {
            "lang": "en", // Language preference
            "Authorization": SharedPref.getToken(), // Authorization header
          },
        ),
      );

      // POST request to add/remove product from favorites
      final response = await dio.post(
        '/favorites',
        data: {
          "product_id": productID,
        },
      );

      if (response.statusCode == 200) {
        final responseBody = response.data;

        if (responseBody['status'] == true) {
          if (favoritesID.contains(productID)) {
            // Remove product from favorites
            print("Product removed successfully");
            favoritesID.remove(productID); // Update local set
          } else {
            // Add product to favorites
            print("Product added successfully");
            favoritesID.add(productID); // Update local set
          }

          emit(AddOrRemoveItemFromFavoritesSuccessState()); // Emit success state
          await getFavorites(); // Refresh favorite products
        } else {
          emit(FailedToAddOrRemoveItemFromFavoritesState()); // Emit failure with message
        }
      } else {
        emit(FailedToAddOrRemoveItemFromFavoritesState()); // Emit failure state
      }
    } catch (e) {
      emit(FailedToAddOrRemoveItemFromFavoritesState()); // Emit exception failure state
    }
  }

  List<ProductModel> carts = []; // List to store products in the cart
  int totalPrice = 0; // Variable to store the total price

  /// Fetch cart data using Dio
  Future<void> getCarts() async {

    try {
      // Initialize Dio instance
      Dio dio = Dio(
        BaseOptions(
          baseUrl: 'https://student.valuxapps.com/api', // Base URL
          receiveDataWhenStatusError: true,
          headers: {
            "Authorization": SharedPref.getToken(), // Token for authorization
            "lang": "en", // Language preference
          },
        ),
      );

      // GET request to fetch cart data
      final response = await dio.get('/carts');

      if (response.statusCode == 200) {
        final responseBody = response.data;

        if (responseBody['status'] == true) {
          // Clear the current cart and totalPrice
          carts.clear();
          totalPrice = 0;

          // Loop through and parse cart items
          for (var item in responseBody['data']['cart_items']) {
            carts.add(ProductModel.fromJson(data: item['product']));
          }

          // Update total price
          totalPrice = responseBody['data']['total'];

          print("Carts length is: ${carts.length}, Total Price: $totalPrice");
          emit(GetCartsSuccessState()); // Emit success state
        } else {
          emit(FailedToGetCartsState()); // Emit failure with message
        }
      } else {
        emit(FailedToGetCartsState()); // Emit failure state
      }
    } catch (e) {
      emit(FailedToGetCartsState());
    }
  }

}

