'use strict';
const path = require('path');
const execa = require('execa');
const electronUtil = require('electron-util/node');
const macosVersion = require('macos-version');

const binary = path.join(electronUtil.fixPathForAsarUnpack(__dirname), 'focus-window');

const isSupported = macosVersion.isGreaterThanOrEqualTo('10.14.4');

module.exports = windowNumber => {
	if (!isSupported) {
		return false;
	}

	if (!windowNumber) {
		throw new Error('Please provide a windowNumber');
	}

	try {
		const {stdout} = execa.sync(binary, ['focus', windowNumber]);
		return stdout === 'true';
	} catch (error) {
		throw new Error(error.stderr);
	}
};

module.exports.isSupported = isSupported;

module.exports.hasPermissions = () => {
	if (!isSupported) {
		return false;
	}

	const {stdout} = execa.sync(binary, ['permissions', 'check']);

	return stdout === 'true';
};

module.exports.requestPermissions = () => {
	if (!isSupported) {
		return false;
	}

	const {stdout} = execa.sync(binary, ['permissions', 'ask']);

	return stdout === 'true';
};
