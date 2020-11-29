pragma solidity >=0.5.0 <0.6.0;

import "./Investor.sol";


/// @title Exchange apple and banana implementation
contract Exchange is Investor {
    uint exchangeInterest = 1;  // 0.1%
    uint investorInterest = 990;  // 99%
    uint interestModulus = 1000;

    /// @notice Estimates the value of the number of apple
    /// @param _apple The number of apple
    /// @return _value The estimated value
    function estimateValueOfApple(uint _apple) public view returns (uint) {
        return getCapitalization() * _apple / totalApple;
    }

    /// @notice Estimates the value of the number of banana
    /// @param _banana The number of banana
    /// @return _value The estimated value
    function estimateValueOfBanana(uint _banana) public view returns (uint) {
        return getCapitalization() * _banana / totalBanana;
    }

    /// @notice Calculates the number of banana by given number of apple according to their rate
    /// @param _apple The number of apple
    /// @return _value The estimated number of banana
    function estimateBananaInApple(uint _apple) public view returns (uint) {
        require(totalApple >= _apple);
        return _apple * totalBanana / (totalApple - _apple);
    }

    /// @notice Calculates the number of apple by given number of banana according to their rate
    /// @param _banana The number of banana
    /// @return _value The estimated number of apple
    function estimateAppleInBanana(uint _banana) public view returns (uint) {
        require(totalBanana >= _banana);
        return _banana * totalApple / (totalBanana - _banana);
    }

    /// @notice Performs the exchange from apples to bananas
    /// @param _apple The number of apple
    function exchangeAppleForBanana(uint _apple) external payable {
        require(msg.value == estimateValueOfApple(_apple) * exchangeInterest / interestModulus);
        uint _banana = estimateBananaInApple(_apple);
        _decApple(_apple);
        _incBanana(_banana);
        _payDividends(msg.value * investorInterest / interestModulus);
    }

    /// @notice Performs the exchange from bananas to apples
    /// @param _banana The number of banana
    function exchangeBananaForApple(uint _banana) external payable {
        require(msg.value == estimateValueOfBanana(_banana) * exchangeInterest / interestModulus);
        uint _apple = estimateAppleInBanana(_banana);
        _decBanana(_banana);
        _incApple(_apple);
        _payDividends(msg.value * investorInterest / interestModulus);
    }
}
