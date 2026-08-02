pragma abicoder               v2;
contract C {
    struct S { function (uint) external returns (uint) fn; }
    function f(S calldata s) external returns (uint256 a) {
        return s.fn(42);
    }
}
// ----
// TypeError 4666: (62-104): External function types are not supported with 32-byte addresses.
