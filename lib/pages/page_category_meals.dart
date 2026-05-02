import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../services/api_service.dart';
import 'page_meal_detail.dart';

class PageCategoryMeals extends StatefulWidget {
  final String categoryName;

  const PageCategoryMeals({super.key, required this.categoryName});

  @override
  State<PageCategoryMeals> createState() => _PageCategoryMealsState();
}

class _PageCategoryMealsState extends State<PageCategoryMeals> {
  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';
  List<MealSummary> _meals = [];

  @override
  void initState() {
    super.initState();
    _loadMeals();
  }

  Future<void> _loadMeals() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
      _errorMessage = '';
    });

    try {
      final meals = await ApiService.fetchMealsByCategory(widget.categoryName);
      setState(() {
        _meals = meals;
      });
    } catch (error) {
      setState(() {
        _hasError = true;
        _errorMessage = error.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_hasError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 12),
              Text(
                'Terjadi kesalahan saat mengambil data.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                _errorMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadMeals,
                child: const Text('Coba lagi'),
              ),
            ],
          ),
        ),
      );
    }

    if (_meals.isEmpty) {
      return const Center(
        child: Text('Tidak ada masakan ditemukan untuk kategori ini.'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12.0),
      itemCount: _meals.length,
      itemBuilder: (context, index) {
        final meal = _meals[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                meal.strMealThumb,
                width: 72,
                height: 72,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
              ),
            ),
            title: Text(meal.strMeal),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PageMealDetail(idMeal: meal.idMeal),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
