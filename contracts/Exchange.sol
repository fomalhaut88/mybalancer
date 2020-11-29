pragma solidity >=0.5.0 <0.6.0;

import "./ChargeWithdraw.sol";


contract Exchange is ChargeWithdraw {
    uint exchangeInterest = 0;


    /* Estimate */

    function estimateBananaForApple(uint _apple) public view returns (uint) {
        require(getTotalApple() >= _apple);
        return _apple * getTotalBanana() / (getTotalApple() - _apple);
    }

    function estimateAppleForBanana(uint _banana) public view returns (uint) {
        require(getTotalBanana() >= _banana);
        return _banana * getTotalApple() / (getTotalBanana() - _banana);
    }


    /* Exchange */

    function exchangeAppleForBanana(uint _apple) external payable {
        uint _banana = estimateBananaForApple(_apple);
        require(msg.value == exchangeInterest * estimateChargeBanana(_banana));
        _decApple(msg.sender, _apple);
        _incBanana(msg.sender, _banana);
    }

    function exchangeBananaForApple(uint _banana) external payable {
        uint _apple = estimateAppleForBanana(_banana);
        require(msg.value == exchangeInterest * estimateChargeApple(_apple));
        _decBanana(msg.sender, _banana);
        _incApple(msg.sender, _apple);
    }
}
