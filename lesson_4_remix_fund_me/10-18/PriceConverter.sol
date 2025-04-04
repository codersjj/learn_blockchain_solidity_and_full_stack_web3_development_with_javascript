// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

library PriceConverter {

    function getPrice() internal view returns (uint256) {
        // Whenever we work with a contract, we need:
        // 1. ABI
        // 2. Address 0x694AA1769357215DE4FAC081bf1f309aDC325306   Aggregator: ETH / USD
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        (,int256 answer,,,) = priceFeed.latestRoundData();

        // ETH in terms of USD
        // 2000.00000000
        // 2000_00000000

        return uint(answer * 1e10);
    }

    function getVersion() internal view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        return priceFeed.version();
    }

    function getConversionRate(uint256 ethAmount) internal view returns (uint256) {
        uint256 ethPrice = getPrice();

        // 2000_000000000000000000 ETH / USD price
        // 1_000000000000000000 ETH amount

        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
        return ethAmountInUsd;
    }
}