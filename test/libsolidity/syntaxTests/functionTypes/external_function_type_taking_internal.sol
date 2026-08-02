contract C {
    function(function () internal) external x;
}
// ----
// TypeError 4666: (17-58): External function types are not supported with 32-byte addresses.
// TypeError 2582: (26-47): Internal type cannot be used for external function type.
