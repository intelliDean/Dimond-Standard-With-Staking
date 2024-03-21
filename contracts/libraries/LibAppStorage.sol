pragma solidity ^0.8.0;

library LibAppStorage {
    uint256 constant APY = 120;

    event Transfer(address indexed _from, address indexed _to, uint256 _value);

    struct UserStake {
        uint256 stakedTime;
        uint256 amount;
    }

    struct Layout {
        //ERC20
        string name;
        string symbol;
        uint256 totalSupply;
        uint8 decimals;
        mapping(address => uint256) balances;
        mapping(address => mapping(address => uint256)) allowances;
        //STAKING
        address rewardToken;
        uint256 rewardRate;
        mapping(address => UserStake) userDetails;
        address[] stakers;
    }

    /*todo: This is here because func _transferFrom is writing to storage,
       hence we bring the storage here cos library do not have state variable */
    function layoutStorage() internal pure returns (Layout storage l) {
        assembly {
            l.slot := 0
        }
    }

    //TODO: this is here because this function is shared by many facet, hence we made it DRY
    function _transferFrom(address _from, address _to, uint256 _amount) internal {

        Layout storage l = layoutStorage();
        uint256 fromBalances = l.balances[msg.sender];

        require(fromBalances >= _amount, "ERC20: Not enough tokens to transfer");

        l.balances[_from] = fromBalances - _amount;
        l.balances[_to] += _amount;

        emit Transfer(_from, _to, _amount);
    }
}
