// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

import {Test, console} from "forge-std/Test.sol";
import {Voting} from "../src/Voting.sol";

contract VotingTest is Test {
    Voting public voting;

    address public owner = address(1);
    address public voter1 = address(2);
    address public voter2 = address(3);

    function setUp() public {
        vm.startPrank(owner);
        voting = new Voting();
        vm.stopPrank();
    }

    function testVoteForEthereum() public {
        vm.prank(voter1);
        voting.vote(0);

        assertTrue(voting.hasVoted(voter1));
        assertEq(voting.votesForEthereum(), 1);

        (address addr, uint8 option) = voting.voters(0);
        assertEq(addr, voter1);
        assertEq(option, 0);
    }

    function testVoteForSolana() public {
        vm.prank(voter2);
        voting.vote(1);

        assertTrue(voting.hasVoted(voter2));
        assertEq(voting.votesForSolana(), 1);

        (address addr, uint8 option) = voting.voters(0);
        assertEq(addr, voter2);
        assertEq(option, 1);
    }

    function testDoubleVotingShouldRevert() public {
        vm.prank(voter1);
        voting.vote(1);

        vm.expectRevert(Voting.UserAlreadyVoted.selector);

        vm.prank(voter1);
        voting.vote(0);
    }

    function testInvalidVoteOptionShouldRevert() public {
        vm.expectRevert(Voting.WrongVoteOption.selector);
        vm.prank(voter1);
        voting.vote(2);
    }

    function testPauseVoting() public {
        vm.prank(owner);
        voting.pauseVoting();

        assertEq(voting.isVotingActive(), false);
    }

    function testResumeVoting() public {
        vm.prank(owner);
        voting.resumeVoting();

        assertEq(voting.isVotingActive(), true);
    }

    function testCannotVoteWhilePaused() public {
        vm.prank(owner);
        voting.pauseVoting();

        vm.expectRevert(Voting.VotingIsPaused.selector);

        vm.prank(voter2);
        voting.vote(1);
    }
}
