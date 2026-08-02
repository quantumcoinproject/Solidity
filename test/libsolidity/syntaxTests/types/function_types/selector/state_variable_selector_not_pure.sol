contract A {
    function() external public f;
}
contract B {
    function() external public g;
}

contract C is B {
    function() external public h;
    bytes4 constant s1 = h.selector;
    bytes4 constant s2 = B.g.selector;
    bytes4 constant s3 = this.h.selector;
}
// ----
// TypeError 4666: (17-43): External function types are not supported with 32-byte addresses.
// TypeError 4666: (66-92): External function types are not supported with 32-byte addresses.
// TypeError 4666: (121-147): External function types are not supported with 32-byte addresses.
// TypeError 8349: (176-186): Initial value for constant variable has to be compile-time constant.
// TypeError 8349: (213-225): Initial value for constant variable has to be compile-time constant.
// TypeError 8349: (252-267): Initial value for constant variable has to be compile-time constant.
