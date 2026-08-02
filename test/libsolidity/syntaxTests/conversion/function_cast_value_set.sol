contract C {
	function f() public payable {
		function() external payable x = this.f{value: 7};
	}
}
// ----
// TypeError 4666: (46-75): External function types are not supported with 32-byte addresses.
// TypeError 9574: (46-94): Type function () payable external is not implicitly convertible to expected type function () payable external.
