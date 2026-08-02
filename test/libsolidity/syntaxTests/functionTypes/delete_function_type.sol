contract C {
    function(uint) external returns (uint) x;
    function(uint) internal returns (uint) y;
    function f() public {
        delete x;
        function(uint) internal returns (uint) a = y;
        delete a;
        delete y;
        function() internal c = f;
        delete c;
        function(uint) internal returns (uint) g;
        delete g;
    }
}
// ----
// TypeError 4666: (17-57): External function types are not supported with 32-byte addresses.
