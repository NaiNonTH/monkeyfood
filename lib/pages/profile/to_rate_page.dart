import 'package:flutter/material.dart';
import 'package:monkeyfood/models/food.dart';
import 'package:monkeyfood/repositories/food_repositories.dart';
import 'package:monkeyfood/services/image_service.dart';
import 'package:monkeyfood/widgets/show_error.dart';

class ToRatePage extends StatefulWidget {
  const ToRatePage({super.key});

  @override
  State<ToRatePage> createState() => _ToRatePageState();
}

class _ToRatePageState extends State<ToRatePage> {
  static final FoodRepositories _foodRepositories = FoodRepositories();
  Future<List<Food>> _futureResult = _foodRepositories.getFoodsToRate();

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        final newResult = await _foodRepositories.getFoodsToRate();

        setState(() {
          _futureResult = Future.value(newResult);
        });
      },
      child: FutureBuilder(
        future: _futureResult,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return ShowError(message: snapshot.error.toString());
          }

          return ListView.separated(
            separatorBuilder: (context, index) => Divider(height: 1),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) => ListTile(
              leading: SizedBox(
                width: 100,
                height: 72,
                child: Image.network(
                  FoodImageService.instance.url(
                        snapshot.data![index].imageName,
                      ) ??
                      '',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Center(child: Icon(Icons.error_outline)),
                ),
              ),
              contentPadding: EdgeInsets.all(0),
              title: Text(
                snapshot.data![index].title,
                style: TextStyle(fontSize: 16),
              ),
              trailing: Padding(
                padding: const EdgeInsets.all(16.0),
                child: const Icon(Icons.arrow_forward_ios, size: 14),
              ),
            ),
          );
        },
      ),
    );
  }
}
