contract C {
    function h() pure external {
    }
    function f() view external returns (bytes4) {
        function () external g = this.h;
        return g.selector;
    }
}
// ----
// TypeError 4666: (110-132): External function types are not supported with 32-byte addresses.
