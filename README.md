# 01-ProductApp

## Overview
ProductApp is an iOS application built with Swift and UIKit that displays a curated list of products.
Users can browse products, view detailed information, and add products to their list.

https://github.com/user-attachments/assets/b0de2b02-e677-4cfb-a90e-2bf658c4ae73

## Features
- **Product Listing:**  
  View a list of products with images, names, and prices.
- **Product Details:**  
  Tap on a product to see detailed information including its price and image.
- **Add to List:**  
  Easily add products to your list from the details page.
- **Swipe Actions:**  
  Use swipe gestures on the product cells for actions like editing and deletion.

## Technologies
- **Swift:** Primary programming language.
- **UIKit:** For building user interfaces.
- **Custom Protocols:** For managing interactions in custom table view cells.

## Project Structure
- **AppDelegate.swift:**  
  Manages the application lifecycle.
- **SceneDelegate.swift:**  
  Handles the app’s scene and window management.
- **MainPage.swift:**  
  Displays the list of products.
- **DetailsPage.swift:**  
  Shows detailed information for a selected product.
- **Products.swift:**  
  Defines the product model.
- **ProductsCell.swift:**  
  Custom table view cell used to display product information.

-------------------------------------------------------------------------------------------------------------------------------

# 02-MapApp

## Overview
A simple iOS application that integrates maps, location tracking, and persistent storage.
This project demonstrates the use of several iOS frameworks to build a map-based application.

https://github.com/user-attachments/assets/579d06f4-856a-4022-93cc-b8fef90d0975

## Features
- **View Current Location:** Displays the user’s current location.
- **Add Locations:** Use a long press gesture on the map to add a location.
- **Save Locations:** Persist location data using CoreData.
- **Navigation:** Navigate to saved locations using MapKit.

## Technologies
- **Swift:** Primary programming language.
- **UIKit:** For UI components and view controller management.
- **MapKit & CoreLocation:** For map functionalities and location tracking.
- **CoreData:** For persistent data storage.
- **Storyboard & Segue:** For visual UI design and navigation.
- **Delegation & NotificationCenter:** For managing user interactions and updates.

## Project Structure
- **ListViewController.swift:** Manages the list of saved locations in a table view.  
- **MapsViewController.swift:** Handles the map, annotations, and location services.  
- **AppDelegate.swift:** Configures the CoreData stack and application lifecycle.

-------------------------------------------------------------------------------------------------------------------------------

# 03-Save-Picture-And-Detail

## Overview
A simple iOS application that allows users to save product details along with an image, name, price, and description using Core Data.

https://github.com/user-attachments/assets/695783cf-9399-4ca9-88bc-2acbda66060a

## Features
- Display a list of saved products.
- Add new products with details and an image (selected from the photo library).
- Save product details (name, price, description) persistently using Core Data.
- Delete products from the list.

## Technologies
- **Swift:** Primary programming language.
- **UIKit:** Building the user interface.
- **CoreData:** Persistent data storage.
- **UIImagePickerController:** Image selection from the photo library.
- **NotificationCenter:** Updating views upon data changes.

## Project Structure
- **ViewController.swift:** Manages the list of saved products, including fetching data from Core Data and handling deletions.
- **DetailsViewController.swift:** Provides a form to add new product details or view existing product information.
- **AppDelegate.swift:** Configures the CoreData stack and application lifecycle.

-------------------------------------------------------------------------------------------------------------------------------

# 04-ListApp

## Overview
ListApp is a simple iOS application developed in Swift that demonstrates basic CRUD operations using Core Data.
The app allows users to add, edit, and delete list items, providing a clean interface built with UIKit.

https://github.com/user-attachments/assets/0507c437-8753-4e8e-9b73-949e1001f5e6

## Features
- **Add List Items:** Users can add new items via an alert with a text field.
- **Edit List Items:** Swipe actions allow editing of existing items.
- **Delete List Items:** Items can be deleted individually or all at once.
- **Persistent Storage:** Data is saved locally using Core Data.

## Technologies
- **Swift:** Primary programming language.
- **UIKit:** For building the user interface.
- **Core Data:** For persistent data storage.

## Project Structure
- **ViewController.swift:**  Manages the display of list items, handling user interactions (add, edit, delete) and fetching data from Core Data.
- **AppDelegate.swift:**  Configures the Core Data stack and manages application lifecycle events.
- **SceneDelegate.swift:**  (If applicable) Manages the app’s window and scene lifecycle for iOS 13 and later.
- **Custom TableView Cells:**  Contains any custom cells used to present list items.

-------------------------------------------------------------------------------------------------------------------------------

# 05-FilmsCollectionView

## Overview
FilmsCollectionView is an iOS application built using Swift and UIKit. It displays a collection of films in a visually
appealing layout and allows users to view film details and add films to a list.

https://github.com/user-attachments/assets/706a0b56-52c1-45a9-ae02-91d9716c6486

## Features
- **Film Collection:**  
  Displays a grid of films with images and prices.
- **Film Details:**  
  Tap on a film to view detailed information including its name and price.
- **Add to List:**  
  Users can add films to their list via a button in the film cell.
- **Responsive Layout:**  
Utilizes UICollectionView for a dynamic and responsive design.

## Technologies
- **Swift:** Primary programming language.
- **UIKit:** For building the user interface.
- **UICollectionView:** To display films in a grid format.
- **Custom Protocols:** To handle cell interactions.

## Project Structure
- **AppDelegate.swift:**  Manages the application lifecycle.
- **SceneDelegate.swift:**  Handles the app’s window and scene management.
- **Films.swift:**  Defines the film model used to represent film data.
- **filmsCell.swift:**  Custom collection view cell that displays film image and price, and handles cell interactions via a protocol.
- **DetailsPage.swift:**  Displays detailed information about a selected film, including its name, image, and price.
- **MainPage.swift:**  Manages the film collection view, configures its layout, and handles navigation to the details page.

-------------------------------------------------------------------------------------------------------------------------------

# 06-NewsApp

## Overview
newsApp is an iOS application that fetches and displays news articles from a remote JSON data source.
It utilizes a simple MVVM approach to separate data handling from the UI, providing a clean and responsive interface.

https://github.com/user-attachments/assets/bf48f7a5-0648-469d-aa45-028353c91835


## Features
- **Fetch News:** Downloads news articles from a specified URL.
- **Display Articles:** Presents news in a table view with dynamic cell sizing.
- **MVVM Architecture:** Uses view models to encapsulate news data for easy UI integration.

## Technologies
- **Swift:** Primary programming language.
- **UIKit:** For building user interfaces.
- **URLSession & JSONDecoder:** For networking and JSON parsing.
- **MVVM Pattern:** For structured and modular code organization.

## Project Structure
- **NewsCell.swift:** Custom table view cell that displays the news title and story. 
- **ViewController.swift:** Main view controller managing the news list and user interactions.
- **News.swift:** Model representing a news article. 
- **WebService.swift:** Handles network requests to fetch news data. 
- **NewsViewModel.swift:** Contains view models for transforming news data for the UI. 
- **AppDelegate.swift:** Manages the application lifecycle. 
- **SceneDelegate.swift:** Manages the app’s window and scene configuration. 

-------------------------------------------------------------------------------------------------------------------------------

## 🚀 Setup

1. **Clone the Repository:**  
   git clone [<repository-url>](https://github.com/burak0aydin/6-Pieces-iOSApp)

2. **Open the project in Xcode:**  
   open "ProjectName".xcodeproj
  
3. **Build and run the project on an iOS simulator or a physical device.**
