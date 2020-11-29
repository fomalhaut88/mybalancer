pragma solidity >=0.5.0 <0.6.0;

import "./Math.sol";


contract Basic is Math {
    uint internal coef = 10**24;

    uint public totalApple = 0;
    uint public totalBanana = 0;

    mapping (address => uint) public appleMap;
    mapping (address => uint) public bananaMap;


    /* Get */

    function getApple() public view returns (uint) {
        return appleMap[msg.sender];
    }

    function getBanana() public view returns (uint) {
        return bananaMap[msg.sender];
    }

    function getTotalApple() public view returns (uint) {
        return totalApple;
    }

    function getTotalBanana() public view returns (uint) {
        return totalBanana;
    }

    function getCapitalization() public view returns (uint) {
        return _calcCapitalization(getTotalApple(), getTotalBanana());
    }

    function _calcCapitalization(uint _totalApple, uint _totalBanana) internal view returns (uint) {
        require(_totalApple >= 0);
        require(_totalBanana >= 0);
        return sqrt(_totalApple * _totalBanana * coef);
    }


    /* Increment and decrement */

    function _incApple(address _owner, uint _apple) internal {
        appleMap[_owner] += _apple;
        totalApple += _apple;
    }

    function _decApple(address _owner, uint _apple) internal {
        require(totalApple >= _apple);
        require(appleMap[_owner] >= _apple);
        appleMap[_owner] -= _apple;
        totalApple -= _apple;
    }

    function _incBanana(address _owner, uint _banana) internal {
        bananaMap[_owner] += _banana;
        totalBanana += _banana;
    }

    function _decBanana(address _owner, uint _banana) internal {
        require(totalBanana >= _banana);
        require(bananaMap[_owner] >= _banana);
        bananaMap[_owner] -= _banana;
        totalBanana -= _banana;
    }
}
