contract A {
    function f() external {}
    function g() external pure {}
}

contract B {
    function h() external {
        function() external f = A.f;
        function() external pure g = A.g;
    }
}
// ----
// TypeError 4666: (128-149): External function types are not supported with 32-byte addresses.
// TypeError 9574: (128-155): Type function A.f() is not implicitly convertible to expected type function () external. Special functions can not be converted to function types.
// TypeError 4666: (165-191): External function types are not supported with 32-byte addresses.
// TypeError 9574: (165-197): Type function A.g() pure is not implicitly convertible to expected type function () pure external. Special functions can not be converted to function types.
