import 'package:flutter/material.dart';
import 'package:flutter_application_2/chip_data.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        theme: ThemeData(useMaterial3: true),
        debugShowCheckedModeBanner: false,
        home: const CatalogScreen(),
      );
}

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  int selectedIndex = 0;
  static final List<ChipData> categories = [
    ChipData(
        name: 'Вафли',
        id: 0,
        products:
            List.generate(1012, (index) => Product(name: 'Вафли $index'))),
    ChipData(
        name: 'Колбасы',
        id: 1,
        products:
            List.generate(2034, (index) => Product(name: 'Колбасы $index'))),
    ChipData(
        name: 'Чипсы',
        id: 2,
        products:
            List.generate(4933, (index) => Product(name: 'Чипсы $index'))),
    ChipData(
        name: 'Пиво',
        id: 3,
        products: List.generate(123, (index) => Product(name: 'Пиво $index'))),
  ];
  late ValueNotifier visibleUp = ValueNotifier(false);
  late AutoScrollController controller;
  @override
  void initState() {
    super.initState();
    controller = AutoScrollController(
      viewportBoundaryGetter: () =>
          Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom + 600),
      axis: Axis.vertical,
    );

    controller.addListener(() {
      if (controller.offset > 800) {
        visibleUp.value = true;
      } else {
        visibleUp.value = false;
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: ValueListenableBuilder(
          valueListenable: visibleUp,
          builder: (context, value, child) {
            if (value) {
              return FloatingActionButton(
                onPressed: () async {
                  await controller.scrollToIndex(
                    0,
                    preferPosition: AutoScrollPosition.middle,
                  );
                },
                child: const Icon(Icons.arrow_drop_up),
              );
            }

            return const SizedBox();
          }),
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: const Text('Наша марка'),
        backgroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: CustomScrollView(
        controller: controller,
        slivers: [
          SliverPersistentHeader(
            delegate: SortDelegate(),
          ),
          SliverPersistentHeader(
            delegate: CategoriesDelegate(controller, categories),
            pinned: true,
            floating: true,
          ),
          for (final category in categories)
            SliverMainAxisGroup(
              slivers: [
                SliverPersistentHeader(
                    delegate: CategoryHeaderDelegate(category.name, controller,
                        categories.indexOf(category))),
                SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 160 / 235,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => Card(
                      child: ListTile(
                        title: Text(category.products[index].name),
                      ),
                    ),
                    childCount: category.products.length,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class CategoryHeaderDelegate extends SliverPersistentHeaderDelegate {
  final String categoryName;
  final AutoScrollController controller;
  final int index;
  const CategoryHeaderDelegate(this.categoryName, this.controller, this.index);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return AutoScrollTag(
      key: ValueKey(index),
      controller: controller,
      index: index,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: SizedBox(
            height: 60.0,
            child: Text(
              categoryName,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            )),
      ),
    );
  }

  @override
  double get maxExtent => 60;

  @override
  double get minExtent => 60;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

class SortDelegate extends SliverPersistentHeaderDelegate {
  SortDelegate();

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: SizedBox(height: 40.0, child: Text('Сортировка: по умолчанию')),
    );
  }

  @override
  double get maxExtent => 40;

  @override
  double get minExtent => 40;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

class CategoriesDelegate extends SliverPersistentHeaderDelegate {
  final List<ChipData> categories;
  final ValueNotifier<int> _selectedIndex = ValueNotifier(0);
  final AutoScrollController controller;
  CategoriesDelegate(this.controller, this.categories);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      height: 60.0,
      color: Colors.white,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          final chip = categories[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: ValueListenableBuilder<int>(
                valueListenable: _selectedIndex,
                builder: (context, selectedIndex, _) {
                  return ChoiceChip(
                    showCheckmark: false,
                    selected: selectedIndex == index,
                    onSelected: (selected) async {
                      _selectedIndex.value = index;
                      await controller.scrollToIndex(index,
                          preferPosition: AutoScrollPosition.end);
                    },
                    padding: EdgeInsets.zero,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    elevation: .0,
                    pressElevation: .0,
                    label: RichText(
                      text: TextSpan(
                        children: <InlineSpan>[
                          TextSpan(
                            text: chip.name,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: selectedIndex == index
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: ' (${chip.products.length})',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: selectedIndex == index
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    side: BorderSide(
                      color: selectedIndex == index
                          ? Colors.white
                          : Theme.of(context).disabledColor,
                    ),
                    selectedColor: Colors.green,
                    backgroundColor: Colors.white,
                  );
                }),
          );
        },
      ),
    );
  }

  @override
  double get maxExtent => 60;

  @override
  double get minExtent => 60;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
