contract C {
    // The Quantum Coin node removed the ecrecover (0x01) and bn256
    // (0x06-0x08) precompiles. Calls to those addresses behave like calls to
    // any empty account: they succeed and return empty data (fail open).
    function callRemoved(uint256 which) internal returns (bool ok, uint256 len) {
        (bool success, bytes memory ret) = address(which).call("");
        return (success, ret.length);
    }
    function f() public returns (bool, uint256) {
        return callRemoved(1);
    }
    function g() public returns (bool, uint256) {
        return callRemoved(6);
    }
    function h() public returns (bool, uint256) {
        return callRemoved(8);
    }
}
// ----
// f() -> true, 0
// g() -> true, 0
// h() -> true, 0
