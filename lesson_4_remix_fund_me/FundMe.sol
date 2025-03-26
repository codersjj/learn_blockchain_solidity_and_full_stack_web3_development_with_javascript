// Get funds from users
// Withdraw funds
// Set a minimum funding value in USD

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

// import "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

// interface AggregatorV3Interface {
//   function decimals() external view returns (uint8);

//   function description() external view returns (string memory);

//   function version() external view returns (uint256);

//   function getRoundData(
//     uint80 _roundId
//   ) external view returns (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound);

//   function latestRoundData()
//     external
//     view
//     returns (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound);
// }

contract FundMe {
    int256 public number;
    uint256 public minimumUsd = 2 * 1e18; // 2 * 1 * 10 ** 18

    address[] public funders;
    mapping(address => uint256) public addressToAmountFunded;

    function fund() public payable {
        // want to fund a minimum fund amount in USD
        // 1. How do we send ETH to this contract?
        number = 5;
        // require(msg.value > 1e18, "Didn't send enough!"); // 1e18 = 1 * 10 ** 18 = 1000000000000000000
        require(getConversionRate(msg.value) > minimumUsd, "Didn't send enough!");

        // What is reverting?
        // undo any actions before, and send remaining gas back


        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
    }

    function getPrice() public view returns (uint256) {
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

    function getVersion() public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        return priceFeed.version();
    }

    function getConversionRate(uint256 ethAmount) public view returns (uint256) {
        uint256 ethPrice = getPrice();

        // 2000_000000000000000000 ETH / USD price
        // 1_000000000000000000 ETH amount

        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
        return ethAmountInUsd;
    }

    // function withdraw(){}
}