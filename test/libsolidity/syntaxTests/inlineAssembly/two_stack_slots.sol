contract C {
    function f() pure external {
        function() external two_stack_slots;
        assembly {
            let x :=  two_stack_slots
        }
    }
}
// ----
// TypeError 4666: (54-89): External function types are not supported with 32-byte addresses.
// TypeError 9857: (132-147): Only types that use one stack slot are supported.
