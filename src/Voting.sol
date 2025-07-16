// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

import {Ownable} from "openzeppelin-contracts/contracts/access/Ownable.sol";

contract Voting is Ownable {
    constructor() Ownable(msg.sender) {
        isVotingActive = true;
    }

    uint256 public votesForEthereum;
    uint256 public votesForSolana;
    uint256 public currentAmountOfVotes;
    bool public isVotingActive;

    mapping(address => bool) public hasVoted;

    struct Voter {
        address voter;
        uint8 votingOption;
    }
    Voter[] public voters;

    event Voted(address indexed _voter, uint8 _voteOption);
    event VotingPaused();
    event VotingResumed();

    error UserAlreadyVoted();
    error WrongVoteOption();
    error VotingIsPaused();

    function vote(uint8 _voteOption) public {
        require(isVotingActive == true, VotingIsPaused());
        require(hasVoted[msg.sender] == false, UserAlreadyVoted());
        require(_voteOption == 0 || _voteOption == 1, WrongVoteOption());

        hasVoted[msg.sender] = true;
        voters.push(Voter(msg.sender, _voteOption));

        if (_voteOption == 0) {
            votesForEthereum++;
        } else {
            votesForSolana++;
        }
        currentAmountOfVotes++;

        emit Voted(msg.sender, _voteOption);
    }

    function pauseVoting() public onlyOwner {
        isVotingActive = false;
        emit VotingPaused();
    }

    function resumeVoting() public onlyOwner {
        isVotingActive = true;
        emit VotingResumed();
    }
}
