import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:savor/data/api/api_service.dart';
import 'package:savor/data/model/restaurant_detail.dart';
import 'package:savor/data/model/review_restaurant.dart';

import 'parse_json_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group("Api Service Test", () {
    // arrange
    late ApiService apiService;
    late MockClient client;

    setUp(() {
      client = MockClient();
      apiService = ApiService(client: client);
    });

    test(
        'should successfully parse json to RestaurantDetail after fetching from API',
        () async {
      var fakeRes = '''{
          "error": false,
          "message": "success",
          "restaurant": {
              "id": "rqdv5juczeskfw1e867",
              "name": "Melting Pot",
              "description": "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi. Aenean vulputate eleifend tellus. Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac, enim. Aliquam lorem ante, dapibus in, viverra quis, feugiat a, tellus. Phasellus viverra nulla ut metus varius laoreet.",
              "city": "Medan",
              "address": "Jln. Pandeglang no 19",
              "pictureId": "14",
              "categories": [
                  {
                      "name": "Italia"
                  },
                  {
                      "name": "Modern"
                  }
              ],
              "menus": {
                  "foods": [
                      {
                          "name": "Paket rosemary"
                      }
                  ],
                  "drinks": [
                      {
                          "name": "Es krim"
                      }
                  ]
              },
              "rating": 4.2,
              "customerReviews": [
                  {
                      "name": "Ahmad",
                      "review": "Tidak rekomendasi untuk pelajar!",
                      "date": "13 November 2019"
                  }
              ]
          }
      }''';

      when(client.get(Uri.parse(
              'https://restaurant-api.dicoding.dev/detail/rqdv5juczeskfw1e867')))
          .thenAnswer((_) async => http.Response(fakeRes, 200));

      // Act
      final result = await apiService.restaurantDetail("rqdv5juczeskfw1e867");

      // Assert
      expect(result, isA<RestaurantDetailResult>());
      expect(result.restaurant, isA<RestaurantDetail>());
      expect(result.restaurant.id, equals("rqdv5juczeskfw1e867"));
      expect(result.restaurant.name, equals("Melting Pot"));
    });

    test(
        "should successfully parse json to Review Restaurant after fetching from API",
        () async {
      var fakeRes = '''{
          "error": false,
          "message": "success",
          "customerReviews": [
              {
                  "name": "Ahmad",
                  "review": "Tidak rekomendasi untuk pelajar!",
                  "date": "13 November 2019"
              },
              {
                  "name": "test",
                  "review": "not bad",
                  "date": "14 September 2024"
              }
          ]
      }''';

      var fakeRev = AddReviewRestaurant(
          id: "rqdv5juczeskfw1e867", name: "test", review: "not bad");

      when(client.post(
        Uri.parse('https://restaurant-api.dicoding.dev/review'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(fakeRev.toJson()),
      )).thenAnswer((_) async => http.Response(fakeRes, 201));

      // Act
      final result = await apiService.addReview(fakeRev);

      // Assert
      expect(result, isA<ReviewRestaurantResult>());
      expect(result.customerReviews, isA<List<CustomerReview>>());
      expect(result.customerReviews.length, equals(2));
    });

    tearDown(() {
      client.close();
    });
  });
}
