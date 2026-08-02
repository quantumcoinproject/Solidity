contract C {
    function() external returns (function () internal) x;
}
// ----
// TypeError 4666: (17-69): External function types are not supported with 32-byte addresses.
// TypeError 2582: (46-67): Internal type cannot be used for external function type.
