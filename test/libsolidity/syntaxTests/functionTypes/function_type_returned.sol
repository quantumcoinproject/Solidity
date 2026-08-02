contract C {
    function f() public pure returns (function(uint) pure external returns (uint) g) {
        return g;
    }
}
// ----
// TypeError 4666: (51-96): External function types are not supported with 32-byte addresses.
