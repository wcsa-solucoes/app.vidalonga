// import 'package:app_vida_longa/core/services/user_service.dart';
// import 'package:app_vida_longa/domain/contants/app_colors.dart';
// import 'package:app_vida_longa/domain/models/benefit_model.dart';
// import 'package:app_vida_longa/domain/models/categorie_chip_model.dart';
// import 'package:app_vida_longa/domain/models/user_model.dart';
// import 'package:app_vida_longa/shared/widgets/custom_bottom_navigation_bar.dart';
// import 'package:app_vida_longa/shared/widgets/custom_chip.dart';
// import 'package:app_vida_longa/shared/widgets/custom_scaffold.dart';
// import 'package:app_vida_longa/shared/widgets/decorated_text_field.dart';
// import 'package:app_vida_longa/shared/widgets/default_text.dart';
// import 'package:app_vida_longa/src/benefits/bloc/benefits_bloc.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_fonts/google_fonts.dart';

// class BenefitsView extends StatefulWidget {
//   const BenefitsView({super.key});

//   @override
//   State<BenefitsView> createState() => _BenefitsViewState();
// }

// class _BenefitsViewState extends State<BenefitsView> {
//   final BenefitsBloc _benefitsBloc = BenefitsBloc();

//   final TextEditingController _searchController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return CustomAppScaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         backgroundColor: AppColors.white,
//         title: const DefaultText(
//           "Benefícios",
//           fontSize: 20,
//           fontWeight: FontWeight.w300,
//         ),
//       ),
//       bottomNavigationBar: const CustomBottomNavigationBar(),
//       body: SizedBox(
//         width: MediaQuery.sizeOf(context).width,
//         height: MediaQuery.sizeOf(context).height,
//         child: BlocBuilder<BenefitsBloc, BenefitsState>(
//           bloc: _benefitsBloc,
//           builder: (context, state) {
//             return Builder(builder: (context) {
//               if (state is BenefitsLoadingState) {
//                 return const Center(child: CircularProgressIndicator());
//               }

//               if (state is BenefitsLoadedState) {
//                 return _loadedState(state);
//               }

//               if (state is HomeCategoriesSelectedState) {
//                 return _categoriesSelectedState(state);
//               }

//               return Container();
//             });
//           },
//         ),
//       ),
//     );
//   }

//   Widget _handleEmptyArticles() {
//     return SizedBox(
//       width: MediaQuery.of(context).size.width,
//       height: MediaQuery.of(context).size.height * 0.9,
//       child: Padding(
//         padding: const EdgeInsets.only(bottom: 100),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const DefaultText("Nenhum benefício encontrado"),
//             _handleReload(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _handleReload() {
//     return TextButton(
//       onPressed: _onRestart,
//       child: const Text("Recarregar"),
//     );
//   }

//   void _onRestart() {
//     _searchController.clear();
//     _benefitsBloc.add(RestartBenefitsEvent());
//   }

//   Widget _loadedState(BenefitsLoadedState state) {
//     if (state.benefits.isEmpty) {
//       return _handleEmptyArticles();
//     }
//     return SingleChildScrollView(
//       child: Column(
//         children: [
//           _handleSearch(),
//           SizedBox(
//               height: 50,
//               width: MediaQuery.of(context).size.width,
//               child: _handleChips(state.chipsCategorie, state.benefits)),
//           _handleArticles(state.benefits),
//         ],
//       ),
//     );
//   }

//   Widget _categoriesSelectedState(HomeCategoriesSelectedState state) {
//     return SingleChildScrollView(
//       child: Column(
//         children: [
//           SizedBox(
//             height: 50,
//             width: MediaQuery.of(context).size.width,
//             child: _handleChips(
//               state.chipsCategorie,
//               state.benefitsByCategory,
//             ),
//           ),
//           _handleArticles(state.benefitsByCategory),
//         ],
//       ),
//     );
//   }

//   Widget _handleChips(List<ChipCategorieModel> chipsCategorie,
//       List<List<BenefitModel>> benefitsByCategorySelectedAll) {
//     return ListView.builder(
//       padding: const EdgeInsets.all(8.0),
//       scrollDirection: Axis.horizontal,
//       itemCount: chipsCategorie.length,
//       itemBuilder: (context, index) {
//         return Padding(
//           padding: const EdgeInsets.only(left: 10),
//           child: IconChoiceChip(
//             isSelected: chipsCategorie[index].selected,
//             label: chipsCategorie[index].label,
//             onSelected: (bool selected) {
//               chipsCategorie[index] =
//                   chipsCategorie[index].copyWith(selected: selected);

//               var selectedChips =
//                   chipsCategorie.where((chip) => chip.selected).toList();

//               if (selectedChips.isEmpty) {
//                 _benefitsBloc.add(
//                   BenefitsLoadedEvent(
//                     benefits: benefitsByCategorySelectedAll,
//                     chipsCategorie: chipsCategorie,
//                   ),
//                 );
//               } else {
//                 var selectedBenefits = benefitsByCategorySelectedAll
//                     .where((benefits) => selectedChips
//                         .any((chip) => benefits.first.id == chip.uuid))
//                     .toList();

//                 _benefitsBloc.add(
//                   BenefitCategorieSelectedEvent(
//                     benefits: selectedBenefits,
//                     chipsCategorie: chipsCategorie,
//                   ),
//                 );
//               }
//             },
//           ),
//         );
//       },
//     );
//   }

//   Widget _handleSearch() {
//     return Padding(
//       padding: const EdgeInsets.only(top: 10),
//       child: DecoratedTextFieldWidget(
//         controller: _searchController,
//         hintText: "Buscar por título...",
//         labelText: "Buscar por título...",
//         suffixIcon: IconButton(
//           icon: const Icon(Icons.close, color: AppColors.dimGray),
//           onPressed: _onRestart,
//         ),
//         textInputAction: TextInputAction.search,
//         onSubmitted: (value) {
//           if (value.isEmpty) {
//             _benefitsBloc.add(RestartBenefitsEvent());
//           } else {
//             _benefitsBloc.add(BenefitsSearchEvent(searchTerm: value));
//           }
//         },
//       ),
//     );
//   }

//   Widget _handleArticles(List<List<BenefitModel>> benefitsByCategory) {
//     if (benefitsByCategory.isEmpty) {
//       return _handleEmptyArticles();
//     }

//     return ListView.builder(
//       physics:
//           const NeverScrollableScrollPhysics(), // Add this to keep the ListView from scrolling
//       shrinkWrap: true,
//       itemCount: benefitsByCategory.length,
//       padding: const EdgeInsets.only(bottom: 200),

//       itemBuilder: (BuildContext context, int categoryIndex) {
//         final categoryArticles = benefitsByCategory[categoryIndex];

//         return Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(2),
//             color: Colors.transparent,
//           ),
//           child: Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(top: 20),
//                 child: Text(
//                   categoryArticles.first.categoryTitle.toUpperCase(),
//                   style: GoogleFonts.getFont(
//                     'Poppins',
//                     fontWeight: FontWeight.w500,
//                     fontSize: 18,
//                     color: AppColors.secondaryText,
//                   ),
//                 ),
//               ),
//               Container(
//                 color: Colors.transparent,
//                 height: 250,
//                 child: ListView.builder(
//                   scrollDirection: Axis.horizontal,
//                   itemCount: categoryArticles.length,
//                   padding: const EdgeInsets.only(right: 20),
//                   itemBuilder: (BuildContext context, int articleIndex) {
//                     final benefit = categoryArticles[articleIndex];
//                     return Padding(
//                       padding: const EdgeInsets.only(
//                           left: 10, top: 4, bottom: 0, right: 15),
//                       child: BenefitCardWidget(benefit: benefit),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

// class BenefitCardWidget extends StatelessWidget {
//   final BenefitModel benefit;
//   const BenefitCardWidget({
//     super.key,
//     required this.benefit,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       borderRadius: BorderRadius.circular(10),
//       child: Container(
//         width: MediaQuery.of(context).size.width * 0.8,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10),
//           color: AppColors.white,
//           boxShadow: [
//             BoxShadow(
//               blurRadius: 1.0,
//               color: Colors.grey.withOpacity(0.5),
//               offset: const Offset(2.0, 3.0),
//             )
//           ],
//         ),
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 Expanded(
//                   child: Tooltip(
//                     message: benefit.title,
//                     preferBelow: false,
//                     child: Center(
//                       child: Padding(
//                         padding: const EdgeInsets.all(4.0),
//                         child: Text(
//                           benefit.title,
//                           maxLines: 1,
//                           style: GoogleFonts.getFont(
//                             'Poppins',
//                             fontWeight: FontWeight.w500,
//                             fontSize: 20.0,
//                             color: AppColors.titleColor,
//                           ),
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             Row(
//               children: [
//                 StreamBuilder<UserModel>(
//                     initialData: UserService.instance.user,
//                     stream: UserService.instance.userStream,
//                     builder: (context, AsyncSnapshot<UserModel> snapshot) {
//                       return InkWell(
//                         onTap: () {},
//                         child: Container(
//                           margin: const EdgeInsets.only(left: 20),
//                           height: 80,
//                           width: 80,
//                           decoration: BoxDecoration(
//                               borderRadius: const BorderRadius.all(
//                                 Radius.circular(10),
//                               ),
//                               border: Border.all(
//                                 color: AppColors.borderColor,
//                               ),
//                               color: AppColors.white,
//                               image: DecorationImage(
//                                   image: CachedNetworkImageProvider(
//                                       benefit.imageUrl),
//                                   fit: BoxFit.fill)),
//                         ),
//                       );
//                     }),
//                 const SizedBox(width: 5),
//                 const Expanded(
//                   child: Column(
//                     // mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       DefaultText(
//                         "Telefone: 79 9999-9999",
//                         fontSize: 16,
//                         // fontWeight: FontWeight.w700,
//                         color: AppColors.gray600,
//                       ),
//                       DefaultText(
//                         "Endereço: Rua das Flores, 123",
//                         fontSize: 16,
//                         // fontWeight: FontWeight.w700,
//                         color: AppColors.gray600,
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             const Row(
//               children: [
//                 Padding(
//                   padding: EdgeInsets.only(left: 20, right: 20, top: 10),
//                   child: DefaultText(
//                     "Benefícios",
//                     fontSize: 21,
//                     fontWeight: FontWeight.w600,
//                     color: AppColors.gray600,
//                   ),
//                 ),
//               ],
//             ),
//             Row(
//               children: [
//                 Expanded(
//                   child: Padding(
//                     padding:
//                         const EdgeInsets.only(left: 30, right: 20, top: 10),
//                     child: DefaultText(
//                       benefit.description,
//                       fontSize: 18,
//                       fontWeight: FontWeight.w400,
//                       color: AppColors.gray600,
//                       maxLines: 3,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
