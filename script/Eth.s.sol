// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {CrossNft} from "../src/CrossNft.sol";

contract DeployPol is Script {
    function run() public {
        vm.startBroadcast();

        address ccipRouterPol = 0x0BF3dE8c5D3e8A2B34D2BEeB17ABfCeBaf363A59;
        address linkAddressPol = 0x779877A7B0D9E8603169DdbD7836e478b4624789;

        CrossNft crossNft = new CrossNft(ccipRouterPol, linkAddressPol);
        vm.stopBroadcast();

        console.log("XNFT deployed to ", address(crossNft));
    }
}
