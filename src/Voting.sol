// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

/// @title Simple Yes/No Voting Contract
/// @notice Allows users to vote Yes or No once and keeps a full history
/// @dev Uses enum for votes, mapping to prevent double voting, and counters for efficient vote tally

contract Voting {
    /// @notice Enum representing possible votes
    enum Vote {
        YES,
        NO
    }

    /// @notice Struct to record each vote with voter address
    struct Entry {
        address voter;
        Vote vote;
    }

    /// @notice Tracks whether an address has voted
    mapping(address => bool) private hasVoted;

    /// @notice Stores the full history of votes
    Entry[] private participants;

    /// @notice Counters for efficient O(1) retrieval
    uint256 private totalYes;
    uint256 private totalNo;

    /// @notice Event emitted when a vote is cast
    event VoteCast(address indexed voter, Vote vote);

    /// @notice Cast a "Yes" vote
    function voteYes() external {
        require(!hasVoted[msg.sender], "Already voted");
        hasVoted[msg.sender] = true;

        participants.push(Entry(msg.sender, Vote.YES));
        totalYes += 1;

        emit VoteCast(msg.sender, Vote.YES);
    }

    /// @notice Cast a "No" vote
    function voteNo() external {
        require(!hasVoted[msg.sender], "Already voted");
        hasVoted[msg.sender] = true;

        participants.push(Entry(msg.sender, Vote.NO));
        totalNo += 1;

        emit VoteCast(msg.sender, Vote.NO);
    }

    /// @notice Get the total number of votes cast
    function getTotalVotes() external view returns (uint256) {
        return participants.length;
    }

    /// @notice Get the total count of Yes and No votes
    /// @return yesCount Number of Yes votes
    /// @return noCount Number of No votes
    function getVoteCounts()
        external
        view
        returns (uint256 yesCount, uint256 noCount)
    {
        return (totalYes, totalNo);
    }

    /// @notice Get the full history of votes
    /// @return Array of all participants with their votes
    function getAllVotes() external view returns (Entry[] memory) {
        return participants;
    }

    /// @notice Check if a given address has voted
    /// @param voter Address to check
    /// @return True if the address has voted, false otherwise
    function hasUserVoted(address voter) external view returns (bool) {
        return hasVoted[voter];
    }
}

/*
=====================================================
VOTING CONTRACT ARCHITECTURE
-----------------------------------------------------
1. Users cast votes using `voteYes()` or `voteNo()`.
   - Each address can vote only once (tracked by `hasVoted` mapping).
   - Each vote is stored in the `participants` array as an `Entry` struct.

2. Mapping `hasVoted` ensures no double voting.
   - `mapping(address => bool)` is checked before recording a vote.

3. Vote history is preserved in `participants[]`.
   - Full list of all voters and their votes is available via `getAllVotes()`.

4. Efficient vote tally:
   - `totalYes` and `totalNo` counters are updated on each vote.
   - `getVoteCounts()` returns current counts in O(1) time.

5. Event logging:
   - `VoteCast(address voter, Vote vote)` emits each vote for off-chain tracking.

6. Query functions:
   - `getTotalVotes()` → total votes cast.
   - `getVoteCounts()` → total Yes/No votes.
   - `getAllVotes()` → full voting history.
   - `hasUserVoted(address)` → check if a user has voted.

=====================================================
*/
