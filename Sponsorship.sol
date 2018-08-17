pragma solidity ^0.4.11;

contract Sponsorship {
    struct Sponsor {
        address addr;
        uint amount;
    }

    struct Campaign {
        address beneficiary;
        uint fundingGoal;
        uint numSponsors;
        uint amount;
        mapping (uint => Sponsor) sponsors;
    }

    uint numCampaigns;
    mapping (uint => Campaign) campaigns;

    function newCampaign(address beneficiary, uint goal) public returns (uint campaignID) {
        campaignID = numCampaigns++;
        campaigns[campaignID] = Campaign(beneficiary, goal, 0, 0);
    }

    function contribution(uint campaignID) public payable {
        Campaign storage c = campaigns[campaignID];
        
        c.sponsors[c.numSponsors++] = Sponsor({addr: msg.sender, amount: msg.value});
        c.amount += msg.value;
    }

    function checkGoalReached(uint campaignID) public payable returns (bool reached) {
        Campaign storage c = campaigns[campaignID];
        if (c.amount < c.fundingGoal)
            return false;
        uint amount = c.amount;
        c.amount = 0;
        c.beneficiary.transfer(amount);
        return true;
    }
}