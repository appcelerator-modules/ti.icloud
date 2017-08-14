/**
 * Eyncrypted Database
 * Copyright (c) 2017-Present by Appcelerator, Inc.
 * All Rights Reserved.
 */

'use strict';

exports.id = 'ti.icloud';
exports.cliVersion = '>=3.2';
exports.init = init;

/**
 * main entry point for our plugin which looks for the platform specific
 * plugin to invoke
 */
function init(logger, config, cli, appc) {
	cli.on('build.ios.xcodeproject', {
		pre: function(data) {
			logger.info('Injecting iCloud system-capabilities ...');

			var iCloudIdentifier = 'com.apple.iCloud';
			var hash = data.args[0].hash;
			var objects = hash.project.objects;
			var rootObject = objects.rootObject;
			var projectObject = objects[rootObject];
			var attributes = projectObject.attributes['TargetAttributes'];
			var capabilities = attributes[0]['SystemCapabilities'];
						
			for (var prop in capabilities) {
				if (prop == iCloudIdentifier && capabilities[prop]['enabled'] == 0) {
					logger.error('iCloud inside capabilities but disabled Skipping ...!');
					return;
				}
			}

			capabilities[] = { enabled: 1 };

			// Re-assign the updated system capabilities
			data.args[0].hash.project.objects[rootObject].attributes['TargetAttributes'][0]['SystemCapabilities'] = capabilities;
		}
	});
}
