// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract EnhancedTaskManager {
    address public admin;
    uint public constant REWARD_PER_TASK = 15; // Credits per completed task
    uint public constant MINIMUM_EXCHANGE = 75; // Minimum credits required to exchange
    uint public constant CREDITS_PER_COIN = 75; // 75 credits = 1 coin
    uint public constant TASK_DURATION = 1 hours; // Time to complete a task (1 hour)

    struct Task {
        string description;
        uint creationTime;
        bool isDone;
        uint deadline; // Task deadline
    }

    // User-specific data mappings
    mapping(address => Task[]) private userTasks;
    mapping(address => uint) private userCredits;
    mapping(address => uint) private coinsExchanged; // Track total coins exchanged by each user

    // Modifier to restrict access to admin
    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can access this function");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    // Function to create a new task
    function createTask(string calldata _description) external {
        require(bytes(_description).length > 3, "Task description too short");

        uint deadline = block.timestamp + TASK_DURATION; // Set task deadline

        // Add the task to the user's task list
        userTasks[msg.sender].push(Task({
            description: _description,
            creationTime: block.timestamp,
            isDone: false,
            deadline: deadline
        }));
    }

    // Function to mark a task as done and receive credits
    function markTaskAsDone(uint _index) external {
        require(_index < userTasks[msg.sender].length, "Task does not exist");

        Task storage task = userTasks[msg.sender][_index];
        require(!task.isDone, "Task is already marked as completed");

        // Revert if the task is not completed within the allowed duration
        if (block.timestamp > task.deadline) {
            revert("Task completion period expired");
        }

        // Update task status and reward credits
        task.isDone = true;
        userCredits[msg.sender] += REWARD_PER_TASK;
    }

    // Function to exchange credits for coins
    function exchangeCreditsForCoins(uint _creditsToExchange) external {
        if (_creditsToExchange == 0) {
            revert("Credits to exchange must be positive");
        }

        if (_creditsToExchange > userCredits[msg.sender]) {
            revert("Not enough credits");
        }

        if (_creditsToExchange < MINIMUM_EXCHANGE) {
            revert("Credits below the minimum exchange threshold");
        }

        uint coins = _creditsToExchange / CREDITS_PER_COIN; // Calculate the number of coins
        if (coins == 0) {
            revert("Not enough credits for 1 coin");
        }

        uint initialCredits = userCredits[msg.sender];
        userCredits[msg.sender] -= _creditsToExchange;

        // Track the total coins exchanged by the user
        coinsExchanged[msg.sender] += coins;

        // Ensure credits are deducted correctly
        assert(userCredits[msg.sender] == initialCredits - _creditsToExchange);
    }

    // Function to retrieve user's total credits
    function viewCredits() external view returns (uint) {
        return userCredits[msg.sender];
    }

    // Function to retrieve total coins exchanged by the user
    function coinsBalance() external view returns (uint) {
        return coinsExchanged[msg.sender];
    }

    // Function to retrieve user's tasks
    function getUserTasks() external view returns (Task[] memory) {
        return userTasks[msg.sender];
    }

    // Function for admin to reset user credits and exchanged coins
    function resetUserCredits(address _user) external onlyAdmin {
        require(_user != address(0), "Invalid user address");
        userCredits[_user] = 0;
        coinsExchanged[_user] = 0; // Reset exchanged coins as well
    }
}
