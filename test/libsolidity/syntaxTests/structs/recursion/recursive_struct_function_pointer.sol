pragma abicoder               v2;
contract C {
    struct S {
        uint a;
        function() external returns (S memory) sub;
    }
    function f() public pure returns (S memory) {
    }
}
// ----
// TypeError 4666: (86-128): External function types are not supported with 32-byte addresses.
