PNS-iOS
=======

This is a user-client application for iOS which is responsible for handling **push notifications** send from the [PNS](https://github.com/cojoj/Push-Notification-Server).  

**PNS-iOS** is responisble for registering and unregistering user from the server. What is more, it stores received push notifications in Core Data and presents them to the user in nice and clean form using `UITableView`.


How does it work?
-------------
As [Wikipedia](http://en.wikipedia.org/wiki/Apple_Push_Notification_Service) says:
> The Apple Push Notification Service is a service created by Apple Inc. that was launched together with iOS 3.0 on June 17, 2009. It uses push technology through a constantly open IP connection to forward notifications from the servers of third party applications to the Apple devices; such notifications may include badges, sounds or custom text alerts. In iOS 5, Notification Center enhanced the user experience of push and local notifications. APNs was also added as an API to Mac OS X v10.7 "Lion" for developers to take advantage of, and was greatly improved in OS X 10.8 "Mountain Lion" with the introduction of Notification Center.

Used libraries
-------------
+ [AFNetworking](http://afnetworking.com)
