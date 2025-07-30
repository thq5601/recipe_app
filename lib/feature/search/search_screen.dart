import 'package:flutter/material.dart';
import 'package:food_recipes/core/theme/app_colors.dart';
import 'package:food_recipes/model/meal.dart';
import 'package:food_recipes/routes.dart';
import 'package:food_recipes/services/meal_service.dart';
import 'package:food_recipes/widget/header_search.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Set<String> selectedCategories = {};
  Set<String> selectedIngredients = {};
  Set<String> selectedAreas = {};

  List<String> categories = [];
  List<String> ingredients = [];
  List<String> areas = [];

  List<Meal> searchResults = [];
  Meal? recentlyViewedMeal;
  bool _hasSearched = false;

  bool isLoadingFilters = true;

  Future<void> _handleSearch(String query) async {
    if (query.isEmpty) {
      if (!mounted) return;
      setState(() {
        searchResults = [];
        _hasSearched = false;
      });
      return;
    }

    final results = await MealService.searchMealsByName(query);
    if (!mounted) return;
    setState(() {
      searchResults = results;
      _hasSearched = true;
    });
  }

  void _handleMealTap(Meal meal) async {
    await Navigator.pushNamed(context, AppRoutes.detail, arguments: meal.id);
    if (!mounted) return;
    setState(() {
      recentlyViewedMeal = meal;
      searchResults = [];
      _hasSearched = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchFilterOptions();
  }

  Future<void> _fetchFilterOptions() async {
    final fetchedCategories = await MealService.fetchCategories();
    final fetchedIngredients = await MealService.fetchAllIngredients();
    final fetchedAreas = await MealService.fetchAreas();

    if (!mounted) return; //
    setState(() {
      categories = fetchedCategories.map((e) => e.name).take(10).toList();
      ingredients = fetchedIngredients.map((e) => e.name).take(10).toList();
      areas = fetchedAreas.take(10).toList();
      isLoadingFilters = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            HeaderSearch(
              showFilter: true,
              onSearch: _handleSearch,
              onFilterTap: () => _openFilterModal(context),
            ),
            Expanded(
              child: _hasSearched
                  ? (searchResults.isNotEmpty
                        ? ListView.builder(
                            itemCount: searchResults.length,
                            itemBuilder: (context, index) {
                              final meal = searchResults[index];
                              return ListTile(
                                title: Text(meal.name),
                                trailing: const Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16,
                                  color: AppColors.primary600,
                                ),
                                onTap: () => _handleMealTap(meal),
                              );
                            },
                          )
                        : const Center(child: Text("Khong tim thay")))
                  : (recentlyViewedMeal != null
                        ? Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: SizedBox(
                              height: 300,
                              child: GridView.count(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 0.75,
                                children: [_buildMealCard(recentlyViewedMeal!)],
                              ),
                            ),
                          )
                        : const Center(
                            child: Text("Mon ban da xem se hien thi o day"),
                          )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMealCard(Meal meal) {
    return GestureDetector(
      onTap: () => _handleMealTap(meal),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: Image.network(
                    meal.thumbnail,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.all(6),
                    child: const Icon(
                      Icons.favorite_border,
                      color: Colors.red,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Text(
                meal.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                "By Tran Hoang Quan",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Row(
                children: const [
                  Icon(Icons.access_time, size: 14, color: Colors.orange),
                  SizedBox(width: 4),
                  Text("20m", style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openFilterModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.only(
            top: 16,
            left: 16,
            right: 16,
            bottom: 32,
          ),
          child: FutureBuilder<void>(
            future: _fetchFilterOptions(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
                    
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Lọc',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              selectedCategories.clear();
                              selectedIngredients.clear();
                              selectedAreas.clear();
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFfdf3db),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: const Text(
                            'Đặt lại',
                            style: TextStyle(color: AppColors.primary600),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 8),
                    _buildSectionTitle(Icons.list, 'Danh mục'),
                    _buildChipGroup(
                      categories,
                      selectedCategories,
                      (label) => setState(() {
                        selectedCategories.contains(label)
                            ? selectedCategories.remove(label)
                            : selectedCategories.add(label);
                      }),
                    ),
                    
                    const SizedBox(height: 8),
                    _buildSectionTitle(Icons.food_bank, 'Nguyên liệu'),
                    _buildChipGroup(
                      ingredients,
                      selectedIngredients,
                      (label) => setState(() {
                        selectedIngredients.contains(label)
                            ? selectedIngredients.remove(label)
                            : selectedIngredients.add(label);
                      }),
                    ),
                    
                    const SizedBox(height: 8),
                    _buildSectionTitle(Icons.location_on, 'Khu vực'),
                    _buildChipGroup(
                      areas,
                      selectedAreas,
                      (label) => setState(() {
                        selectedAreas.contains(label)
                            ? selectedAreas.remove(label)
                            : selectedAreas.add(label);
                      }),
                    ),
                    
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary600,
                          foregroundColor: AppColors.neutral50,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 15,
                          ),
                          textStyle: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: const Text(
                          'Xác nhận',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }


  Widget _buildSectionTitle(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey[700]),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildChipGroup(
    List<String> options,
    Set<String> selectedSet,
    void Function(String) onSelect,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: options.map((label) {
          final isSelected = selectedSet.contains(label);
          return ChoiceChip(
            label: Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.neutral50 : Colors.black87,
              ),
            ),
            selected: isSelected,
            selectedColor: AppColors.primary600,
            backgroundColor: Colors.grey[200],
            onSelected: (_) => onSelect(label),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            
          );
        }).toList(),
      ),
    );
  }


}
