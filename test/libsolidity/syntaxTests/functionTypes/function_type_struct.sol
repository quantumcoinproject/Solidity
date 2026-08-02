library L
{
	struct Nested
	{
		uint y;
	}
	function f(function(Nested memory) external) external pure {}
}
// ----
// TypeError 4666: (55-88): External function types are not supported with 32-byte addresses.
