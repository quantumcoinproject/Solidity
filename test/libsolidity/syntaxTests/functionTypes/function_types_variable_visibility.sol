contract C {
    function(bytes memory) a1;
    function(bytes memory) internal b1;
    function(bytes memory) internal internal b2;
    function(bytes memory) external c1;
    function(bytes memory) external internal c2;
    function(bytes memory) external public c3;
}
// ----
// TypeError 4666: (137-171): External function types are not supported with 32-byte addresses.
// TypeError 4666: (177-217): External function types are not supported with 32-byte addresses.
// TypeError 4666: (226-264): External function types are not supported with 32-byte addresses.
