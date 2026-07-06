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
    return Column(
      children: [
        24.sbH,
        Container(
          height: 48.h,
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFC),
            border: Border.all(
              color: AppColors.kPrimary.withOpacity(0.3),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(50.r),
          ),
          child: TabBar(
            physics: const NeverScrollableScrollPhysics(),
            controller: _controller,
            indicatorColor: Colors.transparent,
            indicator: BoxDecoration(
                color: AppColors.kWhite,
                borderRadius: BorderRadius.circular(50.r)),
            labelColor: AppColors.kPrimary,
            unselectedLabelColor: AppColors.textColor2,
            tabs: const [
              AppText('الملفات'),
              AppText('الكورسات'),
              AppText('الالتزامات'),
            ],
          ),
        ),
        24.sbH,
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
