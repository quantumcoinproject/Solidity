contract C {
    function h() view external {
    }
    function f() view external returns (bytes4) {
        function () payable external g = this.h;
        return g.selector;
    }
}
// ----
// TypeError 4666: (110-140): External function types are not supported with 32-byte addresses.
// TypeError 9574: (110-149): Type function () view external is not implicitly convertible to expected type function () payable external.
