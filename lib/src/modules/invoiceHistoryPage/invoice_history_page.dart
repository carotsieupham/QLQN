import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qlqn/src/firebase/order_firestore.dart';
import 'package:qlqn/src/modules/orderHistoryDetailPage/order_history_detail_page.dart';
import 'package:get/get.dart';
import '../../models/order.dart';
class InvoiceHistoryPage extends StatefulWidget {
  const InvoiceHistoryPage({super.key});

  @override
  State<InvoiceHistoryPage> createState() => _InvoiceHistoryPageState();
}

class _InvoiceHistoryPageState extends State<InvoiceHistoryPage> {
  List<Orders> orederList = [];
  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() async{
    OrderFireStore orderFireStore = OrderFireStore();
    List<Orders> orderList = await orderFireStore.getAllDocument();
    setState(() {
      this.orederList = orderList;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF492803),
        title: const Text(
          'Lịch sử hóa đơn',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30.0,
            fontWeight: FontWeight.w500,
            fontStyle: FontStyle.italic,
            fontFamily: 'Lora',
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white, size: 30),
      ),
      body: SafeArea(
        child:ListView(
          children: orederList.map((e) => OrderCard(orders: e)).toList(),
        )
      ),
    );
  }
}

class OrderCard extends StatefulWidget {
  OrderCard({
    super.key,
    required this.orders,
  });
  Orders orders;

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  String staffName = '';
  String staffId = '';

  @override
  void initState() {
    super.initState();
    _fetchData();
    print(widget.orders.staffId);
  }

  void _fetchData() async {
    OrderFireStore orderFireStore = OrderFireStore();
    String? name = await orderFireStore.getNameStaff(widget.orders.staffId);
    String id = widget.orders.staffId.id;
    setState(() {
      this.staffName = name!;
      this.staffId = id;
    });
  }

  String formatTimestamp(Timestamp timestamp) {
    DateTime date = timestamp.toDate();
    return DateFormat('HH:mm dd/MM/yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
        child: Container(
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: Color(0xFF492803), width: 2),
              bottom: BorderSide(color: Color(0xFF492803), width: 2),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Thời gian',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Secondary Family',
                        ),
                      ),
                      Text(
                        formatTimestamp(widget.orders.orderDate),
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontFamily: 'Secondary Family',
                        ),
                      ),
                      const Text(
                        'Nhân viên order',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Secondary Family',
                        ),
                      ),
                      Text(
                        ' $staffName-$staffId',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontFamily: 'Secondary Family',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 150,
                child: DottedLine(
                  direction: Axis.vertical,
                  lineLength: double.infinity,
                  lineThickness: 1.2,
                  dashLength: 4.0,
                  dashColor: Color(0xFF492803),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Tổng tiền',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Secondary Family',
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.orders.total.toString(),
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Secondary Family',
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Get.to(OrderHistoryDetailPage(orders: widget.orders));
                        },
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size.fromHeight(50),
                          backgroundColor: Color(0xFF492803),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.navigate_next,
                              color: Colors.white,
                            ),
                            Text(
                              'Xem chi tiết',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Secondary Family',
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

    );
  }
}