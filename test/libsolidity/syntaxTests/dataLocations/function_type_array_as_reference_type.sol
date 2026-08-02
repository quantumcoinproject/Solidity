contract C {
    struct Nested { uint y; }
    // ensure that we consider array of function pointers as reference type
    function b(function(Nested memory) external returns (uint)[] storage) internal pure {}
    function c(function(Nested memory) external returns (uint)[] memory) public pure {}
    function d(function(Nested memory) external returns (uint)[] calldata) external pure {}
}
// ----
// TypeError 4666: (134-182): External function types are not supported with 32-byte addresses.
// TypeError 4666: (225-273): External function types are not supported with 32-byte addresses.
// TypeError 4666: (313-361): External function types are not supported with 32-byte addresses.
