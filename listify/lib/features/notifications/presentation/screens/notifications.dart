import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class Notifications extends StatefulWidget{
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {

  int notificationType = 1;

  List<Notification> notifications = [
    Notification(
      "New Auction Alert!",
      "A new auction for a rare painting has started. Bid now!",
      DateTime.now().subtract(Duration(hours: 2)),
      "assets/images/auction.png",
      false,
    ),
    Notification(
      "Bid Won!",
      "Congratulations! You've won the auction for the iPhone 15.",
      DateTime.now().subtract(Duration(days: 1, hours: 3)),
      "assets/images/trophy.png",
      true,
    ),
    Notification(
      "Payment Reminder",
      "Your payment for the gaming laptop is due today.",
      DateTime.now().subtract(Duration(days: 1, hours: 5)),
      "assets/images/payment.png",
      false,
    ),
    Notification(
      "Auction Ending Soon",
      "Hurry! The auction for the Rolex watch is closing in 30 minutes.",
      DateTime.now().subtract(Duration(hours: 3, minutes: 45)),
      "assets/images/time.png",
      false,
    ),
    Notification(
      "New Message from Sellerrrrrrrrrrrrrrrrrrrrraaa",
      "The seller has responded to your inquiry about the antique vase.",
      DateTime.now().subtract(Duration(days: 2, hours: 6)),
      "assets/images/message.png",
      true,
    ),
    Notification(
      "Account Security Alert",
      "We noticed a login from a new device. Was this you?",
      DateTime.now().subtract(Duration(days: 3, hours: 1)),
      "assets/images/security.png",
      true,
    ),
  ];

  List<Notification> filteredNotifications = [];

  @override
  void initState() {
    super.initState();
    // Creating a deep copy of notifications
    filteredNotifications = List.from(notifications.map((notification) =>
        Notification(notification.heading, notification.description, notification.dateTime, notification.image, notification.isRead))
    );
  }

  void filterNotifications(int notificationType){
    if(notificationType == 1){
      filteredNotifications.clear();
      for(var notification in notifications){
        filteredNotifications.add(notification);
      }
    }
    else if(notificationType == 2){
      filteredNotifications.clear();
      for(var notification in notifications){
        if(notification.isRead == true){
          filteredNotifications.add(notification);
        }
      }
    }
    else if(notificationType == 3){
      filteredNotifications.clear();
      for(var notification in notifications){
        if(notification.isRead == false){
          filteredNotifications.add(notification);
        }
      }
    }
  }

  String formatNotificationDate(DateTime dateTime) {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime yesterday = today.subtract(Duration(days: 1));

    if (dateTime.isAfter(today)) {
      return "Today";
    } else if (dateTime.isAfter(yesterday)) {
      return "Yesterday";
    } else {
      return DateFormat('dd MMM').format(dateTime); // Format as "24 Feb"
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 10, 5, 10),
                    child: Container(
                      constraints: BoxConstraints(
                        minWidth: 100,
                        maxHeight: 38
                      ),
                      decoration:
                          notificationType == 1 ?
                      BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Color.fromRGBO(27, 164, 36, 0.15),
                      )
                      :
                      BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Color.fromRGBO(227, 227, 227, 0.65),
                      ),
                      child: TextButton(
                          onPressed: (){
                            setState(() {
                              notificationType = 1;
                              filterNotifications(1);
                            });
                          },
                          child: Text("All", style:
                          notificationType == 1 ?
                            TextStyle(color: Color(0xFF1BA424),fontSize: 18)
                            :
                            TextStyle(color: Color(0xFF575656),fontSize: 18),)),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 10, 5, 10),
                    child: Container(
                      constraints: BoxConstraints(
                          minWidth: 110,
                          maxHeight: 38
                      ),
                      decoration:
                      notificationType == 2 ?
                      BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Color.fromRGBO(27, 164, 36, 0.15),
                      )
                          :
                      BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Color.fromRGBO(227, 227, 227, 0.65),
                      ),
                      child: TextButton(
                          onPressed: (){
                            setState(() {
                              notificationType = 2;
                              filterNotifications(2);
                            });
                          },
                          child: Text("Read", style:
                          notificationType == 2 ?
                          TextStyle(color: Color(0xFF1BA424),fontSize: 18,)
                              :
                          TextStyle(color: Color(0xFF575656),fontSize: 18),)),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 10, 5, 10),
                    child: Container(
                      constraints: BoxConstraints(
                          minWidth: 110,
                          maxHeight: 38
                      ),
                      decoration:
                      notificationType == 3 ?
                      BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Color.fromRGBO(27, 164, 36, 0.15),
                      )
                          :
                      BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Color.fromRGBO(227, 227, 227, 0.65),
                      ),
                      child: TextButton(
                          onPressed: (){
                            setState(() {
                              notificationType = 3;
                              filterNotifications(3);
                            });
                          },
                          child: Text("Unread", style:
                          notificationType == 3 ?
                          TextStyle(color: Color(0xFF1BA424),fontSize: 18)
                              :
                          TextStyle(color: Color(0xFF575656),fontSize: 18),)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20.0,10,25,20),
              child: CustomScrollView(
              slivers: [
              SliverFillRemaining( // This will fill the remaining space and center the content
              hasScrollBody: false, // Ensures content does not scroll and stays centered
              child: Column(
                children: filteredNotifications.map((notification) =>
                    GestureDetector(
                      onTap: (){

                      },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0,0,0,25),
                        child: Row(
                          children: [
                            CircleAvatar(
                                radius: 30, // Adjust the size
                                backgroundImage: AssetImage("assets/images/profileImg.png") // Replace with your image URL
                            ),
                            SizedBox(
                              width: 30,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          notification.heading,
                                          overflow: TextOverflow.ellipsis, // Add ellipsis when the text overflows
                                          maxLines: 1,
                                          style: notification.isRead
                                              ? TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                                              : TextStyle(fontSize: 18),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        formatNotificationDate(notification.dateTime),
                                        style: notification.isRead
                                            ? TextStyle(fontSize: 14, fontWeight: FontWeight.bold)
                                            : TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    notification.description,
                                    overflow: TextOverflow.ellipsis, // Add ellipsis when the text overflows
                                    maxLines: 1,
                                    style: notification.isRead
                                        ? TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                                        : TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                ).toList()
              ))
                      ]),
            ),
          )]);
  }
}

class Notification{
  String heading;
  String description;
  DateTime dateTime;
  String image;
  bool isRead;
  
  Notification(this.heading, this.description, this.dateTime, this.image, this.isRead);
}