# EnhancedTaskManager Smart Contract

## Overview

The **EnhancedTaskManager** smart contract is a decentralized application that allows users to create tasks, mark them as completed within a given time frame, earn credits for completion, and exchange credits for coins. It also includes admin functionality for managing user credits and coin exchanges. This contract demonstrates the use of Solidity features such as task management, credit rewards, coin exchange, and error handling.

## Features

### Task Management
- **Task Creation**: Users can create new tasks by providing a description. Each task has a deadline set to 1 hour from creation.
- **Task Completion**: Users can mark a task as done within the deadline (1 hour). If the task is completed on time, the user earns credits.
  
### Credit System
- **Rewards for Task Completion**: For every completed task, users earn a fixed number of credits (15 credits per task).
- **Credits Management**: Users can view their total credits using the `viewCredits()` function.

### Coin Exchange
- **Minimum Exchange Requirement**: Users can exchange credits for coins, but only if they have at least 75 credits.
- **Credits to Coins Conversion**: Credits can be exchanged at a rate of **75 credits = 1 coin**. The coin balance can be checked using the `coinsBalance()` function.
- **Coin Exchange Process**: Users can exchange credits for coins provided they meet the minimum credits threshold.

### Admin Control
- **Admin Functions**: The contract includes a modifier `onlyAdmin` to restrict certain actions (e.g., resetting user credits and coins) to the admin (contract deployer).
- **Reset User Data**: The admin can reset a user's credits and coin balances using the `resetUserCredits()` function.

### Error Handling
- **`require()`**: Used for input validation and ensuring conditions are met (e.g., ensuring the user has enough credits or that a task exists).
- **`assert()`**: Ensures that the correct amount of credits is deducted after an exchange.
- **`revert()`**: Rolls back transactions and reverts state changes if certain conditions are not met (e.g., task completion after the deadline).
