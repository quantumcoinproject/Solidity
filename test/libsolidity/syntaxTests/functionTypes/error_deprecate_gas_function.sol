contract C {
    function (uint) external payable returns (uint) x;
    function f() public {
        x.gas(2)(1);
    }
}
// ----
// TypeError 4666: (17-66): External function types are not supported with 32-byte addresses.
// TypeError 1621: (102-107): Using ".gas(...)" is deprecated. Use "{gas: ...}" instead.
