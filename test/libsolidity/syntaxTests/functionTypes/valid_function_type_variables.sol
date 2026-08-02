contract test {
    function fa(uint) public {}
    function fb(uint) internal {}
    function fc(uint) internal {}
    function fd(uint) external {}
    function fe(uint) external {}
    function ff(uint) internal {}
    function fg(uint) internal pure {}
    function fh(uint) pure internal {}

    function(uint) a = fa;
    function(uint) internal b = fb; // (explicit internal applies to the function type)
    function(uint) internal internal c = fc;
    function(uint) external d = this.fd;
    function(uint) external internal e = this.fe;
    function(uint) internal f = ff;
    function(uint) internal pure g = fg;
    function(uint) pure internal h = fh;
}
// ----
// TypeError 4666: (461-486): External function types are not supported with 32-byte addresses.
// TypeError 4666: (502-534): External function types are not supported with 32-byte addresses.
