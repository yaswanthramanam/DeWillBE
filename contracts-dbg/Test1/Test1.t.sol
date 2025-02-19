// SPDX-License-Identifier: MIT
pragma solidity >= 0.4.21 < 0.9.0;

import '../../contracts/Inherit.sol';

contract DbgEntry {
    event EvmPrint(string);

    constructor() {
        emit EvmPrint("DbgEntry.constructor");

        Inherit inherit= new Inherit();

        // Here you can either deploy your contracts via `new`, eg:
        //  Counter counter = new Counter();
        //  counter.increment();

        // or interact with an existing deployment by specifying a `fork` url in `dbg.project.json`
        // eg:
        //  ICounter counter = ICounter(0x12345678.....)
        //  counter.increment(); 
        //
        // If you have correct symbols (`artifacts`) for the deployed contract, you can step-into calls.

        uint256 abc = 123;
        uint256 def = abc + 5;

        emit EvmPrint("DbgEntry return");
    }
}