// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.0;

contract C
{
    constructor() {}

    function foo() public pure returns (bool)
    {
        uint a = 100;
        uint b = a;
        uint c = a;

        return a == 100;
    }
}
