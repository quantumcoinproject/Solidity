contract test {
    function f(function(uint) external returns (uint) g) internal returns (uint a) {
        return g(1);
    }
}
// ----
// TypeError 4666: (31-71): External function types are not supported with 32-byte addresses.
