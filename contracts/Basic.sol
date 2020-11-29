pragma solidity >=0.5.0 <0.6.0;

import "./Math.sol";
import "./Ownable.sol";


/// @title Basic logic for apple and banana
contract Basic is Math, Ownable {
    uint internal coef = 10**24;

    uint public totalApple = 0;
    uint public totalBanana = 0;

    /// @notice Gets the total number of apple
    /// @return The number of apple
    function getTotalApple() public view returns (uint) {
        return totalApple;
    }

    /// @notice Gets the total number of banana
    /// @return The number of banana
    function getTotalBanana() public view returns (uint) {
        return totalBanana;
    }

    /// @notice Gets the total capitalization of all apples and bananas
    /// @return The capitalization of all apples and bananas
    function getCapitalization() public view returns (uint) {
        return _calcCapitalization(totalApple, totalBanana);
    }

    /// @dev Calculates capitalization by given number of apples and bananas
    function _calcCapitalization(uint _countApple, uint _countBanana) internal view returns (uint) {
        require(_countApple >= 0);
        require(_countBanana >= 0);
        return sqrt(_countApple * _countBanana * coef);
    }

    /// @dev Increments apple
    function _incApple(uint _apple) internal {
        totalApple += _apple;
    }

    /// @dev Decrements apple
    function _decApple(uint _apple) internal {
        require(totalApple >= _apple);
        totalApple -= _apple;
    }

    /// @dev Increments banana
    function _incBanana(uint _banana) internal {
        totalBanana += _banana;
    }

    /// @dev Decrements banana
    function _decBanana(uint _banana) internal {
        require(totalBanana >= _banana);
        totalBanana -= _banana;
    }
}
