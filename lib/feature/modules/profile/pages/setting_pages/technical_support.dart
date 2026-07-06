part of '../../profile_imports.dart';

class TechnicalSupport extends StatelessWidget {
  const TechnicalSupport({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'الدعم الفني'),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: appSettings?.contacts?.length ?? 0,
          itemBuilder: (context, index) {

          return ProfileItem(
              onTap: () => AppLauncher.launchWhatsApp(
                number: appSettings?.contacts?[index].value ?? '',
              ),
              title:'${appSettings?.contacts?[index].label ?? ''}',
              subTitle: 'تواصل مع ${appSettings?.contacts?[index].label ?? ''} من خلال الواتس اب',

              img: AppImages.whatsappSvg,
              child: Text(  
                appSettings?.contacts?[index].isActive == true ? 'متاح' : 'غير متاح',
                style:  TextStyle(
                  color: appSettings?.contacts?[index].isActive == true ? AppColors.kDarkModeGreen : AppColors.kDarkModeRed,
                  fontSize: 14,
                ),
              ),
            );
        }),
      ),
    );
  }
}
