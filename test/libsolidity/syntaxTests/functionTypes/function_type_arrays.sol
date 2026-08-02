contract C {
    function(uint) external returns (uint)[] public x;
    function(uint) internal returns (uint)[10] y;
    function f() view public {
        function(uint) returns (uint)[10] memory a;
        function(uint) returns (uint)[10] storage b = y;
        function(uint) external returns (uint)[] memory c;
        c = new function(uint) external returns (uint)[](200);
        a; b;
    }
}
// ----
// TypeError 4666: (17-56): External function types are not supported with 32-byte addresses.
// TypeError 4666: (266-305): External function types are not supported with 32-byte addresses.
// TypeError 4666: (333-372): External function types are not supported with 32-byte addresses.
