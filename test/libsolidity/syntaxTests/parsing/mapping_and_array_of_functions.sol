contract test {
    mapping (address => function() internal returns (uint)) a;
    mapping (address => function() external) b;
    mapping (address => function() external[]) c;
    function() external[] d;
}
// ----
// TypeError 4666: (103-123): External function types are not supported with 32-byte addresses.
// TypeError 4666: (151-171): External function types are not supported with 32-byte addresses.
// TypeError 4666: (181-201): External function types are not supported with 32-byte addresses.
