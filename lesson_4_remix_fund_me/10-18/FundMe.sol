// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

import "./PriceConverter.sol";

// constant, immutable

// before use constant: 771,931 gas
// after use constant: 751,589 gas
// constant + immutable: 728,389 gas
// constant + immutable + custom errors: 704098 gas

// see: https://soliditylang.org/blog/2021/04/21/custom-errors/
error NotOwner();

contract FundMe {
    using PriceConverter for uint256;

    // non-constant: 2,446 gas
    // constant: 347 gas
    // 2,446 * 588000000 = 1,438,248,000,000 => 0.000001438248 eth => 0.000001438248 * 1,837 => $0.0026420615759999997
    // 347 * 588000000 = 204,036,000,000 => 0.000000204036 eth => 0.000000204036 * 1,837 => $0.00037481413199999997
    uint256 public constant MINIMUM_USD = 2 * 1e18; // 2 * 1 * 10 ** 18

    address[] public funders;
    mapping(address => uint256) public addressToAmountFunded;

    // immutable: 439 gas
    // non-immutable: 2574 gas
    address public immutable i_owner;

    constructor() {
        i_owner = msg.sender;
    }

    function fund() public payable {
        require(msg.value.getConversionRate() > MINIMUM_USD, "Didn't send enough!");
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
    }

    function withdraw() public onlyOwner {
        // require(msg.sender == i_owner, "Sender is not owner!");

        for (uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++) {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }

        // reset the array
        funders = new address[](0);

        // actually withdraw the funds
        // transfer/send/call
        // // transfer
        // payable(msg.sender).transfer(address(this).balance);
        // // send
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "Send failed");
        // call
        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");
    }

    modifier onlyOwner {
        // require(msg.sender == i_owner, "Sender is not owner!");
        if (msg.sender != i_owner) {
            revert NotOwner();
        }
        _;
    }

    // What happens if someone sends this contract ETH without calling the fund function?

    // receive()
    receive() external payable {
        fund();
    }
    // fallback()
    fallback() external payable {
        fund();
    }
}

// 1. Enums
// 2. Events
// 3. Try / Catch
// 4. Function Selectors
// 5. abi.encode / decode
// 6. Hashing
// 7. Yul / Assembly
