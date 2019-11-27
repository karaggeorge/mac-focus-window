// swift-tools-version:5.1
import PackageDescription

let package = Package(
	name: "focus-window",
	platforms: [
		.macOS(.v10_12)
	],
	dependencies: [
		.package(url: "https://github.com/jakeheis/SwiftCLI", from: "5.0.0")
	],
	targets: [
		.target(
			name: "focus-window",
			dependencies: [
				"SwiftCLI"
			]
		)
	]
)
