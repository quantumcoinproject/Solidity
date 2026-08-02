contract C {
    function (uint) external returns (uint) x;
    function g() public {
        x{value: 2}(1);
    }
}
// ----
// TypeError 4666: (17-58): External function types are not supported with 32-byte addresses.
// TypeError 7006: (94-105): Cannot set option "value" on a non-payable function type.
