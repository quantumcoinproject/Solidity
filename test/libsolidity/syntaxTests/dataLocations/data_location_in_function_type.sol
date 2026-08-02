library L {
    struct Nested { uint y; }
    function c(function(Nested memory) external returns (uint)[] storage) external pure {}
}
// ----
// TypeError 4666: (57-105): External function types are not supported with 32-byte addresses.
