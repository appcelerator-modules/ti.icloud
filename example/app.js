/*
 This demo will show you how to use the iCloud module to create a cross-device persistent TextField.
 */
var iCloud = require('ti.icloud');

if (Ti.Platform.model == 'iPhone Simulator' || Ti.Platform.model == 'Simulator') {
  alert('The Simulator does not support iCloud!');
} else {
  var win = Ti.UI.createWindow({
    backgroundColor: 'white'
  });
  var text = Ti.UI.createTextField({
    hintText: 'Save text to iCloud',
    borderStyle: Ti.UI.INPUT_BORDERSTYLE_ROUNDED,
    height: 40,
    left: 20,
    right: 20,
    top: 20
  });
  win.add(text);
  win.open();

  // Let's pull the value from iCloud. Note that there are other types of "get" methods. Check out the docs!
  text.value = iCloud.getString('savedTextField');

  // Whenever the return key is hit, update the value in iCloud.
  text.addEventListener('return', function(evt) {
    // Now that the value has changed, let's save it back to iCloud.
    iCloud.setString('savedTextField', text.value);
    // The next step is optional -- iCloud does it automatically. To make sure that everything is working properly,
    // we'll force a disk synchronization. That will reveal any entitlement problems right away.
    alert('Saved to Disk? ' + (iCloud.sync() ? 'Yes!' : 'No. Check your entitlements!'));
  });

  // Whenever another device updates the text field and hits return, this event should fire.
  iCloud.addEventListener('externalChange', function(evt) {
    alert('External change detected!');
    Ti.API.info(evt.keys);
    text.value = iCloud.getString('savedTextField');
  });

  // When the user first installs the app, or updates their iCloud account, this event may fire -- it means iCloud hasn't
  // synchronized yet, so any changes we make will be discarded. This shouldn't last long, or be encountered frequently.
  iCloud.addEventListener('needsInitialSync', function(evt) {
    alert('Needs initial sync still! Changes discarded.');
    Ti.API.info(evt.keys);
    text.value = iCloud.getString('savedTextField');
  });

  // The following occurs when the user runs out of space.
  iCloud.addEventListener('quotaViolated', function(evt) {
    alert('Quota violated!');
    Ti.API.info(evt.keys);
    text.value = iCloud.getString('savedTextField');
  });
}
