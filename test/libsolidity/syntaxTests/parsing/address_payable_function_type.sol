contract C {
    function (address payable) view internal returns (address payable) f;
    function g(function (address payable) payable external returns (address payable)) public payable returns (function (address payable) payable external returns (address payable)) {
        function (address payable) payable external returns (address payable) h; h;
    }
}
// ----
// TypeError 4666: (102-172): External function types are not supported with 32-byte addresses.
// TypeError 4666: (197-267): External function types are not supported with 32-byte addresses.
// TypeError 4666: (278-349): External function types are not supported with 32-byte addresses.
