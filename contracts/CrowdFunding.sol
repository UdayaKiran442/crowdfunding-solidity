//SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

contract CrowdFunding{
   struct Campaign{
        address payable receipientAddress;
        string title;
        string description;
        string imageUrl;
        string deadline;
        uint target;
        uint id;
        uint received;
        bool completed;
   }
   Campaign[] public campaigns;
    uint public numOfCampaigns = 0;
   function addCampaign(string memory _title,string memory _description,string memory _imageUrl,string memory _deadline,uint _target ) public {
    campaigns.push(Campaign({
        receipientAddress:payable(msg.sender),
        title:_title,
        imageUrl:_imageUrl,
        description:_description,
        deadline:_deadline,
        target:_target,
        id:numOfCampaigns,
        received:0,
        completed:false
    }));
    numOfCampaigns++;
   }
   function donate(uint _id) public payable {
    require(_id<campaigns.length,"Inavlid campaign id");
    Campaign storage campaign = campaigns[_id];
    require(!campaign.completed,"Campaign closed");
    campaign.receipientAddress.transfer(msg.value);
    campaign.received+=msg.value;
    if(campaign.received>=campaign.target){
        campaign.completed = true;
    }
   }


}