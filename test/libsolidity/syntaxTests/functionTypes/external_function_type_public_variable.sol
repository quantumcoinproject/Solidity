contract C {
    function (uint) external public x;

    function g(uint) public {
        x = this.g;
    }
    function f() public view returns (function(uint) external) {
        return this.x();
    }
}
// ----
// TypeError 4666: (17-48): External function types are not supported with 32-byte addresses.
// TypeError 4666: (147-171): External function types are not supported with 32-byte addresses.
