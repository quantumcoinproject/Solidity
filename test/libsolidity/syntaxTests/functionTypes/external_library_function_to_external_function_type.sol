library L {
    function f(uint256 _a) external returns (uint256) {}
}

contract C {
    function run(function(uint256) external returns (uint256) _operation) internal returns (uint256) {}
    function test() public {
        run(L.f);
        function(uint256) external returns (uint256) _operation = L.f;
    }
}
// ----
// TypeError 4666: (102-157): External function types are not supported with 32-byte addresses.
// TypeError 9553: (230-233): Invalid type for argument in function call. Invalid implicit conversion from function (uint256) returns (uint256) to function (uint256) external returns (uint256) requested. Special functions can not be converted to function types.
// TypeError 4666: (244-299): External function types are not supported with 32-byte addresses.
// TypeError 9574: (244-305): Type function (uint256) returns (uint256) is not implicitly convertible to expected type function (uint256) external returns (uint256). Special functions can not be converted to function types.
