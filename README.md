# Robots for Testing Different Algorithms

This repository contains a collection of trading robots implemented in MQL4 and MQL5 designed to test various algorithmic trading strategies. These robots utilize different combinations of indicators to explore a wide range of trading scenarios. The primary indicators and components used in these strategies include:

1. Baseline
2. Crosslines
3. ATR (Average True Range)
4. Confirmation
5. Exit
6. Continuation

## Table of Contents

- [Installation](#installation)
- [Usage](#usage)
- [Indicators](#indicators)
- [Algorithms](#algorithms)
- [Contributing](#contributing)
<!-- - [License](#license) -->

## Installation

1. Clone the repository to your local machine:
   ```sh
   git clone https://github.com/santush87/MetaTrader4-Robots.git
   ```
2. Copy the relevant files to your MetaTrader Experts directory:

- For MQL4: MetaTrader 4/MQL4/Experts/
- For MQL5: MetaTrader 5/MQL5/Experts/

3. Restart MetaTrader to load the new robots.

## Usage

1. Open MetaTrader.
2. Navigate to the Navigator panel.
3. Expand the Expert Advisors section.
4. Drag and drop the desired robot onto a chart.
5. Configure the input parameters according to your testing needs.
6. Enable Algo Trading in MetaTrader to start the robot.

# Indicators

## Baseline

The Baseline indicator is used to establish a reference point or average price level. It is often a moving average or a similar smoothing indicator.

## Crosslines

Crosslines indicators identify points where two lines (such as moving averages) intersect, indicating potential buy or sell signals.

## ATR (Average True Range)

The ATR indicator measures market volatility by calculating the average range between the high and low prices over a specified period.

## Confirmation

The Confirmation indicator is used to validate signals from other indicators, reducing the likelihood of false positives.

## Exit

Exit indicators determine optimal points to close a trade, securing profits or minimizing losses.

## Continuation

Continuation indicators help identify the persistence of a trend, indicating whether to hold a position or expect a reversal.

## Algorithms

Each robot combines the above indicators in different ways to form complete trading algorithms. These combinations can be simple (using just one or two indicators) or complex (using all six indicators).

### Examples

- BaselineRobot: Utilizes only the Baseline indicator for entry and exit signals.
- CrosslinesRobot: Trades based on intersections of moving averages or similar lines.
- ATRRobot: Incorporates the ATR for volatility-based trading decisions.
- ConfirmationRobot: Uses additional indicators to confirm signals from the primary indicator.
- ExitRobot: Focuses on optimal trade exit strategies.
- ContinuationRobot: Analyzes the strength and continuation of trends.
- FullAlgorithmRobot: Integrates all six indicators into a comprehensive trading strategy.

## Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository.
2. Create a new branch (git checkout -b feature/YourFeature).
3. Commit your changes (git commit -am 'Add new feature').
4. Push to the branch (git push origin feature/YourFeature).
5. Open a Pull Request.
