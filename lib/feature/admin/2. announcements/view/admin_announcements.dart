import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_base/feature/admin/2.%20announcements/riverpod/announcements_prover.dart';
import 'package:flutter_riverpod_base/feature/admin/2.%20announcements/view/dialog/add_announcement.dart';
import 'package:flutter_riverpod_base/models/announcement.dart';
import 'package:flutter_riverpod_base/res/themes.dart';
import 'package:flutter_riverpod_base/utils/logger.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminAnnouncements extends ConsumerStatefulWidget {
  const AdminAnnouncements({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AdminAnnouncementsState();
}

class _AdminAnnouncementsState extends ConsumerState<AdminAnnouncements> {
  List<String> columns = [
    'Title',
    'Content',
    'Date Posted',
    'Posted by',
  ];
  List<Announcement> searchData = [];
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final announcement = ref.watch(announcementProvider);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () async {
                await showDialog(
                  context: context,
                  builder: (builder) {
                    return AddAnnouncement();
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors().secondaryBlue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(15),
                fixedSize: const Size(200, 50),
              ),
              child: const Text('+ Add Announcement'),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Expanded(
            child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 8,
                    )
                  ],
                ),
                child: announcement.when(
                  data: (data) {
                    return Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              'Announcements',
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Spacer(),
                            SizedBox(
                              width: 300,
                              child: TextField(
                                controller: searchController,
                                decoration: InputDecoration(
                                  hintText: 'Search',
                                  hintStyle: GoogleFonts.poppins(),
                                  prefixIcon: Icon(
                                    Icons.search,
                                  ),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.black, width: 1.5)),
                                ),
                                onChanged: (value) {
                                  searchData = data.where((element) => element.title!.toLowerCase().contains(value)).toList();
                                  Log().info('Search Data: ${searchData.length}');
                                  setState(() {});
                                },
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Expanded(
                          child: DataTable2(
                            columns: List.generate(
                              columns.length,
                              (index) => DataColumn2(
                                label: Text(
                                  columns[index],
                                  style: GoogleFonts.poppins(),
                                ),
                              ),
                            ),
                            empty: Center(
                              child: Text(
                                'No data to show',
                                style: GoogleFonts.poppins(),
                              ),
                            ),
                            rows: List.generate(
                              searchData.isEmpty && searchController.text.isEmpty ? data.length : searchData.length,
                              (index) => DataRow2(
                                cells: [
                                  DataCell(
                                    Text(
                                      searchData.isEmpty && searchController.text.isEmpty ? "${data[index].title}" : "${searchData[index].title}",
                                      style: GoogleFonts.poppins(),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      searchData.isEmpty && searchController.text.isEmpty ? "${data[index].content}" : "${searchData[index].content}",
                                      style: GoogleFonts.poppins(),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      searchData.isEmpty && searchController.text.isEmpty
                                          ? data[index].datePosted.toString()
                                          : searchData[index].datePosted.toString(),
                                      style: GoogleFonts.poppins(),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      searchData.isEmpty && searchController.text.isEmpty
                                          ? "${data[index].postedBy}"
                                          : "${searchData[index].postedBy}",
                                      style: GoogleFonts.poppins(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                  error: (error, stack) {
                    return Text(error.toString());
                  },
                  loading: () {
                    return Center(child: CircularProgressIndicator());
                  },
                )),
          ),
        ],
      ),
    );
  }
}
