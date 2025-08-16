import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:innerspace_booking_app/core/color_constant.dart';
import 'package:innerspace_booking_app/core/common_widgets/gradients/GradientBoxBorder.dart';
import 'package:innerspace_booking_app/features/branch/presentation/bloc/branch_bloc.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class SearchFilterBar extends StatefulWidget {
  final FocusNode focusnode;
  const SearchFilterBar({super.key, required this.focusnode});

  @override
  _SearchFilterBarState createState() => _SearchFilterBarState();
}

class _SearchFilterBarState extends State<SearchFilterBar> {
  final TextEditingController _searchController = TextEditingController();

  String? _selectedCity;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search Bar
        Padding(
      padding: EdgeInsets.only(right: 16.w, ),
          child: Material(
            elevation: 2,
            borderRadius: BorderRadius.circular(16.r),
            child: TextField(
              focusNode: widget.focusnode,
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by name or city',
                prefixIcon: Icon(Icons.search, color: gradientOne),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear, color: gradientOne),
                        onPressed: () {
                          _searchController.clear();
                          _resetFilters();
                          FocusScope.of(context).unfocus(); // 🔹 Remove focus
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 12.h),
              ),
              onChanged: (_) => setState(() {}),
              onSubmitted: (value) {
                FocusScope.of(context).unfocus(); // 🔹 Remove focus
                if (value.trim().length > 2) {
                  context
                      .read<BranchBloc>()
                      .add(SearchBranchesEvent(value.trim()));
                } else if (value.isEmpty) {
                  _resetFilters();
                }
              },
            ),
          ),
        ),
        SizedBox(height: 12.h),
        _buildCityFilter(),
      ],
    );
  }

  Widget _buildCityFilter() {
    final cities = [
      'Chennai',
      'Bangalore',
      'Mumbai',
      'Kochi',
      "Hyderbad",
      "Kolkata",
      "Goa"
    ];

    return SizedBox(
      height: 33.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: cities.length,
        separatorBuilder: (_, __) => SizedBox(width: 8.w),
        itemBuilder: (context, index) {
          final city = cities[index];
          final isSelected = _selectedCity == city;

          return GestureDetector(
            onTap: () => _filterByCity(isSelected ? null : city),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: isSelected ? chipSelected : Colors.grey.shade300,
                  width: 1.2,
                ),
              ),
              child: Center(
                child: isSelected
                    ? GradientText(
                        city,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14.sp,
                        ),
                        gradientType: GradientType.radial,
                        radius: 2.5,
                        colors: const [
                          secondaryGradient,
                          primaryGradient,
                        ],
                      )
                    : Text(
                        city,
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.w500,
                          fontSize: 14.sp,
                        ),
                      ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _filterByCity(String? city) {
    setState(() {
      _selectedCity = city;
    });

    if (city == null) {
      _resetFilters();
    } else {
      context.read<BranchBloc>().add(SearchBranchesEvent(city));
    }
  }

  void _resetFilters() {
    setState(() {
      _selectedCity = null;
    });
    context.read<BranchBloc>().add(GetAllBranches());
  }
}
