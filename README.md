# Flash Loan Arbitrage Bot

A high-performance, single-file Solidity implementation of a Flash Loan executor. This repository is designed for expert developers looking to leverage "uncollateralized" capital to exploit price discrepancies across the DeFi ecosystem.

### Features
* **Aave V3 Integration**: Uses the latest Flash Loan provider for deep liquidity and low fees.
* **Atomic Execution**: Ensures that if the arbitrage trade is not profitable, the entire transaction reverts, protecting the user from losses.
* **Multi-DEX Routing**: Structure supports calling multiple router interfaces (e.g., Uniswap V2/V3) within a single callback.
* **Gas Optimized**: Minimalist logic to ensure the fastest execution and lowest gas overhead.

### How to Use
1. Deploy `FlashLoanArbitrage.sol` with the Aave Pool Addresses Provider.
2. Fund the contract with enough tokens to cover the Flash Loan fee (typically 0.05% - 0.09%).
3. Call `executeTrade` with the asset, amount, and encoded parameters for the target DEXs.
4. The contract borrows, swaps, repays the loan, and keeps the profit in the root address.
