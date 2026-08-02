contract C {
    function h() external {
    }
    function f() view external returns (bytes4) {
        function () payable external g = this.h;
        return g.selector;
    }
}
// ----
// TypeError 4666: (105-135): External function types are not supported with 32-byte addresses.
// TypeError 9574: (105-144): Type function () external is not implicitly convertible to expected type function () payable external.
