contract C {
    function h() payable external {
    }
    function f() view external returns (bytes4) {
        function () pure external g = this.h;
        return g.selector;
    }
}
// ----
// TypeError 4666: (113-140): External function types are not supported with 32-byte addresses.
// TypeError 9574: (113-149): Type function () payable external is not implicitly convertible to expected type function () pure external.
