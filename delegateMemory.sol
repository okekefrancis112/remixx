pragma solidity 0.6.6;

 
contract LogicContract {
  uint public a;
 
  function set(uint256 val) public {
    a = val;
  }
}


contract CallingContract {
  uint256 public b = 5; 
  uint256 public a = 5;
  address logic_pointer = address(new LogicContract());
 
 
  function setA(uint val) public {
    // Note: the return value of delegatecall should be checked
    logic_pointer.delegatecall(abi.encodeWithSignature("set(uint256)", val));
  }
}
Footer
