contract C {
    function() external immutable f;
}
// ----
// TypeError 4666: (17-46): External function types are not supported with 32-byte addresses.
// TypeError 3366: (17-48): Immutable variables of external function type are not yet supported.
