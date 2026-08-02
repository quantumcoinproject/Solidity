contract C {
    function f() pure public {
        function () external nonpayFun;
        function () external view viewFun;
        function () external pure pureFun;

        nonpayFun;
        viewFun;
        pureFun;
        pureFun();
    }
    function g() view public {
        function () external view viewFun;

        viewFun();
    }
    function h() public {
        function () external nonpayFun;

        nonpayFun();
    }
}
// ----
// TypeError 4666: (52-82): External function types are not supported with 32-byte addresses.
// TypeError 4666: (92-125): External function types are not supported with 32-byte addresses.
// TypeError 4666: (135-168): External function types are not supported with 32-byte addresses.
// TypeError 4666: (288-321): External function types are not supported with 32-byte addresses.
// TypeError 4666: (383-413): External function types are not supported with 32-byte addresses.
