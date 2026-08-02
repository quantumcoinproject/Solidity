contract test {
    function a(bytes32 h, uint8 v, bytes32 r, bytes32 s) public returns (address addr) {
        return ecrecover(h, v, r, s);
    }
}
// ----
// TypeError 9999: (75-84): "ecrecover" has been removed. This function is not available.
