// Include the module.
var iCloud = require('ti.icloud');

// Store several properties.
iCloud.setString('test', 'I love iCloud!');
iCloud.setList('test_two', [1, 2, 3]);

// Explicitly synchronize our changes to disk (note: to DISK, not to Apple's SERVERS).
alert('Saved to Disk? ' + (iCloud.sync() ? 'Yes!' : 'No. Check your entitlements!'));

// Finally, alert all of our stored properties.
alert(iCloud.getAll());