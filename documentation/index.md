# Ti.iCloud Module

## Description

Gives you access to storing simple key-value pairs in iCloud. Values will be synchronized across all of the user's iOS devices.


## Requirements

This module will ONLY work with iOS 5 and higher. You must also set up an identifier for iCloud in your application's entitlements. Read more in [Apple's documentation][].

## Getting Started

View the [Using Titanium Modules](https://wiki.appcelerator.org/display/tis/Using+Titanium+Modules) document for instructions on getting
started with using this module in your application.

## Accessing the Ti.iCloud Module

To access this module from JavaScript, you would do the following:

	var iCloud = require('ti.icloud');


## Methods

### bool sync()
Forces your recent property changes to be saved to disk. Calling this method is optional, and it does not influence
when Apple chooses to synchronize your changes with their servers and other iOS devices.

### void setString(string key, string value)
Stores a string.

### void setBool(string key, bool value)
Stores a boolean.

### void setDictionary(string key, dictionary value)
Stores a dictionary of any serializable values.

### void setList(string key, object[] value)
Stores an array of serializable values.

### void setInt(string key, int value)
Stores an integer.

### void setDouble(string key, double value)
Stores a double.

### void setObject(string key, object value)
Stores a serializable object.

### string getString(string key)
Retrieves a previously stored string.

### bool getBool(string key)
Retrieves a previously stored boolean.

### dictionary getDictionary(string key)
Retrieves a previously stored dictionary.

### object[] getList(string key)
Retrieves a previously stored array.

### int getInt(string key)
Retrieves a previously stored integer.

### double getDouble(string key)
Retrieves a previously stored double.

### object getObject(string key)
Retrieves a previously stored object.

### dictionary getAll()
Retrieves all previously stored properties as a dictionary. The key you stored the property with will be its key in the dictionary.

### void remove(string key)
Removes a previously stored property permanently.


## Usage
See example.


## Author
Matthew Apperson

## Module History

View the [change log](changelog.html) for this module.

## Feedback and Support

Please direct all questions, feedback, and concerns to [info@appcelerator.com](mailto:info@appcelerator.com?subject=iOS%20iCloud%20Module).

## License
Copyright(c) 2010-2011 by Appcelerator, Inc. All Rights Reserved. Please see the LICENSE file included in the distribution for further details.


[Apple's documentation]: http://developer.apple.com/library/mac/#documentation/Foundation/Reference/NSUbiquitousKeyValueStore_class/Reference/Reference.html