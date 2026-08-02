contract A {
    function f() external {}
    function g() external pure {}
}

contract B is A {
    function h() external {
        function() external f = A.f;
        function() external pure g = A.g;
    }
}
// ----
// TypeError 4666: (133-154): External function types are not supported with 32-byte addresses.
// TypeError 9574: (133-160): Type function A.f() is not implicitly convertible to expected type function () external. Special functions can not be converted to function types.
// TypeError 4666: (170-196): External function types are not supported with 32-byte addresses.
// TypeError 9574: (170-202): Type function A.g() pure is not implicitly convertible to expected type function () pure external. Special functions can not be converted to function types.
