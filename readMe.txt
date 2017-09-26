************ GROCERIES APP - READ ME FILE *****************

*********** DESCRIPTION AND USAGE ******************

Groceries is an app where the user can create shopping lists, each identified by user chosen names. Each list can contain several shopping items and for each item the user can check the price of a randomly chosen product which contains the same item name from the British supermarket chain; Tesco. If the product is displayed is correct, great, otherwise the userhas the option of pressing the button 'search for a different product' which takes the user to a webpage displaying the results with the given item name. If the user wants to know the price of an item name which does not give a result back, the user can choose to search on Tesco's webpage. 

For items in a given list the user can tap the item to indicate that the user has bought the item, the app responds by changing the shopping cart icon to a 'check' icon. 

The user can swipe left and press the delete button to delete any item or list. 

The user can use the '+' or 'add list' buttons to add new items or lists. 

************ HOW TO START THE APP *****************

Open the Xcode project and press run to start the app. 
Initially, there are some pre-set example lists, if you prefer to start the app without
any lists, open the file AppDelegate.swift and uncomment removeAllPreviousData() in the
method application(didFinishLaunchingWithOptions:), and comment out preData() in the
same method. 
