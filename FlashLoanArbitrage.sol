// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@aave/core-v3/contracts/flashloan/base/FlashLoanSimpleReceiverBase.sol";
import "@aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol";

/**
 * @title FlashLoanArbitrage
 * @dev Professional template for executing Aave V3 Flash Loans for arbitrage.
 */
contract FlashLoanArbitrage is FlashLoanSimpleReceiverBase {
    address public owner;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner");
        _;
    }

    constructor(address _addressProvider) FlashLoanSimpleReceiverBase(IPoolAddressesProvider(_addressProvider)) {
        owner = msg.sender;
    }

    /**
     * @notice Initiates a flash loan.
     * @param _asset The token to borrow.
     * @param _amount The quantity to borrow.
     */
    function executeTrade(address _asset, uint256 _amount) external onlyOwner {
        address receiverAddress = address(this);
        bytes memory params = ""; // Add custom encoded swap data here
        uint16 referralCode = 0;

        POOL.flashLoanSimple(
            receiverAddress,
            _asset,
            _amount,
            params,
            referralCode
        );
    }

    /**
     * @notice Aave callback function that executes the arbitrage logic.
     */
    function executeOperation(
        address asset,
        uint256 amount,
        uint256 premium,
        address initiator,
        bytes calldata params
    ) external override returns (bool) {
        // 1. ARBITRAGE LOGIC STARTS HERE
        // Example: Swap 'asset' on DEX A for Token B, then Swap Token B on DEX B for 'asset'
        
        // 2. ENSURE PROFITABILITY
        uint256 amountToRepay = amount + premium;
        // require(IERC20(asset).balanceOf(address(this)) > amountToRepay, "No profit");

        // 3. APPROVE AAVE TO REPAY
        IERC20(asset).approve(address(POOL), amountToRepay);

        return true;
    }

    function withdraw(address _token) external onlyOwner {
        uint256 balance = IERC20(_token).balanceOf(address(this));
        IERC20(_token).transfer(owner, balance);
    }

    receive() external payable {}
}
