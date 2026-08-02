contract C {
    function f() pure public {
        function () external nonpayFun;
        nonpayFun();
    }
    function g() pure public {
        function () external view viewFun;
        viewFun();
    }
    function h() view public {
        function () external nonpayFun;
        nonpayFun();
    }
}
// ----
// TypeError 4666: (52-82): External function types are not supported with 32-byte addresses.
// TypeError 4666: (150-183): External function types are not supported with 32-byte addresses.
// TypeError 4666: (249-279): External function types are not supported with 32-byte addresses.
