// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {CrossNft} from "../src/CrossNft.sol";

contract DeployPol is Script {
    function run() public {
        vm.startBroadcast();

        address ccipRouterPol = 0x9C32fCB86BF0f4a1A8921a9Fe46de3198bb884B2;
        address linkAddressPol = 0x0Fd9e8d3aF1aaee056EB9e802c3A762a667b1904;

        CrossNft crossNft = new CrossNft(ccipRouterPol, linkAddressPol);
        vm.stopBroadcast();

        console.log("XNFT deployed to ", address(crossNft));
    }
}
