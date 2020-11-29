pragma solidity >=0.5.0 <0.6.0;


/// @title Contract owner implementation
contract Ownable {
    address private owner;

    /// @notice Set owner on deploy
    constructor() internal {
        owner = msg.sender;
    }

    /// @notice Modifier for function to call by owner only
    modifier ownerOnly() {
        require(msg.sender == owner);
        _;
    }

    /// @notice Changes the contract owner
    /// @param _newOwner Address of new owner
    function changeContractOwner(address _newOwner) external ownerOnly {
        owner = _newOwner;
    }

    /// @notice Transfers fund of the contract to the owner
    /// @param _value Fund to transfer
    function transferFromContract(uint _value) external ownerOnly {
        msg.sender.transfer(_value);
    }
}
