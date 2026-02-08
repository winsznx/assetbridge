// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract AssetBridge {
    struct Migration {
        address owner;
        bytes32 assetId;
        uint256 amount;
        string targetChain;
        bool claimed;
    }

    mapping(uint256 => Migration) public migrations;
    mapping(bytes32 => bool) public validators;
    uint256 public migrationCount;

    event MigrationInitiated(uint256 indexed migrationId, address indexed owner, bytes32 assetId, string targetChain);
    event MigrationClaimed(uint256 indexed migrationId);

    error NotValidator();
    error AlreadyClaimed();

    function initiateMigration(bytes32 assetId, uint256 amount, string memory targetChain) external returns (uint256) {
        uint256 migrationId = migrationCount++;
        migrations[migrationId] = Migration({
            owner: msg.sender,
            assetId: assetId,
            amount: amount,
            targetChain: targetChain,
            claimed: false
        });
        emit MigrationInitiated(migrationId, msg.sender, assetId, targetChain);
        return migrationId;
    }

    function claimMigration(uint256 migrationId) external {
        if (!validators[keccak256(abi.encodePacked(msg.sender))]) revert NotValidator();
        if (migrations[migrationId].claimed) revert AlreadyClaimed();
        migrations[migrationId].claimed = true;
        emit MigrationClaimed(migrationId);
    }

    function addValidator(address validator) external {
        validators[keccak256(abi.encodePacked(validator))] = true;
    }
}
