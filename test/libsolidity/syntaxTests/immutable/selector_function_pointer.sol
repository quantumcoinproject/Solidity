contract C {
    uint immutable x;
    constructor() {
        x = 3;
        readX().selector;
    }

    function f() external view returns(uint)  {
        return x;
    }

    function readX() public view returns(function() external view returns(uint) _f) {
        _f = this.f;
    }
}
// ----
// TypeError 4666: (217-258): External function types are not supported with 32-byte addresses.
