// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;
import { IERC20 } from "./utils/IERC20.sol";
import { IERC721 } from "./utils/IERC721.sol";




/// @title This is an auction contract for NFTs (auction would be carried out using the token of the protocol)
/// @author team unicorn
/// @notice this bid never stops until it is ended
contract Auction {
    event Start(IERC721 indexed _nft, uint _nftId, uint startingBid);
    event End(address indexed highestBidder, uint highestBid);
    event Bid(address indexed sender, uint amount);
    event Withdraw(address indexed bidder, uint amount);

    // Declaration of constants and varibles
    IERC20 public constant protocol_token; // this is the address of the protocol's token all finance stuff would be done using this token
    address payable public seller;
    bool public started;
    bool public ended;
    IERC721 public nft;
    uint public nftId;
    uint public highestBid;
    address public highestBidder;
    mapping(address => uint) public bids;
    bool initailized;





    function initailize(address _seller, IERC20 _protocol_token) public {
        seller = _seller;
        protocol_token = _protocol_token;
    }



    // CUSTOM ERRORS


    /// Bid has already started
    error AlreadyStarted();

    /// You are not the seller
    error NotSeller();

    /// Bid has not started
    error NotStarted();

    /// Bid has ended
    error HasEnded();

    /// You can't bid if you are the 
    error YouAreTheHighestBidder();

    /// Your bid is lower then the highest bid
    error BidLowerThanHighestBid();

    /// Something went wrong during withdrawal
    error WithdrawError();

    /// You are not allowed to withdraw
    error CannotWithdraw();

    /// Bid has not started
    error BidHasNotStarted();

    /// Bid has ended
    error BidHasEnded();

    /// Contract not init
    error NotInitialized();



    modifier isInitialized() {
        if(!initailized) {
            revert NotInitialized();
        }
        _;
    }

    
    /// @dev this function start the biding process (NOTE: this bid would run unitl the end function is called)
    /// @param _nft: this is the nft contract address
    /// @param _nftId: this is the nftId
    /// @param startingBid: this is how much blockchain native token the seller is willing to start the bid at
    function start(IERC721 _nft, uint _nftId, uint startingBid) 
        external 
        isInitialized
    {
        if(started) {
            revert AlreadyStarted();
        }

        if(msg.sender != seller) {
            revert NotSeller();
        }
        
        highestBid = startingBid;

        nft = _nft;
        nftId = _nftId;


        // @dev transfering the ownership of the nft to the contract (so the bid can holder), fisrt from the frontend, the user must give the contract the authorization to spend NFTs from he/her wallet (NOTE: if this is not successful, it would be reverted)
        nft.transferFrom(msg.sender, address(this), nftId);

        started = true;

        emit Start(_nft, _nftId, startingBid);
    }

    /// @dev other user can make their bid here
    function bid(uint256 _amount) external payable {
        if(!started) {
            revert NotStarted(); // users cannot bid on a product that has not started
        }


        // 1. Making sure the sender is not the current highest bidder
        if(msg.sender == highestBidder) {
            revert YouAreTheHighestBidder();
        } // passing the condition above means that the msg.sender is not the highest bidder

        

        // getting the users current bid in case the user already have been out bidded
        
        // this would return just msg.value if the user have not bidded before, this return must be higher than the highest bid
        uint currentUserBid = bids[msg.sender] + _amount;

        if(currentUserBid < highestBid) {
            revert BidLowerThanHighestBid();
        }

        // making the transfer and updating balance
        bool sent = IERC20(protocol_token).transferFrom(msg.sender, address(this));
        bids[msg.sender] += _amount;

        highestBid = bids[msg.sender];
        highestBidder = msg.sender;

        emit Bid(highestBidder, highestBid);
    }


    /// @dev a user can only withdraw is the user is not the highest bidder
    function withdraw() external payable {
        if(msg.sender == highestBidder) {
            revert CannotWithdraw();
        }

        bids[msg.sender] = 0;
        bool sent = IERC20(protocol_token).transfer(msg.sender, bids[msg.sender]);

        if(!sent) {
            revert WithdrawError();
        }

        emit Withdraw(msg.sender, bids[msg.sender]);
    }


    /// @dev This function would transfer the nft to the higher bider of the bid successful and also trsnsfer the funds to the seller of just transfer the nft tot the seller id the bid was not successful
    function end() external {
        if(!started) {
            revert BidHasNotStarted();
        }
        if(ended) {
            revert BidHasEnded();
        }


        if (highestBidder != address(0)) {
            nft.transfer(highestBidder, nftId);
            bool sent = IERC20(protocol_token).transfer(seller, highestBid);
            require(sent, "Could not pay seller!");
        } else {
            nft.transfer(seller, nftId);
        }

        ended = true;
        emit End(highestBidder, highestBid);
    }
}