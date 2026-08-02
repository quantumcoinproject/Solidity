pragma abicoder               v2;

contract C {
    struct S1 { function() external a; }
    struct S2 { bytes24 a; }
    function f(S1 memory) public pure {}
    function f(S2 memory) public pure {}
}
// ----
// TypeError 4666: (64-85): External function types are not supported with 32-byte addresses.
