#UBCodingChallenge

This is the result project of the Coding challengee.

The aim is to allow the user to search a keyword and display all the available images using the flickr api.

## Architecture

The chosen architecture is VIPER. It is overkill for a small application like that but the point was to use a clean architecture ready to run in production.
It also allows me to easily add feature in the future.

### Entities

3 entities have been used for this application in order to represent the search response of the flickr api.
- FlickrSearchResponse
- FlickrPhotosResponse
- FlickrPhoto

All the object attributes have been mapped but most of them are useless for the moment.

### Interactor

Call the FlickrApiService in order to retrieve the requested photos.
The FlickrApiService use the iOS URLSession with an added extension to easily work with the Result object. (See ApiService group in the project)

### Presenter

The presenter discusses with the view and the interactor to display data and maintain the state of the app (last query and last page requested). The view only have to ask to the presenter a new search or more photos for the current search. The presenter will send the right parameter to the interactor to perform the request.

### View

The view display a search bar at the top of the screen and a collection view on the remaining space. The collection view respects the specification and react properly to the orientation change.
It can display : 
- No search performed message
- No result message
- Error message
- The collection view with photos

### Router

The router is only use to instantiate the VIPER module

## Tests

I added some tests to the project. Mainly on the presenter in order to ensure that an action on the presenter has the right effect on the view.

A mock view and some mock api service (very simple) have been created

## Point that should be discussed

### Image loading & Cache

For simplicity, I created a UIImageView extension that adds a function to load an image from an URL. At the same time, I added a static NSCache in the UIImageView extension to quickly enable a cache system.

This solution is easy to implement and easy to use but brokes the single responsibility principle. In a bigger project, this should be discuss and probably avoid.

### Api service

The Api service take only the required argument for this application. It would be better if all the query parameter was handle properly. For now, the URL is created from a String with place holder for required value.

The enum of error could probably be more details.

### CollectionView reload

On new data, the collectionView#reload method is called. It cause "blinking" due to the reload process. A better way to handle this could be satisfying for our eyes.

### Ensuring running on UIThread

Sometime, I believe that an Api call should be returned on the main thread, sometime I don't. For this project, the view is responsible to take care of running the methods on the UIThread

## Note

### TextDiDChange vs SearchClick

I started by using the textDiDChange method from the UISearchViewDelegate and debouncing the method in the presenter to avoid multiple call.
I changed this behaviour and the search is only perform when the user click on the search button.

The idea behind this was simply to avoid displaying inappriate content during the search typing.



## Conclusion

I took around five hours to make the application and about an hour to build the test.
We can find improvments to this application code but I won't be ashame to share it with people which is a good point :)
