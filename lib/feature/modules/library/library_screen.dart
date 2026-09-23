part of 'library_imports.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _controller;

  @override
  void initState() {
    _controller = TabController(length: 3, vsync: this, initialIndex: 1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobileLandscape = AppResponsive.isMobileLandscape(context);
    final double tabHeight = isMobileLandscape ? 38.0 : 48.0;
    final verticalSpacing = (isMobileLandscape ? 6.0 : 16.0).sbH;

    return Column(
      children: [
        verticalSpacing,
        AdaptiveContainer(
          maxWidth: 550,
          child: Container(
            height: tabHeight,
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: isMobileLandscape ? 12.w : 16.w),
            padding: EdgeInsets.all(isMobileLandscape ? 2.r : 4.r),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(
                color: const Color(0xFFE2E8F0),
                width: 1,
              ),
            ),
            child: TabBar(
              physics: const NeverScrollableScrollPhysics(),
              controller: _controller,
              dividerColor: Colors.transparent,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                color: AppColors.kWhite,
                borderRadius: BorderRadius.circular(10.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              labelColor: AppColors.kPrimary,
              unselectedLabelColor: AppColors.textColor3,
              labelStyle: TextStyle(
                fontSize: isMobileLandscape ? 12.sp : 14.sp,
                fontWeight: FontWeight.bold,
              ),
              unselectedLabelStyle: TextStyle(
                fontSize: isMobileLandscape ? 11.sp : 13.sp,
                fontWeight: FontWeight.w500,
              ),
              tabs: const [
                Tab(text: 'الملفات'),
                Tab(text: 'الكورسات'),
                Tab(text: 'الالتزامات'),
              ],
            ),
          ),
        ),
        verticalSpacing,
        Expanded(
          child: TabBarView(
            controller: _controller,
            children:  [
              QuizesTab(),
              CoursesTab(),
              Commitment(),
            ],
          ),
        ),
      ],
    );
  }
}
