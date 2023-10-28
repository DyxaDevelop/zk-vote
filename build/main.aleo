program zkvote.aleo;

struct ProposalData:
    heading as field;
    details as field;
    submitter as address;
    endTimestamp as u128;

record Ballot:
    owner as address.private;
    initiator as address.private;
    ballotID as field.private;
    data as ProposalData.private;

record VoteToken:
    owner as address.private;
    holder as address.private;
    ballotRef as field.private;


mapping proposalStorage:
	key as field.public;
	value as ProposalData.public;


mapping tokensCount:
	key as field.public;
	value as u64.public;


mapping forVotes:
	key as field.public;
	value as u64.public;


mapping againstVotes:
	key as field.public;
	value as u64.public;

function submitProposal:
    input r0 as ProposalData.public;
    assert.eq self.caller aleo1dpdlcenz9tq3eq6kxlwkulnvh00gz4ny9yh660f02v382a4utcrqxurq6w;
    assert.eq self.caller r0.submitter;
    hash.bhp256 r0.heading into r1 as field;
    cast self.caller self.caller r1 r0 into r2 as Ballot.record;
    async submitProposal r1 r0 into r3;
    output r2 as Ballot.record;
    output r3 as zkvote.aleo/submitProposal.future;

finalize submitProposal:
    input r0 as field.public;
    input r1 as ProposalData.public;
    set r1 into proposalStorage[r0];
    set 0u64 into tokensCount[r0];


function issueToken:
    input r0 as field.public;
    input r1 as address.public;
    assert.eq self.caller aleo1dpdlcenz9tq3eq6kxlwkulnvh00gz4ny9yh660f02v382a4utcrqxurq6w;
    cast aleo1dpdlcenz9tq3eq6kxlwkulnvh00gz4ny9yh660f02v382a4utcrqxurq6w r1 r0 into r2 as VoteToken.record;
    async issueToken r0 into r3;
    output r2 as VoteToken.record;
    output r3 as zkvote.aleo/issueToken.future;

finalize issueToken:
    input r0 as field.public;
    get.or_use tokensCount[r0] 0u64 into r1;
    add r1 1u64 into r2;
    set r2 into tokensCount[r0];


function castForVote:
    input r0 as VoteToken.record;
    input r1 as u128.private;
    async castForVote r0.ballotRef r1 into r2;
    output r2 as zkvote.aleo/castForVote.future;

finalize castForVote:
    input r0 as field.public;
    input r1 as u128.public;
    get proposalStorage[r0] into r2;
    lt r2.endTimestamp r1 into r3;
    assert.eq r3 true;
    get.or_use forVotes[r0] 0u64 into r4;
    add r4 1u64 into r5;
    set r5 into forVotes[r0];


function castAgainstVote:
    input r0 as VoteToken.record;
    input r1 as u128.private;
    async castAgainstVote r0.ballotRef r1 into r2;
    output r2 as zkvote.aleo/castAgainstVote.future;

finalize castAgainstVote:
    input r0 as field.public;
    input r1 as u128.public;
    get proposalStorage[r0] into r2;
    lt r2.endTimestamp r1 into r3;
    assert.eq r3 true;
    get.or_use againstVotes[r0] 0u64 into r4;
    add r4 1u64 into r5;
    set r5 into againstVotes[r0];
