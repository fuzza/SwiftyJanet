import PackageDescription

let package = Package(
    name: "SwiftyJanet",
    dependencies: [
        .Package(url: "https://github.com/ReactiveX/RxSwift", majorVersion: 3)
    ],
    exclude: [
        "Tests"
    ]
)
