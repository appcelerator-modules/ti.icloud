/**
 * Ti.iCloud
 * Copyright (c) 2017-Present by Axway Appcelerator
 * All Rights Reserved.
 */

'use strict';

exports.id = 'ti.icloud';
exports.cliVersion = '>=3.2';
exports.init = init;

/**
 * Main entry point for our plugin which looks for the platform specific
 * plugin to invoke
 */
function init(logger, config, cli, appc) {
	cli.on('build.ios.xcodeproject', {
		pre: function(data) {
			logger.info('Injecting iCloud system-capabilities ...');

			// Dig through the .pbxproj data structure
			var iCloudIdentifier = 'com.apple.iCloud';
			var hash = data.args[0].hash;
			var objects = hash.project.objects;
			var rootObject = hash.project.rootObject;
			var projectObject = objects['PBXProject'][rootObject];
			var attributes = projectObject.attributes['TargetAttributes'];
			var capabilities = attributes[Object.keys(attributes)[0]]['SystemCapabilities'];

			// Loop through existing system-capabilities
			Object.keys(capabilities).forEach(function(key) {
				if (key == iCloudIdentifier && capabilities[key]['enabled'] == 0) {
					logger.error('iCloud inside capabilities but disabled Skipping ...!');
					return;
				}
			});

			// Enabled the com.apple.iCloud capability
			capabilities[iCloudIdentifier] = { enabled: 1 };
			
			// Re-assign the updated system capabilities
			data.args[0].hash.project.objects['PBXProject'][rootObject].attributes['TargetAttributes'][Object.keys(attributes)[0]]['SystemCapabilities'] = capabilities;			
		}
	});
}
