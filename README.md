# Restaurant App

This app uses Yelp API to fetch information about nearby restaurants, and Core Data to store favorite places persistently.

It supports both iPhones and iPads running iOS 10 and higher. Written with Swift 4 and xCode 9.

App implements paging for batch fetching of the data, based on offset and limit parameters in Yelp API. It presents data in grid view with collection view and custom collection view cell. This grid can be sorted alphabetically in both ascending and descending order. Any item in collection view is clickable and leads to details page, where more photos and three latest reviews are fetched to the selected restaurant.

There is a possibility to save restaurants into Favourites tab, by clicking hearts through out the app. Hearts are present in grid view on both pages (Explore and Favourites), and also in details view. Core Data is used to store favourite restaurants between sessions of the app.

CocoaPods are used to use third-party libraries: Alamofire, AlamofireImage, KeychainSwift, and ReachabilitySwift.

Alamofire is used for REST API calls. AlamofireImage is used for async download of images and caching them. KeychainSwift is used to store token which is fetched from Yelp API. Finally, ReachabilitySwift was not yet used, but the idea was to check if network access is present, and if not then warn the user about that.

UnitTests are written to check API requests, core data object manipulation, and  testing some utility functions, such as date conversion from string.

Application also uses Dynamic Type for all labels to support Accessibility.

