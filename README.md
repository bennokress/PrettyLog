<h1 align="center">Welcome to PrettyLog 👋</h1>
<p>
  <a href="https://github.com/bennokress/PrettyLog/blob/main/LICENSE" target="_blank">
    <img alt="License" src="https://img.shields.io/github/license/bennokress/PrettyLog?style=social" />
  </a>
  <a href="https://twitter.com/bennokress" target="_blank">
    <img alt="Twitter: bennokress" src="https://img.shields.io/twitter/follow/bennokress.svg?style=social" />
  </a>
  <a href="https://reddit.com/u/bennokress" target="_blank">
    <img alt="Reddit: bennokress" src="https://img.shields.io/reddit/user-karma/combined/bennokress?label=%2Fu%2Fbennokress&style=social" />
  </a>
</p>

> PrettyLog is a small Swift Package that makes logging in the Xcode Console a little bit more beautiful.

## Install

```sh
dependencies: [
    .package(url: "https://github.com/bennokress/PrettyLog", .upToNextMajor(from: "1.0.0"))
]
```

## Usage

With PrettyLog you can make your print statements prettier and more useful. Just replace this ...

```swift
print("User tapped Continue Button")
```

... with this:

```
logD("User tapped Continue Button", category: .debug)
```

## Author

👤 **Benno Kress**

-   Website: [bennokress.de](https://bennokress.de)
-   Twitter: [@bennokress](https://twitter.com/bennokress)
-   Github: [@bennokress](https://github.com/bennokress)

## 🤝 Contributing

Contributions, issues and feature requests are welcome!<br />Feel free to check [issues page](https://github.com/bennokress/PrettyLog/issues?q=is%3Aissue+is%3Aopen+sort%3Aupdated-desc).

## 📝 License

Copyright © 2022 [Benno Kress](https://github.com/bennokress).<br />
This project is [MIT](https://github.com/bennokress/PrettyLog/blob/main/LICENSE) licensed.

---

_This README was generated with ❤️ by [readme-md-generator](https://github.com/kefranabg/readme-md-generator)_
