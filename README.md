# hardhat-nft-marketplace

Clone and install dependencies

```bash
git clone https://github.com/mehedi-iitdu/hardhat-nft-marketplace
cd hardhat-nft-marketplace
```

Then:

```
npm install
```

# Usage

If you run `npx hardhat --help` you'll get an output of all the tasks you can run.

## Deploying Contracts

```
npx hardhat deploy
```

## Run a Local Network

One of the best ways to test and interact with smart contracts is with a local network. To run a local network with all your contracts in it, run the following:

```
npx hardhat node
```

# Test

Tests are located in the [test](./test/) directory, and are split between unit tests and staging/testnet tests. Unit tests should only be run on local environments, and staging tests should only run on live environments.

To run unit tests:

```bash
npx test
```

or

```
npx hardhat test
```

To run staging tests on Rinkeby network:

```bash
npx test-staging
```

or

```
npx hardhat test --network rinkeby
```

# Contributing

Contributions are always welcome! Open a PR or an issue!

# Thank You!
