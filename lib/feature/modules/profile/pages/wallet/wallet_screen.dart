part of '../../profile_imports.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'المحفظة'),
      body: BlocProvider.value(
        value: di<WalletCubit>()..getWalletHistory(),
        child: BlocConsumer<WalletCubit, WalletState>(
          listener: (context, state) {
            if (state is GetWalletHistoryErrorState) {
              showErrorToast(state.error);
            }
          },
          builder: (context, state) {
            final cubit = WalletCubit.of(context);
            final model = cubit.wallet;
            if (state is GetWalletHistoryLoadingState) return const AppLoader();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'الرصيد الحالي',
                        style: TextStyle(
                          color: AppColors.textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${model?.wallet?.balance ?? 0} ${model?.wallet?.currencyCode ?? 'EGP'} ',
                        style: const TextStyle(
                          color: AppColors.textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  'المعاملات السابقة',
                  style: TextStyle(
                    color: AppColors.textColor,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),

                Expanded(
                  child: ListView.builder(
                    itemCount: model?.transactions?.length ?? 0,
                    itemBuilder: (context, index) {
                      final item = model?.transactions?[index];
                      return WalletHistoryItem(item: item!);
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class WalletHistoryItem extends StatelessWidget {
  final Transaction? item;

  const WalletHistoryItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item?.createdAt == null
                ? ''
                : DateFormat('yyyy-MM-dd', 'en').format(item!.createdAt!),
            style: const TextStyle(color: AppColors.textColor, fontSize: 14),
          ),
          5.sbH,
          Text(
            '${item?.amount ?? 0} ',
            style: const TextStyle(color: AppColors.textColor, fontSize: 14),
          ),
          const Divider(),
        ],
      ),
    );
  }
}
