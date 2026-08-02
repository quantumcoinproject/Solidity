contract C {
    function (uint) external payable returns (uint) x;
    function f() public {
        x{value: 2}(1);
    }
}
// ----
// TypeError 4666: (17-66): External function types are not supported with 32-byte addresses.
