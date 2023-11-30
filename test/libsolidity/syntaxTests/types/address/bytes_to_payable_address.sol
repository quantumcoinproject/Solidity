contract C {
    function f(bytes28 x) public pure returns (address payable) {
        return address(x);
    }
}
