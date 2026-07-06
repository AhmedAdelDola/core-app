// part of '../../profile_imports.dart';

// class FavouriteScreen extends StatefulWidget {
//   const FavouriteScreen({super.key});

//   @override
//   State<FavouriteScreen> createState() => _FavouriteScreenState();
// }

// class _FavouriteScreenState extends State<FavouriteScreen> {
//   int list = 10;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: const CustomAppBar(title: 'المفضلة'),
//       body: list == 0
//           ? Center(
//               child: AppText(
//                 'لا يوجد عناصر في المفضلة',
//                 style: TextStyles.textViewMedium(color: AppColors.textColor5),
//               ),
//             )
//           : ListView.custom(
//               childrenDelegate: SliverChildBuilderDelegate(
//                 childCount: list,
//                 (context, index) => FavouriteItem(
//                   onTabRemoveFav: () {
//                     list--;
//                     setState(() {});
//                   },
//                 ),
//               ),
//             ),
//     );
//   }
// }
