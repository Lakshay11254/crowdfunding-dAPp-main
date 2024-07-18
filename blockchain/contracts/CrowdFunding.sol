// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract CrowdFunding {
    /* State Variables */
    address[] private s_AllCampaignAddresses;

    /* event is emitted when a new campaign is created */
    event campaignCreated(
        string indexed _category,
        address indexed _campaignOwner,
        uint256 indexed _timestamp,
        string _title,
        string _image,
        string _description,
        uint256 _requiredAmount,
        address _campaignAddress
    );

    /* Getter Functions */
    function getAllCampaignAddresses()
        external
        view
        returns (address[] memory)
    {
        return s_AllCampaignAddresses;
        //fn returns the array of all campaign addresses
    }

    /* Logic */
    function createCampaign(
        string memory _title,
        string memory _image,
        string memory _description,
        string memory _category,
        uint256 _requiredAmount
    ) 
    external {
    //creates a new instance of the Campaign contract.

        Campaign newCampaign = new Campaign(
            _title,
            _image,
            _description,
            _requiredAmount,
            msg.sender
        );

//The address of the newly created campaign is pushed to the s_AllCampaignAddresses array
        s_AllCampaignAddresses.push(address(newCampaign));

        emit campaignCreated(
            _category,
            msg.sender,
            block.timestamp,
            _title,
            _image,
            _description,
            _requiredAmount,
            address(newCampaign)
//is then emitted with the details of the new campaign
        );
    }
}

/* Campaign structure where we can call this contract whenever we are creating a campaign. */
contract Campaign {
    /* State Variables  to hold the data for this specific campaign.*/
    struct CampaignStruct {
        string title;
        string image;
        string description;
        uint256 requiredAmount;
        uint256 recievedAmount;
        address payable campaignOwner;
    }

   // This event is emitted when a campaign receives funding.
    event campaignFunded(
        address indexed funder,
        uint256 indexed timestamp,
        uint256 amount
    );

    CampaignStruct newCampaign;

    constructor(
        string memory _title,
        string memory _image,
        string memory _description,
        uint256 _requiredAmount,
        address _campaignOwner
    ) {
        newCampaign = CampaignStruct(
            _title,
            _image,
            _description,
            _requiredAmount,
            0,
            payable(_campaignOwner)
        );
    }

    /* Getter Functions */
    function getCampaign() external view returns (CampaignStruct memory) {
        return newCampaign;
    }


    // User can fund the different campaigns using this;
    function fundCampaign() external payable {
        require(
            newCampaign.requiredAmount > newCampaign.recievedAmount,
            "Amount excided"
        );
        require(
            msg.value <= newCampaign.requiredAmount,
            "amount more then the needed."
        );
        newCampaign.campaignOwner.transfer(msg.value);
        newCampaign.recievedAmount += msg.value;
        emit campaignFunded(msg.sender, block.timestamp, msg.value);
    }
}
