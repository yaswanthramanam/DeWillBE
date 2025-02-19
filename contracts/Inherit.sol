// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Inherit is Ownable {

    mapping(Country => string) public countryToCurrency;

    mapping(address => Activity) public activity;

    mapping(address => bool) public isStaking;

    struct Activity {
         uint256 lastActivity;
         bool isActive;
         uint256 inactivityThreshold;
    }

    enum Country {
        India,
        UnitedStates,
        UnitedKingdom,
        Japan,
        Canada,
        Australia,
        China,
        Russia,
        Switzerland,
        EU
    }

    enum Gender {
        Male,
        Female,
        Others
    }
    enum Currency {
        ETH,
        Sonic,
        Near
    }

    struct Recipient {
        address addr;
        string firstName;
        string lastName;
        string primaryEmail;
        string secondaryEmail;
        Currency currency;
        Country country;
        uint age;
        Gender gender;
    }

    mapping(address => Recipient[]) public inheritence;

    constructor() Ownable(msg.sender) {
        countryToCurrency[Country.India] = "INR";
        countryToCurrency[Country.UnitedStates] = "USD";
        countryToCurrency[Country.UnitedKingdom] = "GBP";
        countryToCurrency[Country.Japan] = "JPY";
        countryToCurrency[Country.Canada] = "CAD";
        countryToCurrency[Country.Australia] = "AUD";
        countryToCurrency[Country.China] = "CNY";
        countryToCurrency[Country.Russia] = "RUB";
        countryToCurrency[Country.Switzerland] = "CHF";
    }

    function optOut(address _address) external onlyOwner {
        delete inheritence[_address];
    }

    function setCountryCurrency(
        Country _country,
        string memory _currency
    ) external onlyOwner {
        countryToCurrency[_country] = _currency;
    }

    function addRecipients(Recipient[] memory _recipients, uint256 _inactivityThreshold) external {
        require(_recipients.length > 0, "Recipients cannot be empty");
        activity[msg.sender]= Activity(block.timestamp, true, _inactivityThreshold);
        Recipient[] storage existingRecipients = inheritence[msg.sender];
        for (uint256 i = 0; i < _recipients.length; i++) {
            bool exists = false;
            for (uint256 j = 0; j < existingRecipients.length; j++) {
                if (existingRecipients[j].addr == _recipients[i].addr) {
                    exists = true;
                    break;
                }
            }
            if (!exists) {
                existingRecipients.push(_recipients[i]);
            }
        }
    }

    function getRecipients() external view returns (Recipient[] memory) {
        return inheritence[msg.sender];
    }

    // function updateActivity(address _address) external {
        
    // }

    // function checkAddress(address _address) external returns (bool) {

    //     if(activity[_address].lastActivity> activity[_address].inactivityThreshold){

    //     }
    // }

    function setStaking(address _address, bool _status) external {
        isStaking[_address] = _status;
    }
}
