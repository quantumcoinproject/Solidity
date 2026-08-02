contract C {
    function h() pure external {
    }
    function f() view external returns (bytes4) {
        function () view external g = this.h;
        return g.selector;
    }
}
// ----
// TypeError 4666: (110-137): External function types are not supported with 32-byte addresses.
