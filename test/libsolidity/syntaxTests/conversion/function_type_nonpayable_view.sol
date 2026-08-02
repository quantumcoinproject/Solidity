contract C {
    function h() external {
    }
    function f() view external returns (bytes4) {
        function () view external g = this.h;
        return g.selector;
    }
}
// ----
// TypeError 4666: (105-132): External function types are not supported with 32-byte addresses.
// TypeError 9574: (105-141): Type function () external is not implicitly convertible to expected type function () view external.
