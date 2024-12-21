// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CollaborativeKnowledgePods {
    struct KnowledgePod {
        string title;
        string description;
        address creator;
        address[] contributors;
        mapping(address => uint256) contributions;
        uint256 totalContributions;
    }

    KnowledgePod[] public knowledgePods;
    mapping(uint256 => mapping(address => bool)) public hasContributed;

    event KnowledgePodCreated(uint256 indexed podId, string title, address indexed creator);
    event ContributionMade(uint256 indexed podId, address indexed contributor, uint256 amount);

    function createKnowledgePod(string memory _title, string memory _description) public {
        KnowledgePod storage newPod = knowledgePods.push();
        newPod.title = _title;
        newPod.description = _description;
        newPod.creator = msg.sender;
        newPod.totalContributions = 0;

        emit KnowledgePodCreated(knowledgePods.length - 1, _title, msg.sender);
    }

    function contributeToPod(uint256 _podId) public payable {
        require(_podId < knowledgePods.length, "Invalid pod ID");
        require(msg.value > 0, "Contribution must be greater than 0");

        KnowledgePod storage pod = knowledgePods[_podId];

        if (!hasContributed[_podId][msg.sender]) {
            pod.contributors.push(msg.sender);
            hasContributed[_podId][msg.sender] = true;
        }

        pod.contributions[msg.sender] += msg.value;
        pod.totalContributions += msg.value;

        emit ContributionMade(_podId, msg.sender, msg.value);
    }

    function getPodDetails(uint256 _podId)
        public
        view
        returns (
            string memory title,
            string memory description,
            address creator,
            address[] memory contributors,
            uint256 totalContributions
        )
    {
        require(_podId < knowledgePods.length, "Invalid pod ID");

        KnowledgePod storage pod = knowledgePods[_podId];
        return (
            pod.title,
            pod.description,
            pod.creator,
            pod.contributors,
            pod.totalContributions
        );
    }

    function getContributorDetails(uint256 _podId, address _contributor)
        public
        view
        returns (uint256 contributionAmount)
    {
        require(_podId < knowledgePods.length, "Invalid pod ID");

        KnowledgePod storage pod = knowledgePods[_podId];
        return pod.contributions[_contributor];
    }
}