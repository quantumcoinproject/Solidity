contract C {
    function f() public {
        ecrecover.gas();
    }
}
// ----
// TypeError 9999: (47-56): "ecrecover" has been removed. This function is not available.
