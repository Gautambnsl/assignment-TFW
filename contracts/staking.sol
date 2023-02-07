
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Staking{

    address public NftContract;
    address public TokenContract;
    uint constant price = 1000; //const price if nft
    mapping(address=>uint) record;
    mapping(address=>uint) recordTime;


    constructor(address token,address nft){
        TokenContract = token;
        NftContract = nft;
    }

    function stake(uint id) public{
      ERC721(NftContract).transferFrom(msg.sender,address(this),id);  
      record[msg.sender] = id; 
      recordTime[msg.sender] = block.timestamp; 
    }

    function withdraw() public{
            uint id = record[msg.sender];
            uint time = recordTime[msg.sender];
            ERC721(NftContract).transferFrom(address(this),msg.sender,id);
            uint value = calculateAPR(time);
      
            ERC20(TokenContract).transfer(msg.sender,value * 10**18);
            record[msg.sender] = 0;
            recordTime[msg.sender] = 0;
            
    }


    function calculateAPR(uint time) view public returns(uint){

        uint passTime = block.timestamp - time;
        
        if(passTime < 5 ){
                passTime =  0;
        }else if(passTime >= 5 && passTime < 20){
            passTime = price * 25 / 1000;
        }else if(passTime >= 20 &&  passTime < 30){
           passTime = price * 634 / 10000;
        }else if(passTime >= 30){
            passTime = price * 1575 / 10000;
        }

        return passTime;    
    }   


}