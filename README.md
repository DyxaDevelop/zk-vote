# PrivateVote - A Decentralized Voting System on Aleo

## Overview

`PrivateVote` is a decentralized application written in Leo for the Aleo platform. It provides functionality for users to create proposals and for participants to vote on them.

## Features

- **Proposal Creation**: A user can create a proposal with a heading, details, submitter address, and end timestamp.
- **Vote Token Issuance**: A designated authority (defined by an Aleo address) can issue voting tokens to participants.
- **Voting**: Participants can cast their vote using the issued tokens, either "For" or "Against" a proposal.
- **End Timestamp**: Voting on a proposal is restricted after its end timestamp has passed.

## How it Works

### Structures

- `ProposalData`: Contains the details of the proposal.
- `Ballot`: Represents a proposal and includes the data as well as meta-information like the initiator.
- `VoteToken`: Represents a token given to a participant to cast their vote.

### Mappings

- `proposalStorage`: Stores all the proposals.
- `tokensCount`: Keeps track of the number of tokens issued for each proposal.
- `forVotes` & `againstVotes`: Track votes for and against the proposal.

### Transitions

- `submitProposal`: Used to submit a new proposal.
- `issueToken`: Issues a token to a participant for voting.
- `castForVote` & `castAgainstVote`: Used by participants to cast their votes.

Each of the above transitions has an associated `finalize` block, which contains the logic to finalize the action, like updating mappings or checking conditions.

## Installation & Usage

1. Clone this repository to your local machine.
2. Make sure you have the necessary Aleo tools installed.
3. Compile the program using Leo compiler: `leo build`
4. Deploy and run on the Aleo testnet or mainnet as per your requirements.

## Contribute

If you find any issues or want to add more features, feel free to create pull requests or open an issue.

## License

[MIT License](LICENSE)
