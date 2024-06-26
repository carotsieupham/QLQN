import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qlqn/src/firebase/order_firestore.dart';
import 'package:qlqn/src/models/order.dart';
import 'package:qlqn/src/models/staff.dart';
import '../../../firebase/orderDetail_firestore.dart';
import '../../../models/orderDetail.dart';

class NoteTotalCheckOut extends StatefulWidget {
  NoteTotalCheckOut({
    super.key,
    required this.staff,
    required this.total,
    required this.listOrderItem,
    required this.onCheckOut,
  });
  Staff staff;
  var total;
  Function onCheckOut;
  final List<OrderDetail> listOrderItem;
  @override
  State<NoteTotalCheckOut> createState() => _NoteTotalCheckOutState();
}

class _NoteTotalCheckOutState extends State<NoteTotalCheckOut> {
  TextEditingController noteController = TextEditingController();

  Future<void> addOrderToFireStore()async {
    Timestamp now = Timestamp.now();
    DocumentReference staff = FirebaseFirestore.instance.collection('Staff').doc(widget.staff.id);
    Orders order = Orders("", staff,now,noteController.text );
    await OrderFireStore().insert(order).then((DocumentReference docRef) {
      for(var productOrder in widget.listOrderItem){
        DocumentReference? product = productOrder.productId;
        OrderDetail orderDetail = OrderDetail("",docRef,product,productOrder.quantity);
        print(orderDetail.toString());
        OrderDetailFireStore().insert(orderDetail);
      }
    });
  }

  void ShowNotice() async{
     showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Orders'),
          content: const Text('Bạn đã order thành công!'),
          actions: [
            TextButton(
              child: const Text('Đóng'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: noteController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[300],
                hintText: 'Ghi chú...',
                hintStyle:  TextStyle(
                  color: Colors.grey[600],
                  fontSize: 15,
                  fontFamily: 'Primary Family',
                  fontWeight: FontWeight.w500,
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none
                ),
              ),
            ),
            const SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Tổng tiền: ',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontFamily: 'Secondary Family',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  widget.total.toString(),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontFamily: 'Secondary Family',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20,),
            ElevatedButton(
              onPressed: () async {
                if (widget.listOrderItem.isEmpty) {
                  Get.snackbar('Thông báo', 'Không có sản phẩm nào trong giỏ hàng');
                  return;
                }
                await addOrderToFireStore();
                Get.back(result: true);
                await widget.onCheckOut();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF492803),
                fixedSize: const Size(300, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Thanh toán',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Secondary Family'
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
