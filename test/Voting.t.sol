// SPDX-License-Identifier: MIT

pragma solidity ^0.8.30;

import {Test} from "forge-std/Test.sol";
import {Voting} from "../src/Voting.sol";

contract VotingTest is Test {
    enum Vote {
        YES,
        NO
    }
    event VoteCast(address indexed voter, Vote vote);
    Voting public voting;
    address USER1 = makeAddr("user1");
    address USER2 = makeAddr("user2");

    function setUp() public {
        voting = new Voting();
    }
    function testRevertOnAlreadyVotedYes() public {
        vm.startPrank(USER1);
        voting.voteYes();
        vm.expectRevert(bytes("Already voted"));
        voting.voteYes();
        vm.stopPrank();
    }
    function testVoteYes() public {
        voting.voteYes();
        assertEq(voting.getTotalVotes(), 1);
        (uint256 yes, uint256 no) = voting.getVoteCounts();
        assertEq(yes, 1);
        assertEq(no, 0);
    }

    function testEmitEventOnVoteYes() public {
        vm.startPrank(USER1);
        vm.expectEmit(true, false, false, true);
        emit VoteCast(USER1, Vote.YES);
        voting.voteYes();
        vm.stopPrank();
    }
    function testRevertOnAlreadyVotedNo() public {
        vm.startPrank(USER1);
        voting.voteNo();
        vm.expectRevert(bytes("Already voted"));
        voting.voteNo();
        vm.stopPrank();
    }
    function testVoteNo() public {
        voting.voteNo();
        assertEq(voting.getTotalVotes(), 1);
        (uint256 yes, uint256 no) = voting.getVoteCounts();
        assertEq(yes, 0);
        assertEq(no, 1);
    }

    function testEmitEventOnVoteNo() public {
        vm.startPrank(USER1);
        vm.expectEmit(true, false, false, true);
        emit VoteCast(USER1, Vote.NO);
        voting.voteNo();
        vm.stopPrank();
    }

    function testGetTotalVotes() public {
        vm.prank(USER1);
        voting.voteYes();
        vm.prank(USER2);
        voting.voteNo();

        assertEq(voting.getTotalVotes(), 2);
    }

    function testGetVoteCounts() public {
        vm.prank(USER1);
        voting.voteYes();
        vm.prank(USER2);
        voting.voteNo();
        (uint256 yes, uint256 no) = voting.getVoteCounts();
        assertEq(yes, 1);
        assertEq(no, 1);
    }

    function testGetAllVotes() public {
        vm.prank(USER1);
        voting.voteYes();
        vm.prank(USER2);
        voting.voteNo();
        Voting.Entry[] memory votes = voting.getAllVotes();

        assertEq(votes.length, 2);
        assertEq(votes[0].voter, USER1);
        assertEq(uint8(votes[0].vote), uint8(Vote.YES));
        assertEq(votes[1].voter, USER2);
        assertEq(uint8(votes[1].vote), uint8(Vote.NO));
    }

    function testHasUserVoted() public {
        vm.prank(USER1);
        voting.voteYes();
        assertTrue(voting.hasUserVoted(USER1));
        assertFalse(voting.hasUserVoted(USER2));
    }
}
