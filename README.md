## Yelp client
CodePath iOS Intro Class - Week 2 - Yelp

Build a Yelp search app

Time Spent: 17 hours

Completed user stories:
 * Search Results Page:
   * [x] Required: Table rows should be dynamic height according to the content height
   * [x] Required: Custom cells should have the proper Auto Layout constraints
   * [x] Required: Search bar should be in the navigation bar (doesn't have to expand to show location like the real Yelp app does). Hint: This is just a UISearchBar that is set as the navigationItem.titleView
   * [x] Optional: infinite scroll for restaurant results
   * [ ] Optional: Implement map view of restaurant results
 * Filter Page:
   * [x] Required: The filters you should actually have are: category, sort (best match, distance, highest rated), radius (meters), deals (on/off).
   * [x] Required: The filters table should be organized into sections as in the mock.
   * [x] Required: You can use the default UISwitch for on/off states.
   * [x] Required: Clicking on the "Search" button should dismiss the filters page and trigger the search w/ the new filter settings.
   * [x] Optional: implement a custom switch
   * [x] Optional: Radius filter should expand as in the real Yelp app
   * [x] Optional: Categories should show a subset of the full list with a "See All" row to expand. Category list is here: http://www.yelp.com/developers/documentation/category_list (Links to an external site.)
 * Restaurant Page:
   * [ ] Optional: Implement the restaurant detail page.

Notes:

### Walkthrough of all user stories
![Video Walkthrough](animation.gif)
GIF created with [LiceCap](http://www.cockos.com/licecap/).

### Sample request

```
self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];
        
[self.client searchWithTerm:@"Thai" success:^(AFHTTPRequestOperation *operation, id response) {
   NSLog(@"response: %@", response);
} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
   NSLog(@"error: %@", [error description]);
}];
```

### Sample response

```
businesses =     (
                {
            categories =             (
                                (
                    Thai,
                    thai
                )
            );
            "display_phone" = "+1-415-931-6917";
            id = "lers-ros-thai-san-francisco";
            "image_url" = "http://s3-media2.ak.yelpcdn.com/bphoto/IStxUNVdfuPR2ddDAIPk_A/ms.jpg";
            "is_claimed" = 1;
            "is_closed" = 0;
            location =             {
                address =                 (
                    "730 Larkin St"
                );
                city = "San Francisco";
                "country_code" = US;
                "cross_streets" = "Olive St & Ellis St";
                "display_address" =                 (
                    "730 Larkin St",
                    "(b/t Olive St & Ellis St)",
                    Tenderloin,
                    "San Francisco, CA 94109"
                );
                neighborhoods =                 (
                    Tenderloin
                );
                "postal_code" = 94109;
                "state_code" = CA;
            };
            "menu_date_updated" = 1387658025;
            "menu_provider" = "single_platform";
            "mobile_url" = "http://m.yelp.com/biz/lers-ros-thai-san-francisco";
            name = "Lers Ros Thai";
            phone = 4159316917;
            rating = 4;
            "rating_img_url" = "http://s3-media4.ak.yelpcdn.com/assets/2/www/img/c2f3dd9799a5/ico/stars/v1/stars_4.png";
            "rating_img_url_large" = "http://s3-media2.ak.yelpcdn.com/assets/2/www/img/ccf2b76faa2c/ico/stars/v1/stars_large_4.png";
            "rating_img_url_small" = "http://s3-media4.ak.yelpcdn.com/assets/2/www/img/f62a5be2f902/ico/stars/v1/stars_small_4.png";
            "review_count" = 1154;
            "snippet_image_url" = "http://s3-media4.ak.yelpcdn.com/photo/D40HpcJt-O6Ll654S_--6w/ms.jpg";
            "snippet_text" = "Fantastic pad-see-ew. Super rich, flavorful sauce and plenty of ginormous prawns, especially for a $12 price tag in San Francisco. I went through a pretty...";
            url = "http://www.yelp.com/biz/lers-ros-thai-san-francisco";
        }
    );
    region =     {
        center =         {
            latitude = "37.7703124";
            longitude = "-122.43647245575";
        };
        span =         {
            "latitude_delta" = "0.06424638000000016";
            "longitude_delta" = "0.07145348265001417";
        };
    };
    total = 760;
```
