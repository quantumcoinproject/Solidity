contract C {
	event Test(function() external indexed);
	function f() public {
		emit Test(this.f);
	}
}
// ----
// TypeError 4666: (25-52): External function types are not supported with 32-byte addresses.
