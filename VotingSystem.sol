// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VotingSystem {
    struct Proposal {
        string description;
        uint256 yesVotes;
        uint256 noVotes;
        mapping(address => bool) hasVoted;
    }

    Proposal[] public proposals;
    address public admin;

    event ProposalCreated(uint256 proposalId, string description);
    event Voted(uint256 proposalId, address voter, bool vote);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not the admin");
        _;
    }

    constructor() {
        admin = msg.sender; // Set contract deployer as admin
    }

    function createProposal(string memory _description) external onlyAdmin {
        Proposal storage newProposal = proposals.push();
        newProposal.description = _description;
        emit ProposalCreated(proposals.length - 1, _description);
    }

    function voteOnProposal(uint256 _proposalId, bool _voteYes) external {
        require(_proposalId < proposals.length, "Invalid proposal ID");
        Proposal storage proposal = proposals[_proposalId];
        require(!proposal.hasVoted[msg.sender], "Already voted");

        proposal.hasVoted[msg.sender] = true;
        if (_voteYes) {
            proposal.yesVotes++;
        } else {
            proposal.noVotes++;
        }
        emit Voted(_proposalId, msg.sender, _voteYes);
    }

    function getProposal(uint256 _proposalId)
        external
        view
        returns (string memory description, uint256 yesVotes, uint256 noVotes)
    {
        require(_proposalId < proposals.length, "Invalid proposal ID");
        Proposal storage proposal = proposals[_proposalId];
        return (proposal.description, proposal.yesVotes, proposal.noVotes);
    }

    function changeAdmin(address newAdmin) external onlyAdmin {
        admin = newAdmin;
    }
}
