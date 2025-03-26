// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

contract SimpleStorage {
    // bool, uint, int, address, bytes
    // bool hasFavoriteNumber = true;
    // uint256 favoriteNumber = 5;
    // int256 favoriteInt = -5;
    // string favoriteNumberInText = "Five";
    // address myAddress = 0xe560cA09958bDB05b776676351114811Ad101e47;
    // bytes32 favoriteBytes = "cat";

    // This get initialized to zero!
    uint256 public favoriteNumber;
    // People public people = People({ favoriteNumber: 2, name: 'Ally' });
    // People public people2 = People({ favoriteNumber: 5, name: 'Alan' });

    struct People {
        uint256 favoriteNumber;
        string name;
    }

    // uint256 public favoriteNumbersList;
    People[] public people;
    // People[3] public people;

    mapping (string => uint256) public nameToFavoriteNumber;

    function store(uint256 _favoriteNumber) public {
        favoriteNumber = _favoriteNumber;
        // favoriteNumber = favoriteNumber + 1;
        // uint256 testVar = 5;
        retrieve();
    }

    // function something() public {
    //     testVar = 6;
    // }

    function retrieve() public view returns(uint256) {
        return favoriteNumber;
    }

    function add() public pure returns (uint256) {
        return 1 + 1;
    }

    // calldata, memory, storage
    function addPerson(string memory _name, uint _favoriteNumber) public {
        // people.push(People(_favoriteNumber, _name));

        // People memory newPerson = People({ name: _name, favoriteNumber: _favoriteNumber });
        People memory newPerson = People(_favoriteNumber, _name);
        people.push(newPerson);

        // _name = "hhh";

        nameToFavoriteNumber[_name] = _favoriteNumber;
    }
}

// 0xd9145CCE52D386f254917e481eB44e9943F39138
// 0x84eF5d8720Bb6a6b1C7d7c555760700EFac8FDD5