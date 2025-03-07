// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/access/Ownable.sol";
import "hardhat/console.sol";

contract DeWill is Ownable {
    mapping(Country => string) private countryToCurrency;

    mapping(address => Activity) private recentActivity;

    mapping(address => bool) private isStaking;

    mapping(address => Will) private inheritence;

    mapping(address => Request) private requests;

    mapping(address => mapping(Currency => uint256)) private balance;

    struct Activity {
        uint256 lastActivity;
        bool isActive;
        uint256 inactivityThreshold;
    }

    struct Request {
        string email;
        string code;
        uint256 amount;
        string reason;
    }

    struct Balance {
        Currency currency;
        uint256 balance;
    }

    struct Will {
        string text;
        Recipient[] recipients;
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
        Near,
        Electroneum
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

    function addBalance(Currency _currency) external payable {
        require(msg.value > 0, "Must send ETH value greater than 0");
        require(
            _currency == Currency.Electroneum,
            "Only ETH (mapped as Electroneum) supported"
        );
        balance[msg.sender][_currency] += msg.value;
    }

    function withdrawBalance(Currency _currency, uint256 _amount) external {
        require(_amount > 0, "Withdrawal amount must be greater than 0");
        require(
            _currency == Currency.Electroneum,
            "Only ETH (mapped as Electroneum) supported"
        );
        require(
            balance[msg.sender][_currency] >= _amount,
            "Insufficient balance"
        );
        balance[msg.sender][_currency] -= _amount;
        (bool sent, ) = payable(msg.sender).call{value: _amount}("");
        require(sent, "Failed to send ETH");
    }

    function getBalance(Currency _currency) external view returns (uint256) {
        return balance[msg.sender][_currency];
    }

    function addRecipients(Will memory _will) external {
        Recipient[] memory _recipients = _will.recipients;

        uint256 inactivityThreshold = recentActivity[msg.sender]
            .inactivityThreshold;

        recentActivity[msg.sender] = Activity(
            block.timestamp,
            true,
            inactivityThreshold
        );

        address[] memory addresses = new address[](_recipients.length);

        for (uint256 i = 0; i < _recipients.length; i++) {
            address recipientAddr = _recipients[i].addr;
            for (uint256 j = 0; j < i; j++) {
                require(
                    addresses[j] != recipientAddr,
                    "Duplicate recipients found"
                );
            }

            addresses[i] = recipientAddr;
        }

        delete inheritence[msg.sender];
        inheritence[msg.sender] = _will;
    }

    function getRecipients() public view returns (Recipient[] memory) {
        return inheritence[msg.sender].recipients;
    }

    function getWill() public view returns (Will memory) {
        return inheritence[msg.sender];
    }

    function setStaking(bool _status) external {
        isStaking[msg.sender] = _status;
    }

    function getStaking() external view returns (bool) {
        return isStaking[msg.sender];
    }

    function removeRecipients() external {
        delete inheritence[msg.sender];
        delete isStaking[msg.sender];
    }
}
