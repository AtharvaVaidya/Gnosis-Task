#  Gnosis Take Home Test

## Requirements

1. Xcode 11.3
2. Carthage

## How to Run

1. Install Carthage if it isn't installed already. Follow these steps [here](https://github.com/Carthage/Carthage#installing-carthage).
2. Go to terminal in the top level folder, and run `carthage update --platform iOS`.
3. Open `Gnosis-Task.xcodeproj`.
4. Clean the project by pressing `Command-Shift-K`
5. Run the app by pressing `Command - R`

## Notes 

1. The app follows the MVVM pattern, aided by Coordinators.
2. The project follows SOLID priniciples as much as possible. The views are dependency-injectable, and objects have a single defined responsibility.
3. Although I haven't written any tests because of time constraints, the app is structured to be completely testable.

