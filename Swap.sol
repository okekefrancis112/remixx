// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;
import "./IERC20.sol";



contract Swap{
    IERC20 token;


    struct Swapped{
        address _to;
        address fromToken;
        address toToken;
        uint amountIN;
        uint amountOut;
        bool status;
    }
    mapping(uint => Swapped) _swap;
    uint ID = 1;


    function createSwap(address _fromToken, address _toToken, uint amountIn, uint DesiredAmountOut) public {
        require(IERC20(_fromToken).transferFrom(msg.sender, address(this),amountIn), "transfer Failed");
        Swapped storage SW = _swap[ID];
        SW.fromToken = _fromToken;
        SW.toToken = _toToken;
        SW.amountIN = amountIn;
        SW.amountOut = DesiredAmountOut;
        SW.status = true;

        ID++;
    }

    function executeSwap(uint _ID) public {
        Swapped storage SW = _swap[_ID];
        assert(SW.status);
        uint _amountOUT = SW.amountOut;
        require(IERC20(SW.toToken).transferFrom(msg.sender, address(this),_amountOUT), "transfer Failed");
        SW.status = false;
        IERC20(SW.fromToken).transfer(msg.sender, SW.amountIN);
        IERC20(SW.toToken).transfer(SW._to, _amountOUT);

    }

}