pragma solidity >=0.5.0 <0.6.0;

import "./Basic.sol";


/// @title Logic for investment
contract Investor is Basic {
    /// @notice Mapping from investor to his investment
    mapping (address => uint) public investorToValue;

    /// @notice Array of investors
    address payable[] public investors;

    event Charge(address, uint);
    event Withdraw(address, uint);

    /// @notice Shows investment of investor given as msg.sender
    /// @return The value of investment
    function showInvestment() external view returns (uint) {
        return investorToValue[msg.sender];
    }

    /// @notice Shows the investment for charge (value) and the corresponding number of apple and banana
    /// @param _value The desired value to invest
    /// @return Calculated numbers for value, apple, banana
    function showCharge(uint _value) public view returns (uint value, uint apple, uint banana) {
        require(_value > 0);
        (apple, banana) = _getOptimalAppleBanana(_value);
        require((apple > 0) && (banana > 0));
        value = _estimateCharge(apple, banana);
    }

    /// @notice Shows the investment for withdraw (value) and the corresponding number of apple and banana
    /// @param _value The desired value to withdraw
    /// @return Calculated numbers for value, apple, banana
    function showWithdraw(uint _value) public view returns (uint value, uint apple, uint banana) {
        require(_value > 0);
        (apple, banana) = _getOptimalAppleBanana(_value);
        require((apple > 0) && (banana > 0));
        value = _estimateWithdraw(apple, banana);
    }

    /// @notice Invests into apples and bananas
    function charge() external payable {
        (uint value, uint apple, uint banana) = showCharge(msg.value);
        _incApple(apple);
        _incBanana(banana);
        _createInvestment(msg.sender, value);
        emit Charge(msg.sender, value);
    }

    /// @notice Withdraws the investment
    /// @param _value The desired value to withdraw
    function withdraw(uint _value) external payable {
        (uint value, uint apple, uint banana) =  showWithdraw(_value);
        _decApple(apple);
        _decBanana(banana);
        _deleteInvestment(msg.sender, value);
        msg.sender.transfer(value);
        emit Withdraw(msg.sender, value);
    }

    /// @dev Calculates optimal number of apple and banana
    function _getOptimalAppleBanana(uint _value) internal view returns (uint apple, uint banana) {
        if ((totalApple > 0) && (totalBanana > 0)) {
            apple = sqrt(totalApple * _value * _value / (totalBanana * coef));
            banana = sqrt(totalBanana * _value * _value / (totalApple * coef));
        } else {
            if ((totalApple == 0) && (totalBanana == 0)) {
                apple = banana = sqrt(_value * _value / coef);
            } else {
                apple = banana = 0;
            }
        }
    }

    /// @dev Estimates the value to charge by given apple and banana
    function _estimateCharge(uint _apple, uint _banana) internal view returns (uint) {
        return _calcCapitalization(totalApple + _apple, totalBanana + _banana) - getCapitalization();
    }

    /// @dev Estimates the value to withdraw by given apple and banana
    function _estimateWithdraw(uint _apple, uint _banana) internal view returns (uint) {
        return getCapitalization() - _calcCapitalization(totalApple - _apple, totalBanana - _banana);
    }

    /// @dev Adds investment to investor
    function _createInvestment(address payable _investor, uint _value) internal {
        if (investorToValue[_investor] == 0) {
            investors.push(_investor);
        }
        investorToValue[_investor] += _value;
    }

    /// @dev Removes investment from investor
    function _deleteInvestment(address payable _investor, uint _value) internal {
        require(investorToValue[_investor] >= _value);
        investorToValue[_investor] -= _value;
    }

    /// @dev Sends dividends from given value to all investors accorting to their investments
    function _payDividends(uint _value) internal {
        uint capitalization = getCapitalization();
        for (uint i = 0; i < investors.length; i++) {
            address payable investor = investors[i];
            uint dividend = investorToValue[investor] * _value / capitalization;
            if (dividend > 0) {
                investor.transfer(dividend);
            }
        }
    }
}
