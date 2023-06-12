## Converter

Converter is a SwiftUI currency converter app for iOS and macOS using Catalyst to work with the status bar. MVVM architecture.![platforms](https://img.shields.io/badge/platforms-iPhone%20%7C%20iPad%20%7C%20macOS-lightgrey)  [![Минимальная версия iOS](https://img.shields.io/badge/iOS-16.0-blue.svg)](https://developer.apple.com/ios/) [![Минимальная версия iPadOS](https://img.shields.io/badge/iPadOS-16.0-blue.svg)](https://developer.apple.com/ipados/) [![Минимальная версия Mac Catalyst](https://img.shields.io/badge/MacCatalyst-13.0-blue.svg)](https://developer.apple.com/documentation/uikit/mac_catalyst) [![Минимальная версия macOS](https://img.shields.io/badge/macOS-12.0-blue.svg)](https://developer.apple.com/macos/)

## Demo
|                             iOS                              |                            Widget                            |                            MacOS                             |                          Status bar                          |
| :----------------------------------------------------------: | :----------------------------------------------------------: | :----------------------------------------------------------: | :----------------------------------------------------------: |
| <img src="./GIF/iOS.gif" alt="isolated" width="150"/> | <img src="./GIF/widget.gif" alt="isolated" width="150"/> | <img src="./GIF/macOS.gif" width="300"/> | <img src="./GIF/statusBar.gif" alt="isolated" width="200"/> |



## Key Features

- **Currency Conversion**: Convert between various currencies with up-to-date exchange rates.
- **iOS and macOS Support**: The app is compatible with iOS 16.0 and later, iPadOS 16.0 and later, Mac Catalyst 13.0 and later, and macOS 12.0 and later.
- **Catalyst and Status Bar**: Take advantage of Mac Catalyst to bring your app to macOS while providing a convenient status bar interface for quick access to currency conversion.
- **API Integration**: Fetch exchange rate data from  <a href="https://currate.ru">API Exchange rates</a> to ensure accurate currency conversion.
- **API Key**: Generate your own API key to access the currency exchange rate data. Please note that the API has a limit of 1000 requests per day.

## Getting Started

To get started with Converter Currency Converter, follow these steps:

1. Clone the repository:

   ```
   shellCopy code
   git clone https://github.com/petrenkodaria/converter.git
   ```

2. Open the Xcode project file.

3. Replace the  <a href="https://currate.ru/account/">API key</a>  in the project with your API key in the CurrencyViewModel file.

4. Build and run the app on your iOS or macOS device or simulator.

## Requirements

- iOS 16.0 and later
- iPadOS 16.0 and later
- Mac Catalyst 13.0 and later
- macOS 12.0 and later

## Contributing

Contributions to Converter Currency Converter are welcome! If you find any issues or want to suggest improvements, please submit a pull request or open an issue on the [GitHub repository](https://github.com/petrenkodaria/converter).

## License

Converter is available under the MIT license. See the [LICENSE](./LICENSE) file for more details.

## Contact

For any inquiries or feedback, feel free to reach out to us at [petrenkodariarom@icloud.com](mailto:petrenkodariarom@icloud.com).

Happy currency converting!
