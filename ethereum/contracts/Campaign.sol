pragma solidity ^0.4.17;

contract CampaignFactory {
  address[] public deployedCampaigns;


  function createCampaign(uint _minimumContribution) public {
    address newCampaign = new Campaign(_minimumContribution, msg.sender);
    deployedCampaigns.push(newCampaign);
  }

  function getDeployedCampaigns() public view returns (address[]) {
    return deployedCampaigns;
  }
}

contract Campaign {
  struct Request {
    string description;
    uint value;
    address recipient;
    bool complete;
    uint approvalCount;
    mapping(address => bool) approvals;
  }

  Request[] public requests;
  address public manager;
  uint public minimumContribution;
  mapping(address => bool) public approvers;
  uint approversCount;

  modifier restricted() {
    require(msg.sender == manager);
    _;
  }

  constructor(uint _minimumContribution, address _manager) public {
    manager = _manager;
    minimumContribution = _minimumContribution;
  }

  function contribute() public payable {
    require(msg.value > minimumContribution);

    approvers[msg.sender] = true;
    approversCount++;
  }

  function createRequest(string _description, uint _value, address _recipient) public restricted {
    Request memory newRequest = Request(_description, _value, _recipient, false, 0);

    requests.push(newRequest);
  }

  function approveRequest(uint _index) public {
    Request storage request = requests[_index];

    require(approvers[msg.sender]);
    require(!request.approvals[msg.sender]);

    request.approvalCount++;
    request.approvals[msg.sender] = true;
  }

  function finalizeRequest(uint _index) public restricted {
    Request storage request = requests[_index];

    require(request.approvalCount > (approversCount / 2));
    require(!request.complete);

    request.recipient.transfer(request.value);
    request.complete = true;
  }
}
