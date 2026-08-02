contract C {
    function f0() public { (()) = 2; }

    function f1() public pure { (()) = (); }

    //#8711
    function f2() internal pure returns (uint, uint) { return () = f2(); }

    //#8277
    function f3()public{return()=();}

    //#8277
    function f4 ( bytes32 hash , uint8 v , bytes32 r , bytes32 s , uint blockExpired , bytes32 salt ) public returns ( address ) {
        require ( ( ( ) ) |= keccak256 ( abi . encodePacked ( blockExpired , salt ) ) ) ;
        return ecrecover ( hash , v , r , s ) ;
    }
}
// ----
// DeclarationError 7576: (486-495): Undeclared identifier.
