pragma solidity ^0.4.17;
contract Auction
{
    //structure to hold the details of the item.
    struct Item 
    {
        uint itemId;
        uint[] itemTokens;
    }
    
    //struture to hold the details of a person.
    struct Person
    {
        uint remainingTokens;
        uint personId;
        address addr;
    }
    
    mapping(address => Person) tokenDetails; //address to person
    
    Person [4] bidders;
    Item [3] public items;
    address[3] public winners;//Array for address of winners
    address public beneficiary;//owner of the smart contract
    uint bidderCount = 0;

function Auction() public payable
{
    beneficiary = msg.sender;//msg.sender is the address of the owner
    
    uint[] memory emptyArray;
    items[0] = Item(
        {
            itemId:0,itemTokens:emptyArray
        });
        
    items[1] = Item({itemId:1,itemTokens:emptyArray});
    items[2] = Item({itemId:2,itemTokens:emptyArray});
}

function register() public payable
{
    bidders[bidderCount].personId = bidderCount;
    bidders[bidderCount].addr = msg.sender;
    
    bidders[bidderCount].remainingTokens = 5;
    tokenDetails[msg.sender] = bidders[bidderCount];
    bidderCount++;
}

function bid(uint _itemId, uint _count) public payable
{
    if(tokenDetails[msg.sender].remainingTokens < _count || tokenDetails[msg.sender].remainingTokens == 0 || _itemId > 2)
    {
        revert();
    }
    tokenDetails[msg.sender].remainingTokens = tokenDetails[msg.sender].remainingTokens - _count;
    
    bidders[tokenDetails[msg.sender].personId].remainingTokens = tokenDetails[msg.sender].remainingTokens;
    
    Item storage bidItem = items[_itemId];
    for(uint i=0; i<_count;i++)
    {
        bidItem.itemTokens.push(tokenDetails[msg.sender].personId);     
    }
}

function revealWinners() public
{
    for(uint id=0; id<3 ; id++)
    {
        Item storage currentItem = items[id];
        if(currentItem.itemTokens.length != 0)
        {
            uint randomIndex = (block.number/ currentItem.itemTokens.length)% currentItem.itemTokens[randomIndex];
            
            uint winnersId = currentItem.itemTokens[randomIndex];
            winners[id] = bidders[winnersId].addr; 
        }
    }
}

function getPersonDetails(uint id) public constant returns(uint,uint,address)
    {
        return(bidders[id].remainingTokens,bidders[id].personId,bidders[id].addr);
    }
}



