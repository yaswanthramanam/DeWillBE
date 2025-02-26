// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/access/Ownable.sol";
import "hardhat/console.sol";

contract DeWill is Ownable {
    mapping(Country => string) private countryToCurrency;

    mapping(address => Activity) private recentActivity;

    mapping(address => bool) private isStaking;

    mapping(address => Recipient[]) private inheritence;

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
        uint256 percentage;
    }

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

    function optOut() external {
        delete inheritence[msg.sender];
        delete isStaking[msg.sender];
    }

    function setCountryCurrency(
        Country _country,
        string memory _currency
    ) external onlyOwner {
        countryToCurrency[_country] = _currency;
    }

    function addRecipients(
        Recipient[] memory _recipients
    ) external {
        require(_recipients.length > 0, "Recipients cannot be empty");

        uint256 inactivityThreshold =  recentActivity[msg.sender].inactivityThreshold;

        recentActivity[msg.sender] = Activity(
            block.timestamp,
            true,
            inactivityThreshold
        );

        delete inheritence[msg.sender];
        for (uint256 i = 0; i < _recipients.length; i++) {
            inheritence[msg.sender].push(_recipients[i]);
        }
    }

    function getRecipients() public view returns (Recipient[] memory) {
        return inheritence[msg.sender];
    }

    function setStaking(bool _status) external {
        isStaking[msg.sender] = _status;
    }

    function getStaking(
    ) external view returns (bool) {
        return isStaking[msg.sender];
    }
}
