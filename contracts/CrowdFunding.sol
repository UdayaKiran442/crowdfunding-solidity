// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract CrowdFunding{
    struct Campaign{
        address payable receipientAddress;
        string title;
        string description;
        string imageUrl;
        uint target;
        string deadline;
        uint received;
        uint id;
        bool completed;
    }
    Campaign[] public campaigns;
    uint public numberOfCampaigns = 0;
    function addCampaigns(string memory _title, string memory _description, string memory _imageUrl, uint _target, string memory _deadline ) public {
        require(_target > 0,"Target amount must not be zero");
        campaigns.push(Campaign({
            receipientAddress:payable(msg.sender),
            title:_title,
            description:_description,
            imageUrl:_imageUrl,
            target:_target,
            deadline:_deadline,
            received:0,
            id:numberOfCampaigns,
            completed:false
        }));
        numberOfCampaigns++;
    }
    function getCampaigns() public view returns(Campaign[] memory){
        return campaigns;
    } 
    function getCampaignDetails(uint index) public view returns(Campaign memory){
        Campaign memory campaign = campaigns[index];
        return campaign;
    }
    function donateToCampaign(uint index) public payable {
        require(index < campaigns.length, "Invalid campaign index");
        Campaign storage campaign = campaigns[index];
        require(!campaign.completed,"Campaign completed");
        campaign.receipientAddress.transfer(msg.value);
        campaign.received = campaign.received + msg.value; 
        if(campaign.received>=campaign.target){
            campaign.completed = true;
        }
    } 
}