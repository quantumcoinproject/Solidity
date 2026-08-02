contract test {
    struct S {
        function (uint x, uint y) internal returns (uint) f;
        function (uint, uint) external returns (uint) g;
        uint d;
    }
}
// ----
// Warning 6162: (49-55): Naming function type parameters is deprecated.
// Warning 6162: (57-63): Naming function type parameters is deprecated.
// TypeError 4666: (100-147): External function types are not supported with 32-byte addresses.
