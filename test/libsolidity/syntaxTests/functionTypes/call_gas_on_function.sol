contract C {
    function (uint) external returns (uint) x;
    function f() public {
        x{gas: 2}(1);
    }
}

// ----
// TypeError 4666: (17-58): External function types are not supported with 32-byte addresses.
