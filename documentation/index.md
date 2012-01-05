# Ti.iCloud Module

## Description

Gives you access to storing simple key-value pairs in iCloud. Values will be synchronized across all of the user's iOS devices.


## Requirements

There are several requirements for this module to function properly:

1. This module will ONLY work with iOS 5 devices and higher. THE SIMULATOR WILL NOT WORK!
2. All provisioning profiles must have been generated from an application configured to support iCloud. Check in your Provisioning Portal > App IDs that the "iCloud" column says "Enabled" beside your app.
3. The device must be set up to use iCloud, and be signed in to an iCloud account.

Otherwise, you will receive warnings, and any calls to the "sync" method will return false.

If you have met the above requirements and you are still receiving errors, try removing the profiles from your device, and delete them from your Apple account. Regenerate them and try again.

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


## Events

### externalChange
The value changed on the remote server. This can occur when another device syncs a new value to the server.

Receives a dictionary with the following keys:

* string[] keys: Affected store keys.

### needsInitialSync
Local changes were discarded because an initial sync from the server has not yet happened. Initial syncs happen the
first time the device is synced but may also happen when user account settings change.
                                                                                      
Receives a dictionary with the following keys:

* string[] keys: Affected store keys.

### quotaViolated
The key-value store has exceeded its space quota on the server.
                                                               
Receives a dictionary with the following keys:

* string[] keys: Affected store keys.


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
