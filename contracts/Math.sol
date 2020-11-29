pragma solidity >=0.5.0 <0.6.0;


contract Math {
    function sqrt(uint x) internal pure returns (uint) {
        uint r1 = x;
        uint r2 = 1;
        while (r1 > r2) {
            r1 = (r1 + r2) / 2;
            r2 = x / r1;
        }
        return r1;
    }
}
