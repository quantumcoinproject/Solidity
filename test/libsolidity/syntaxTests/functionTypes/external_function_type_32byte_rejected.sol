contract C {
    function ft(function(uint) external returns (uint) f) public {}
}
// ----
// TypeError 4666: (29-69): External function types are not supported with 32-byte addresses.
