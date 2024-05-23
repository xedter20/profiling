import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_base/feature/admin/1.%20dashboard/riverpod/total_residents.dart';
import 'package:flutter_riverpod_base/models/user.dart';
import 'package:flutter_riverpod_base/utils/logger.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminResidents extends ConsumerStatefulWidget {
  const AdminResidents({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AdminResidentsState();
}

class _AdminResidentsState extends ConsumerState<AdminResidents> {
  List<String> columns = [
    'Full Name',
    'Email',
    'Gender',
    'Barangay',
    'Birthday',
  ];

  List<UserModel> searchData = [];
  TextEditingController searchController = TextEditingController();

  var dropdownvalue;
  @override
  Widget build(BuildContext context) {
    final resident = ref.watch(totalResidentProvider);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                child: resident.when(
                  data: (data) {
                    debugPrint('movieTitle: $data');
                    return Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              'Residents',
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Spacer(),
                            SizedBox(
                                width: 300,
                                child: DropdownButton<String>(
                                  hint: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      "All Barangay",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                  items: List.generate(
                                      data.length,
                                      (index) => DropdownMenuItem<String>(
                                            value: "${data[index].purok}",
                                            child: Text("${data[index].purok}"),
                                          )),
                                  onChanged: (value) {
                                    searchData = data
                                        .where((element) => element.purok!
                                            .toLowerCase()
                                            .contains(value!.toLowerCase()))
                                        .toList();

                                    setState(() {});
                                    setState(() {
                                      dropdownvalue = value;
                                    });
                                  },
                                  value: dropdownvalue,
                                )),
                            Spacer(),
                            SizedBox(
                              width: 300,
                              child: TextField(
                                controller: searchController,
                                onChanged: (value) {
                                  searchData = data
                                      .where((element) => element.fullName!
                                          .toLowerCase()
                                          .contains(value.toLowerCase()))
                                      .toList();
                                  Log().info(
                                      'Search Data: ${searchData.length}');

                                  setState(() {});
                                },
                                decoration: InputDecoration(
                                  hintText: 'Search',
                                  hintStyle: GoogleFonts.poppins(),
                                  prefixIcon: Icon(
                                    Icons.search,
                                  ),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 1.5)),
                                ),
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
                              searchData.isEmpty &&
                                      searchController.text.isEmpty
                                  ? data.length
                                  : searchData.length,
                              (index) => DataRow2(
                                cells: [
                                  DataCell(
                                    Text(
                                      searchData.isEmpty &&
                                              searchController.text.isEmpty
                                          ? "${data[index].fullName}"
                                          : "${searchData[index].fullName}",
                                      style: GoogleFonts.poppins(),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      searchData.isEmpty &&
                                              searchController.text.isEmpty
                                          ? "${data[index].email}"
                                          : "${searchData[index].email}",
                                      style: GoogleFonts.poppins(),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      searchData.isEmpty &&
                                              searchController.text.isEmpty
                                          ? "${data[index].gender}"
                                          : "${searchData[index].gender}",
                                      style: GoogleFonts.poppins(),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      searchData.isEmpty &&
                                              searchController.text.isEmpty
                                          ? "${data[index].purok}"
                                          : "${searchData[index].purok}",
                                      style: GoogleFonts.poppins(),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      searchData.isEmpty &&
                                              searchController.text.isEmpty
                                          ? "${data[index].birthday}"
                                          : "${searchData[index].birthday}",
                                      style: GoogleFonts.poppins(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
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
