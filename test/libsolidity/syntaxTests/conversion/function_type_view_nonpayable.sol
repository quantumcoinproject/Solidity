contract C {
	int dummy;
    function h() view external {
		dummy;
    }
    function f() view external returns (bytes4) {
        function () external g = this.h;
        return g.selector;
    }
}
// ----
// TypeError 4666: (131-153): External function types are not supported with 32-byte addresses.
