// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract MysteryBoxAuction {
    address contractOwner;
    uint auctionStartTime;
    bool auctionInProgress;
    address topBidder;
    uint topBid;

    address[] authorizedBidders;
    mapping (address => uint16) winnings;

    event topBidIncreased(address bidder, uint bidAmount);
    event auctionStarted(uint timestamp);
    event auctionResult(address winner, uint bidAmount);

    function addAuthorizedBidder(address _authUser) private {
        authorizedBidders.push(_authUser);
    }
    
    // no return specified 
    function getPrizePool() public view returns(uint) {
        return address(this).balance;
    }
    
    function mysteryPrize() private view returns (uint) {
        uint randomHash = uint(keccak256(abi.encode(block.difficulty, block.timestamp)));
        return (randomHash % address(this).balance) + 100000000000000000;
    } 

    function startAuction() public {
        require(!auctionInProgress, "Auction is in progress already!");
        require(address(this).balance >= 1000000000000000000, "Prize pool must equal or exceed 1 ETH before an auction can start.");
        auctionStartTime = block.timestamp;
        emit auctionStarted(auctionStartTime);
    }

    function endAuction() public {
        require(block.number > auctionStartTime + 7 days, "Auction has not completed.");
        // type clashing (uint 256 and 16 )
        winnings[topBidder] = uint16(mysteryPrize());
        emit auctionResult(topBidder, topBid);
    }

    function bid() payable external {
        require(auctionInProgress, "There is no auction in progress!");
        topBidder = tx.origin;
        topBid = msg.value;
    }

    function withdrawWinnings(address _receive) payable external {
        uint totalWinnings = winnings[tx.origin];
        // using .send instead of .transfer to send earnings
        // payable(_receive).send(totalWinnings);
        payable(_receive).transfer(totalWinnings);
        // incompatible types (uint 16 and 256)
        winnings[tx.origin] -= uint16(totalWinnings);
    }
}