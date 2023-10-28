// The 'zkvote' program.
program zkvote.aleo {
 struct ProposalData {
        heading: field,
        details: field,
        submitter: address,
        endTimestamp: u128,
    }

    record Ballot {
        owner: address, // added
        initiator: address,
        ballotID: field,
        data: ProposalData,
    }

    mapping proposalStorage: field => ProposalData;

    record VoteToken {
        owner: address, // added
        holder: address,
        ballotRef: field,
    }

    mapping tokensCount: field => u64;
    mapping forVotes: field => u64;
    mapping againstVotes: field => u64;

    // Proposing a new ballot.
    transition submitProposal(public data: ProposalData) -> Ballot {
       
        assert_eq(self.caller, aleo1dpdlcenz9tq3eq6kxlwkulnvh00gz4ny9yh660f02v382a4utcrqxurq6w); 
        assert_eq(self.caller, data.submitter);

        let ballotID: field = BHP256::hash_to_field(data.heading);
        return Ballot {
            owner: self.caller, // initialize the owner field
            initiator: self.caller,
            ballotID,
            data,
        } then finalize(ballotID, data);
    }

    finalize submitProposal(public ballotID: field, public data: ProposalData) {
        Mapping::set(proposalStorage, ballotID, data); // Moved inside the finalize block
        Mapping::set(tokensCount, ballotID, 0u64);
    }

    // Issuing a vote token.
    transition issueToken(public ballotRef: field, public participant: address) -> VoteToken {
        assert_eq(self.caller, aleo1dpdlcenz9tq3eq6kxlwkulnvh00gz4ny9yh660f02v382a4utcrqxurq6w); // Permission check
        return VoteToken {
            owner: aleo1dpdlcenz9tq3eq6kxlwkulnvh00gz4ny9yh660f02v382a4utcrqxurq6w,
            holder: participant,
            ballotRef,
        } then finalize(ballotRef);
    }

    finalize issueToken(public ballotRef: field) {
        let currentTokens: u64 = Mapping::get_or_use(tokensCount, ballotRef, 0u64);
        Mapping::set(tokensCount, ballotRef, currentTokens + 1u64);
    }

    // Voting process.
    transition castForVote(token: VoteToken, timestamp: u128) {
        return then finalize(token.ballotRef, timestamp);
    }

    finalize castForVote(public ballotRef: field, timestamp: u128) {
        let proposal: ProposalData = Mapping::get(proposalStorage, ballotRef);
        assert_eq(proposal.endTimestamp < timestamp, true);
        let currentVotes: u64 = Mapping::get_or_use(forVotes, ballotRef, 0u64);
        Mapping::set(forVotes, ballotRef, currentVotes + 1u64);
    }

    transition castAgainstVote(token: VoteToken, timestamp: u128) {
        return then finalize(token.ballotRef, timestamp);
    }

    finalize castAgainstVote(ballotRef: field, timestamp: u128) {
        let proposal: ProposalData = Mapping::get(proposalStorage, ballotRef);
        assert_eq(proposal.endTimestamp < timestamp, true);
        let currentVotes: u64 = Mapping::get_or_use(againstVotes, ballotRef, 0u64);
        Mapping::set(againstVotes, ballotRef, currentVotes + 1u64);
    }
}
