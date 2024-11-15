// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ERC721URIStorage} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import {ERC721Burnable} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import {Client} from "@chainlink/contracts-ccip/src/v0.8/ccip/libraries/Client.sol";
import {IRouterClient} from "@chainlink/contracts-ccip/src/v0.8/ccip/interfaces/IRouterClient.sol";
import {IAny2EVMMessageReceiver} from "@chainlink/contracts-ccip/src/v0.8/ccip/interfaces/IAny2EVMMessageReceiver.sol";
import {OwnerIsCreator} from "@chainlink/contracts-ccip/src/v0.8/shared/access/OwnerIsCreator.sol";
import {LinkTokenInterface} from "@chainlink/contracts/src/v0.8/shared/interfaces/LinkTokenInterface.sol";

contract CrossNft is
    ERC721,
    ERC721URIStorage,
    ERC721Burnable,
    ReentrancyGuard,
    OwnerIsCreator,
    IAny2EVMMessageReceiver
{
    error NotEnoughBalance(uint256 currentBalance, uint256 calculatedFees);

    error FailedToWithdrawEth(
        address sender,
        address beneficiary,
        uint256 amount
    );
    error NothingToWithdraw();

    IRouterClient private immutable i_routerClient;
    LinkTokenInterface private immutable i_linkToken;

    event transferedMessage(
        address indexed sender,
        address indexed receiver,
        uint256 tokenId,
        uint64 destinationChainSelector
    );

    event CrossChainReceived(
        address indexed sender,
        address indexed receiver,
        uint256 tokenId,
        uint64 sourceChainSelector
    );

    constructor(
        address routerClient,
        address linkToken
    ) ERC721("CrossChain", "CC") {
        i_routerClient = IRouterClient(routerClient);
        i_linkToken = LinkTokenInterface(linkToken);
    }

    function mint(string memory uri) external {
        uint256 s_tokenId;
        s_tokenId = s_tokenId + 1;
        _safeMint(msg.sender, s_tokenId);
        _setTokenURI(s_tokenId, uri);
    }

    function CrossChainTransfer(
        address sender,
        address receiver,
        uint64 destinationChainSelector,
        uint256 tokenId
    ) external onlyOwner returns (bytes32 messageId) {
        string memory tokenUri = tokenURI(tokenId);
        _burn(tokenId);

        Client.EVM2AnyMessage memory evm2AnyMessage = Client.EVM2AnyMessage({
            receiver: abi.encode(receiver), // ABI-encoded receiver address
            data: abi.encode(sender, receiver, tokenId, tokenUri),
            tokenAmounts: new Client.EVMTokenAmount[](0),
            extraArgs: Client._argsToBytes(
                Client.EVMExtraArgsV2({
                    gasLimit: 1000000,
                    allowOutOfOrderExecution: false // Allows the message to be executed out of order relative to other messages from the same sender
                })
            ),
            feeToken: address(i_linkToken)
        });
        uint256 fees = i_routerClient.getFee(
            destinationChainSelector,
            evm2AnyMessage
        );
        if (fees > i_linkToken.balanceOf(address(this)))
            revert NotEnoughBalance(i_linkToken.balanceOf(address(this)), fees);

        i_linkToken.approve(address(i_routerClient), fees);

        messageId = i_routerClient.ccipSend(
            destinationChainSelector,
            evm2AnyMessage
        );

        emit transferedMessage(
            sender,
            receiver,
            tokenId,
            destinationChainSelector
        );

        return messageId;
    }

    function ccipReceive(
        Client.Any2EVMMessage calldata message
    ) external virtual override {
        uint64 sourceChainSelector = message.sourceChainSelector;
        (
            address sender,
            address receiver,
            uint256 tokenId,
            string memory tokenUri
        ) = abi.decode(message.data, (address, address, uint256, string));

        _safeMint(receiver, tokenId);
        _setTokenURI(tokenId, tokenUri);

        emit CrossChainReceived(sender, receiver, tokenId, sourceChainSelector);
    }

    function withdraw(address _beneficiary) public onlyOwner {
        uint256 amount = address(this).balance;

        if (amount == 0) revert NothingToWithdraw();

        (bool sent, ) = _beneficiary.call{value: amount}("");

        if (!sent) revert FailedToWithdrawEth(msg.sender, _beneficiary, amount);
    }

    function supportsInterface(
        bytes4 interfaceId
    ) public view override(ERC721, ERC721URIStorage) returns (bool) {
        return
            interfaceId == type(IAny2EVMMessageReceiver).interfaceId ||
            super.supportsInterface(interfaceId);
    }

    function tokenURI(
        uint256 tokenId
    ) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }
}
