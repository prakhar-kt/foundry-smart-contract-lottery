// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;




/**
 * @title A sample Raffle Contract
 * @author Prakhar Srivastava
 * @notice This contract is for creating a sample raffle
 * @dev Implements Chainlink VRFv2
 */
contract Raffle {

    error Raffle__NotEnoughEthSent();

    /** State Variables */
    uint256 private constant REQUEST_CONFIRMATIONS;
    uint256 private immutable i_entranceFee;
    // @dev duration of the lottery in seconds
    uint256 private immutable i_interval;
    address private immutable i_vrfCoordinator;
    bytes32 private immutable i_gasLane;
    uint64  private immutable i_subscriptionId;

    address payable[] private s_players;
    uint256 private s_lastTimeStamp;

    /** Events */
    event EnteredRaffle(address indexed player);

    constructor(
                uint256 entranceFee,
                uint256 interval, 
                address vrfCoordinator,
                bytes32 gasLane,
                uint64  subscriptionId
                ) {
        i_entranceFee = entranceFee;
        i_interval = interval;
        i_vrfCoordinator = vrfCoordinator;
        i_gasLane = gasLane;
        i_subscriptionId = subscriptionId;
        s_lastTimeStamp = block.timestamp;
    }

    function enterRaffle() external payable {

        if(msg.value < i_entranceFee) {

            revert Raffle__NotEnoughEthSent();
        }

        s_players.push(payable(msg.sender));

        emit EnteredRaffle(msg.sender);


    }

    function pickWinner() external {
        // check to see if enough time has passed
        if ((block.timestamp - s_lastTimeStamp) <= i_interval) {
            revert();
        }

        uint256 requestId = i_vrfCoordinator.requestRandomWords(
            i_gasLane, // gas lane
            s_subscriptionId, //
            requestConfirmations,
            callbackGasLimit,
            numWords
        );
    }

    /** Getter Functions */

    function getEntranceFee() external view returns (uint256) {
        return i_entranceFee;
    }
}