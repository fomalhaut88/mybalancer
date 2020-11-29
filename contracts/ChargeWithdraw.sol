pragma solidity >=0.5.0 <0.6.0;

import "./Basic.sol";


contract ChargeWithdraw is Basic {
    uint chargeInterest = 0;
    uint withdrawInterest = 0;


    /* Estimate */

    function estimateChargeApple(uint _apple) public view returns (uint) {
        return _calcCapitalization(getTotalApple() + _apple, getTotalBanana()) - getCapitalization();
    }

    function estimateChargeBanana(uint _banana) public view returns (uint) {
        return _calcCapitalization(getTotalApple(), getTotalBanana() + _banana) - getCapitalization();
    }

    function estimateWithdrawApple(uint _apple) public view returns (uint) {
        return getCapitalization() - _calcCapitalization(getTotalApple() - _apple, getTotalBanana());
    }

    function estimateWithdrawBanana(uint _banana) public view returns (uint) {
        return getCapitalization() - _calcCapitalization(getTotalApple(), getTotalBanana() - _banana);
    }


    /* Change and withdraw */

    function chargeApple(uint _apple) external payable {
        uint estimated = estimateChargeApple(_apple);
        require(msg.value == (1 + chargeInterest) * estimated);
        _incApple(msg.sender, _apple);
    }

    function chargeBanana(uint _banana) external payable {
        uint estimated = estimateChargeBanana(_banana);
        require(msg.value == (1 + chargeInterest) * estimated);
        _incBanana(msg.sender, _banana);
    }

    function withdrawApple(uint _apple) external payable {
        uint estimated = estimateWithdrawApple(_apple);
        require(msg.value == withdrawInterest * estimated);
        _decApple(msg.sender, _apple);
        msg.sender.transfer(estimated);
    }

    function withdrawBanana(uint _banana) external payable {
        uint estimated = estimateWithdrawBanana(_banana);
        require(msg.value == withdrawInterest * estimated);
        _decBanana(msg.sender, _banana);
        msg.sender.transfer(estimated);
    }
}
