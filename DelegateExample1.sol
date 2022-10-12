// SPDX-License-Identifier: MIT

pragma solidity ^0.6.6;

contract LogicContract {
  address public returnedAddress;
  event contractAddress(address returnedAddress );
  
  function print_address() public  returns(address){
    returnedAddress = address(this); 
    emit contractAddress(returnedAddress);
  }
}

contract CallingContract { 
  address public returnedAddress; 
  address public logic_pointer = address(new LogicContract());

  function print_my_delgate_address() public returns(address){
    returnedAddress = address(logic_pointer.delegatecall(abi.encodeWithSignature("print_address()")));
  }
  function print_my_call_address() public returns(address){
    logic_pointer.call(abi.encodeWithSignature("print_address()"));
  }
}	

// 0xddaAd340b0f1Ef65169Ae5E41A8b10776a75482d