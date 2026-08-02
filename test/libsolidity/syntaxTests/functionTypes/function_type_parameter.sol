contract C {
    uint x;
    function f(function(uint) external returns (uint) g) public returns (function(uint) external returns (uint)) {
        x = 2;
        return g;
    }
}
// ----
// TypeError 4666: (40-80): External function types are not supported with 32-byte addresses.
// TypeError 4666: (98-137): External function types are not supported with 32-byte addresses.
