import 'package:flutter/material.dart';

class ScrollableListWithButtons extends StatefulWidget {
  @override
  _ScrollableListWithButtonsState createState() => _ScrollableListWithButtonsState();
}

class _ScrollableListWithButtonsState extends State<ScrollableListWithButtons> {
  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scrollable List With Buttons'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    _scrollController.animateTo(
                      _scrollController.offset - MediaQuery.of(context).size.width,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.arrow_forward),
                  onPressed: () {
                    _scrollController.animateTo(
                      _scrollController.offset + MediaQuery.of(context).size.width,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                  },
                ),
              ],
            ),
            SizedBox(
              height: 132,
              child: ListView.builder(
                itemCount: 4,
                scrollDirection: Axis.horizontal,
                controller: _scrollController,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 25, top: 1, bottom: 1, left: 1),
                    child: InkWell(
                      onTap: () {
                        // Your existing code for onTap
                        // ...
                      },
                      child: Container(
                        height: 130,
                        width: 285,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [BoxShadow(color: Colors.grey, spreadRadius: 0.5, blurRadius: 0.5)],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  index == 0
                                      ? 'Total Bill Amount'
                                      : index == 1
                                          ? 'Total Bill Number'
                                          : index == 2
                                              ? 'Total Item Sale'
                                              : 'Today Total Item sale',
                                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 14),
                                ),
                                const SizedBox(
                                  height: 25,
                                ),
                                Text(
                                  '100000',
                                  style: TextStyle(color: Colors.black.withOpacity(0.8), fontWeight: FontWeight.w600, fontSize: 16),
                                ),
                              ],
                            ),
                            Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                color: index == 0
                                    ? const Color(0XFFd0424e)
                                    : index == 1
                                        ? const Color(0XFFf5a623)
                                        : index == 2
                                            ? const Color(0XFFd0424e)
                                            : const Color(0XFFf5a623),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: index == 0
                                  ? const Icon(
                                      Icons.verified_user_sharp,
                                      color: Colors.white,
                                      size: 36,
                                    )
                                  : index == 1
                                      ? const Icon(
                                          Icons.production_quantity_limits,
                                          color: Colors.white,
                                          size: 36,
                                        )
                                      : index == 2
                                          ? const Icon(
                                              Icons.currency_bitcoin,
                                              color: Colors.white,
                                              size: 36,
                                            )
                                          : const Icon(
                                              Icons.category,
                                              color: Colors.white,
                                              size: 36,
                                            ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ScrollableListWithButtons(),
  ));
}
