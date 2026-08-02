contract C {
    function(uint) external returns (uint) f;
}
// ----
// TypeError 4666: (17-57): External function types are not supported with 32-byte addresses.
