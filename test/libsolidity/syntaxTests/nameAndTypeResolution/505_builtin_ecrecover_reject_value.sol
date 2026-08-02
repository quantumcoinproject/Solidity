contract C {
    function f() public {
        ecrecover.value();
    }
}
// ----
// DeclarationError 7576: (47-56): Undeclared identifier.
