.. index:: ! value type, ! type;value
.. _value-types:

Value Types
===========

The following types are also called value types because variables of these
types will always be passed by value, i.e. they are always copied when they
are used as function arguments or in assignments.

.. index:: ! bool, ! true, ! false

Booleans
--------

``bool``: The possible values are constants ``true`` and ``false``.

Operators:

*  ``!`` (logical negation)
*  ``&&`` (logical conjunction, "and")
*  ``||`` (logical disjunction, "or")
*  ``==`` (equality)
*  ``!=`` (inequality)

The operators ``||`` and ``&&`` apply the common short-circuiting rules. This means that in the expression ``f(x) || g(y)``, if ``f(x)`` evaluates to ``true``, ``g(y)`` will not be evaluated even if it may have side-effects.

.. index:: ! uint, ! int, ! integer
.. _integers:

Integers
--------

``int`` / ``uint``: Signed and unsigned integers of various sizes. Keywords ``uint8`` to ``uint256`` in steps of ``8`` (unsigned of 8 up to 256 bits) and ``int8`` to ``int256``. ``uint`` and ``int`` are aliases for ``uint256`` and ``int256``, respectively.

Operators:

* Comparisons: ``<=``, ``<``, ``==``, ``!=``, ``>=``, ``>`` (evaluate to ``bool``)
* Bit operators: ``&``, ``|``, ``^`` (bitwise exclusive or), ``~`` (bitwise negation)
* Shift operators: ``<<`` (left shift), ``>>`` (right shift)
* Arithmetic operators: ``+``, ``-``, unary ``-``, ``*``, ``/``, ``%`` (modulo), ``**`` (exponentiation)

For an integer type ``X``, you can use ``type(X).min`` and ``type(X).max`` to
access the minimum and maximum value representable by the type.

.. warning::

  Integers in Solidity are restricted to a certain range. For example, with ``uint32``, this is ``0`` up to ``2**32 - 1``.
  If the result of some operation on those numbers does not fit inside this range, it is truncated. These truncations can have
  serious consequences that you should :ref:`be aware of and mitigate against<underflow-overflow>`.

Comparisons
^^^^^^^^^^^

The value of a comparison is the one obtained by comparing the integer value.

Bit operations
^^^^^^^^^^^^^^

Bit operations are performed on the two's complement representation of the number.
This means that, for example ``~int256(0) == int256(-1)``.

Shifts
^^^^^^

The result of a shift operation has the type of the left operand, truncating the result to match the type.
Right operand must be unsigned type. Trying to shift by signed type will produce a compilation error.

- For positive and negative ``x`` values, ``x << y`` is equivalent to ``x * 2**y``.
- For positive ``x`` values,  ``x >> y`` is equivalent to ``x / 2**y``.
- For negative ``x`` values, ``x >> y`` is equivalent to ``(x + 1) / 2**y - 1`` (which is the same as dividing ``x`` by ``2**y`` while rounding down towards negative infinity).

.. warning::
    Before version ``0.5.0`` a right shift ``x >> y`` for negative ``x`` was equivalent to ``x / 2**y``,
    i.e., right shifts used rounding up (towards zero) instead of rounding down (towards negative infinity).

Addition, Subtraction and Multiplication
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Addition, subtraction and multiplication have the usual semantics.
They wrap in two's complement representation, meaning that
for example ``uint256(0) - uint256(1) == 2**256 - 1``. You have to take these overflows
into account when designing safe smart contracts.

The expression ``-x`` is equivalent to ``(T(0) - x)`` where
``T`` is the type of ``x``. This means that ``-x`` will not be negative
if the type of ``x`` is an unsigned integer type. Also, ``-x`` can be
positive if ``x`` is negative. There is another caveat also resulting
from two's complement representation::

    int x = -2**255;
    assert(-x == x);

This means that even if a number is negative, you cannot assume that
its negation will be positive.


Division
^^^^^^^^

Since the type of the result of an operation is always the type of one of
the operands, division on integers always results in an integer.
In Solidity, division rounds towards zero. This mean that ``int256(-5) / int256(2) == int256(-2)``.

Note that in contrast, division on :ref:`literals<rational_literals>` results in fractional values
of arbitrary precision.

.. note::
  Division by zero causes a failing assert.

Modulo
^^^^^^

The modulo operation ``a % n`` yields the remainder ``r`` after the division of the operand ``a``
by the operand ``n``, where ``q = int(a / n)`` and ``r = a - (n * q)``. This means that modulo
results in the same sign as its left operand (or zero) and ``a % n == -(-a % n)`` holds for negative ``a``:

 * ``int256(5) % int256(2) == int256(1)``
 * ``int256(5) % int256(-2) == int256(1)``
 * ``int256(-5) % int256(2) == int256(-1)``
 * ``int256(-5) % int256(-2) == int256(-1)``

.. note::
  Modulo with zero causes a failing assert.

Exponentiation
^^^^^^^^^^^^^^

Exponentiation is only available for unsigned types in the exponent. The resulting type
of an exponentiation is always equal to the type of the base. Please take care that it is
large enough to hold the result and prepare for potential wrapping behaviour.

.. note::
  Note that ``0**0`` is defined by the EVM as ``1``.

.. index:: ! ufixed, ! fixed, ! fixed point number

Fixed Point Numbers
-------------------

.. warning::
    Fixed point numbers are not fully supported by Solidity yet. They can be declared, but
    cannot be assigned to or from.

``fixed`` / ``ufixed``: Signed and unsigned fixed point number of various sizes. Keywords ``ufixedMxN`` and ``fixedMxN``, where ``M`` represents the number of bits taken by
the type and ``N`` represents how many decimal points are available. ``M`` must be divisible by 8 and goes from 8 to 256 bits. ``N`` must be between 0 and 80, inclusive.
``ufixed`` and ``fixed`` are aliases for ``ufixed128x18`` and ``fixed128x18``, respectively.

Operators:

* Comparisons: ``<=``, ``<``, ``==``, ``!=``, ``>=``, ``>`` (evaluate to ``bool``)
* Arithmetic operators: ``+``, ``-``, unary ``-``, ``*``, ``/``, ``%`` (modulo)

.. note::
    The main difference between floating point (``float`` and ``double`` in many languages, more precisely IEEE 754 numbers) and fixed point numbers is
    that the number of bits used for the integer and the fractional part (the part after the decimal dot) is flexible in the former, while it is strictly
    defined in the latter. Generally, in floating point almost the entire space is used to represent the number, while only a small number of bits define
    where the decimal point is.

.. index:: address, balance, send, call, delegatecall, staticcall, transfer

.. _address:

Address
-------

The address type comes in two flavours, which are largely identical:

 - ``address``: Holds a 32 byte value (size of an Ethereum address).
 - ``address payable``: Same as ``address``, but with the additional members ``transfer`` and ``send``.

The idea behind this distinction is that ``address payable`` is an address you can send Ether to,
while a plain ``address`` cannot be sent Ether.

Type conversions:

Implicit conversions from ``address payable`` to ``address`` are allowed, whereas conversions from ``address`` to ``address payable``
must be explicit via ``payable(<address>)``.

:ref:`Address literals<address_literals>` can be implicitly converted to ``address payable``.

Explicit conversions to and from ``address`` are allowed for integers, integer literals, ``bytes32`` and contract types with the following
caveat:
The result of a conversion of the form ``address(x)``
has the type ``address payable``, if ``x`` is of integer or fixed bytes type,
a literal or a contract with a receive or payable fallback function.
If ``x`` is a contract without a receive or payable fallback function,
then ``address(x)`` will be of type ``address``.
In external function signatures ``address`` is used for both the ``address`` and the ``address payable`` type.

Only expressions of type ``address`` can be converted to type ``address payable`` via ``payable(<address>)``.

.. note::
    It might very well be that you do not need to care about the distinction between ``address``
    and ``address payable`` and just use ``address`` everywhere. For example,
    if you are using the :ref:`withdrawal pattern<withdrawal_pattern>`, you can (and should) store the
    address itself as ``address``, because you invoke the ``transfer`` function on
    ``msg.sender``, which is an ``address payable``.

Operators:

* ``<=``, ``<``, ``==``, ``!=``, ``>=`` and ``>``

.. warning::
    If you convert a type that uses a larger byte size to an ``address``, for example ``bytes32``, then the ``address`` is truncated.
    To reduce conversion ambiguity version 0.4.24 and higher of the compiler force you make the truncation explicit in the conversion.
    Take for example the 32-byte value ``0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCC``.

    You can use ``address(uint256(bytes32(b)))``, which results in ``0x111122223333444455556666777788889999aAaa``,
    or you can use ``address(uint256(uint256(b)))``, which results in ``0x777788889999AaAAbBbbCcccddDdeeeEfFFfCcCc``.

.. note::
    The distinction between ``address`` and ``address payable`` was introduced with version 0.5.0.
    Also starting from that version, contracts do not derive from the address type, but can still be explicitly converted to
    ``address`` or to ``address payable``, if they have a receive or payable fallback function.

.. _members-of-addresses:

Members of Addresses
^^^^^^^^^^^^^^^^^^^^

For a quick reference of all members of address, see :ref:`address_related`.

* ``balance`` and ``transfer``

It is possible to query the balance of an address using the property ``balance``
and to send Ether (in units of wei) to a payable address using the ``transfer`` function:

::

    address payable x = address(0x123);
    address myAddress = address(this);
    if (x.balance < 10 && myAddress.balance >= 10) x.transfer(10);

The ``transfer`` function fails if the balance of the current contract is not large enough
or if the Ether transfer is rejected by the receiving account. The ``transfer`` function
reverts on failure.

.. note::
    If ``x`` is a contract address, its code (more specifically: its :ref:`receive-ether-function`, if present, or otherwise its :ref:`fallback-function`, if present) will be executed together with the ``transfer`` call (this is a feature of the EVM and cannot be prevented). If that execution runs out of gas or fails in any way, the Ether transfer will be reverted and the current contract will stop with an exception.

* ``send``

Send is the low-level counterpart of ``transfer``. If the execution fails, the current contract will not stop with an exception, but ``send`` will return ``false``.

.. warning::
    There are some dangers in using ``send``: The transfer fails if the call stack depth is at 1024
    (this can always be forced by the caller) and it also fails if the recipient runs out of gas. So in order
    to make safe Ether transfers, always check the return value of ``send``, use ``transfer`` or even better:
    use a pattern where the recipient withdraws the money.

* ``call``, ``delegatecall`` and ``staticcall``

In order to interface with contracts that do not adhere to the ABI,
or to get more direct control over the encoding,
the functions ``call``, ``delegatecall`` and ``staticcall`` are provided.
They all take a single ``bytes memory`` parameter and
return the success condition (as a ``bool``) and the returned data
(``bytes memory``).
The functions ``abi.encode``, ``abi.encodePacked``, ``abi.encodeWithSelector``
and ``abi.encodeWithSignature`` can be used to encode structured data.

Example::

    bytes memory payload = abi.encodeWithSignature("register(string)", "MyName");
    (bool success, bytes memory returnData) = address(nameReg).call(payload);
    require(success);

.. warning::
    All these functions are low-level functions and should be used with care.
    Specifically, any unknown contract might be malicious and if you call it, you
    hand over control to that contract which could in turn call back into
    your contract, so be prepared for changes to your state variables
    when the call returns. The regular way to interact with other contracts
    is to call a function on a contract object (``x.f()``).

.. note::
    Previous versions of Solidity allowed these functions to receive
    arbitrary arguments and would also handle a first argument of type
    ``bytes4`` differently. These edge cases were removed in version 0.5.0.

It is possible to adjust the supplied gas with the ``gas`` modifier::

    address(nameReg).call{gas: 1000000}(abi.encodeWithSignature("register(string)", "MyName"));

Similarly, the supplied Ether value can be controlled too::

    address(nameReg).call{value: 1 ether}(abi.encodeWithSignature("register(string)", "MyName"));

Lastly, these modifiers can be combined. Their order does not matter::

    address(nameReg).call{gas: 1000000, value: 1 ether}(abi.encodeWithSignature("register(string)", "MyName"));

In a similar way, the function ``delegatecall`` can be used: the difference is that only the code of the given address is used, all other aspects (storage, balance, ...) are taken from the current contract. The purpose of ``delegatecall`` is to use library code which is stored in another contract. The user has to ensure that the layout of storage in both contracts is suitable for delegatecall to be used.

.. note::
    Prior to homestead, only a limited variant called ``callcode`` was available that did not provide access to the original ``msg.sender`` and ``msg.value`` values. This function was removed in version 0.5.0.

Since byzantium ``staticcall`` can be used as well. This is basically the same as ``call``, but will revert if the called function modifies the state in any way.

All three functions ``call``, ``delegatecall`` and ``staticcall`` are very low-level functions and should only be used as a *last resort* as they break the type-safety of Solidity.

The ``gas`` option is available on all three methods, while the ``value`` option is not
supported for ``delegatecall``.

.. note::
    It is best to avoid relying on hardcoded gas values in your smart contract code,
    regardless of whether state is read from or written to, as this can have many pitfalls.
    Also, access to gas might change in the future.

.. note::
    All contracts can be converted to ``address`` type, so it is possible to query the balance of the
    current contract using ``address(this).balance``.

.. index:: ! contract type, ! type; contract

.. _contract_types:

Contract Types
--------------

Every :ref:`contract<contracts>` defines its own type.
You can implicitly convert contracts to contracts they inherit from.
Contracts can be explicitly converted to and from the ``address`` type.

Explicit conversion to and from the ``address payable`` type is only possible
if the contract type has a receive or payable fallback function.  The conversion is still
performed using ``address(x)``. If the contract type does not have a receive or payable
fallback function, the conversion to ``address payable`` can be done using
``payable(address(x))``.
You can find more information in the section about
the :ref:`address type<address>`.

.. note::
    Before version 0.5.0, contracts directly derived from the address type
    and there was no distinction between ``address`` and ``address payable``.

If you declare a local variable of contract type (``MyContract c``), you can call
functions on that contract. Take care to assign it from somewhere that is the
same contract type.

You can also instantiate contracts (which means they are newly created). You
can find more details in the :ref:`'Contracts via new'<creating-contracts>`
section.

The data representation of a contract is identical to that of the ``address``
type and this type is also used in the :ref:`ABI<ABI>`.

Contracts do not support any operators.

The members of contract types are the external functions of the contract
including any state variables marked as ``public``.

For a contract ``C`` you can use ``type(C)`` to access
:ref:`type information<meta-type>` about the contract.

.. index:: byte array, bytes32

Fixed-size byte arrays
----------------------

The value types ``bytes1``, ``bytes2``, ``bytes3``, ..., ``bytes32``
hold a sequence of bytes from one to up to 32.
``byte`` is an alias for ``bytes1``.

Operators:

* Comparisons: ``<=``, ``<``, ``==``, ``!=``, ``>=``, ``>`` (evaluate to ``bool``)
* Bit operators: ``&``, ``|``, ``^`` (bitwise exclusive or), ``~`` (bitwise negation)
* Shift operators: ``<<`` (left shift), ``>>`` (right shift)
* Index access: If ``x`` is of type ``bytesI``, then ``x[k]`` for ``0 <= k < I`` returns the ``k`` th byte (read-only).

The shifting operator works with unsigned integer type as right operand (but
returns the type of the left operand), which denotes the number of bits to shift by.
Shifting by a signed type will produce a compilation error.

Members:

* ``.length`` yields the fixed length of the byte array (read-only).

.. note::
    The type ``byte[]`` is an array of bytes, but due to padding rules, it wastes
    31 bytes of space for each element (except in storage). It is better to use the ``bytes``
    type instead.

Dynamically-sized byte array
----------------------------

``bytes``:
    Dynamically-sized byte array, see :ref:`arrays`. Not a value-type!
``string``:
    Dynamically-sized UTF-8-encoded string, see :ref:`arrays`. Not a value-type!

.. index:: address, literal;address

.. _address_literals:

Address Literals
----------------

Hexadecimal literals that pass the address checksum test, for example
``0xdCad3a6d3569DF655070DEd06cb7A1b2Ccd1D3AF`` are of ``address payable`` type.
Hexadecimal literals that are between 39 and 41 digits
long and do not pass the checksum test produce
an error. You can prepend (for integer types) or append (for bytesNN types) zeros to remove the error.

.. note::
    The mixed-case address checksum format is defined in `EIP-55 <https://github.com/ethereum/EIPs/blob/master/EIPS/eip-55.md>`_.

.. index:: literal, literal;rational

.. _rational_literals:

Rational and Integer Literals
-----------------------------

Integer literals are formed from a sequence of numbers in the range 0-9.
They are interpreted as decimals. For example, ``69`` means sixty nine.
Octal literals do not exist in Solidity and leading zeros are invalid.

Decimal fraction literals are formed by a ``.`` with at least one number on
one side.  Examples include ``1.``, ``.1`` and ``1.3``.

Scientific notation is also supported, where the base can have fractions and the exponent cannot.
Examples include ``2e10``, ``-2e10``, ``2e-10``, ``2.5e1``.

Underscores can be used to separate the digits of a numeric literal to aid readability.
For example, decimal ``123_000``, hexadecimal ``0x2eff_abde``, scientific decimal notation ``1_2e345_678`` are all valid.
Underscores are only allowed between two digits and only one consecutive underscore is allowed.
There is no additional semantic meaning added to a number literal containing underscores,
the underscores are ignored.

Number literal expressions retain arbitrary precision until they are converted to a non-literal type (i.e. by
using them together with a non-literal expression or by explicit conversion).
This means that computations do not overflow and divisions do not truncate
in number literal expressions.

For example, ``(2**800 + 1) - 2**800`` results in the constant ``1`` (of type ``uint8``)
although intermediate results would not even fit the machine word size. Furthermore, ``.5 * 8`` results
in the integer ``4`` (although non-integers were used in between).

Any operator that can be applied to integers can also be applied to number literal expressions as
long as the operands are integers. If any of the two is fractional, bit operations are disallowed
and exponentiation is disallowed if the exponent is fractional (because that might result in
a non-rational number).

Shifts and exponentiation with literal numbers as left (or base) operand and integer types
as the right (exponent) operand are always performed
in the ``uint256`` (for non-negative literals) or ``int256`` (for a negative literals) type,
regardless of the type of the right (exponent) operand.

.. warning::
    Division on integer literals used to truncate in Solidity prior to version 0.4.0, but it now converts into a rational number, i.e. ``5 / 2`` is not equal to ``2``, but to ``2.5``.

.. note::
    Solidity has a number literal type for each rational number.
    Integer literals and rational number literals belong to number literal types.
    Moreover, all number literal expressions (i.e. the expressions that
    contain only number literals and operators) belong to number literal
    types.  So the number literal expressions ``1 + 2`` and ``2 + 1`` both
    belong to the same number literal type for the rational number three.


.. note::
    Number literal expressions are converted into a non-literal type as soon as they are used with non-literal
    expressions. Disregarding types, the value of the expression assigned to ``b``
    below evaluates to an integer. Because ``a`` is of type ``uint128``, the
    expression ``2.5 + a`` has to have a proper type, though. Since there is no common type
    for the type of ``2.5`` and ``uint128``, the Solidity compiler does not accept
    this code.

::

    uint128 a = 1;
    uint128 b = 2.5 + a + 0.5;

.. index:: literal, literal;string, string
.. _string_literals:

String Literals and Types
-------------------------

String literals are written with either double or single-quotes (``"foo"`` or ``'bar'``), and they can also be split into multiple consecutive parts (``"foo" "bar"`` is equivalent to ``"foobar"``) which can be helpful when dealing with long strings.  They do not imply trailing zeroes as in C; ``"foo"`` represents three bytes, not four.  As with integer literals, their type can vary, but they are implicitly convertible to ``bytes1``, ..., ``bytes32``, if they fit, to ``bytes`` and to ``string``.

For example, with ``bytes32 samevar = "stringliteral"`` the string literal is interpreted in its raw byte form when assigned to a ``bytes32`` type.

String literals can only contain printable ASCII characters, which means the characters between and including 0x1F .. 0x7E.

Additionally, string literals also support the following escape characters:

 - ``\<newline>`` (escapes an actual newline)
 - ``\\`` (backslash)
 - ``\'`` (single quote)
 - ``\"`` (double quote)
 - ``\b`` (backspace)
 - ``\f`` (form feed)
 - ``\n`` (newline)
 - ``\r`` (carriage return)
 - ``\t`` (tab)
 - ``\v`` (vertical tab)
 - ``\xNN`` (hex escape, see below)
 - ``\uNNNN`` (unicode escape, see below)

``\xNN`` takes a hex value and inserts the appropriate byte, while ``\uNNNN`` takes a Unicode codepoint and inserts an UTF-8 sequence.

The string in the following example has a length of ten bytes.
It starts with a newline byte, followed by a double quote, a single
quote a backslash character and then (without separator) the
character sequence ``abcdef``.

::

    "\n\"\'\\abc\
    def"

Any Unicode line terminator which is not a newline (i.e. LF, VF, FF, CR, NEL, LS, PS) is considered to
terminate the string literal. Newline only terminates the string literal if it is not preceded by a ``\``.

Unicode Literals
----------------

While regular string literals can only contain ASCII, Unicode literals – prefixed with the keyword ``unicode`` – can contain any valid UTF-8 sequence.
They also support the very same escape sequences as regular string literals.

::

    string memory a = unicode"Hello 😃";

.. index:: literal, bytes

Hexadecimal Literals
--------------------

Hexadecimal literals are prefixed with the keyword ``hex`` and are enclosed in double
or single-quotes (``hex"001122FF"``, ``hex'0011_22_FF'``). Their content must be
hexadecimal digits which can optionally use a single underscore as separator between
byte boundaries. The value of the literal will be the binary representation
of the hexadecimal sequence.

Multiple hexadecimal literals separated by whitespace are concatenated into a single literal:
``hex"00112233" hex"44556677"`` is equivalent to ``hex"0011223344556677"``

Hexadecimal literals behave like :ref:`string literals <string_literals>` and have the same convertibility restrictions.

.. index:: enum

.. _enums:

Enums
-----

Enums are one way to create a user-defined type in Solidity. They are explicitly convertible
to and from all integer types but implicit conversion is not allowed.  The explicit conversion
from integer checks at runtime that the value lies inside the range of the enum and causes a failing assert otherwise.
Enums require at least one member, and its default value when declared is the first member.

The data representation is the same as for enums in C: The options are represented by
subsequent unsigned integer values starting from ``0``.


::

    // SPDX-License-Identifier: GPL-3.0
    pragma solidity >=0.4.16 <0.8.0;

    contract test {
        enum ActionChoices { GoLeft, GoRight, GoStraight, SitStill }
        ActionChoices choice;
        ActionChoices constant defaultChoice = ActionChoices.GoStraight;

        function setGoStraight() public {
            choice = ActionChoices.GoStraight;
        }

        // Since enum types are not part of the ABI, the signature of "getChoice"
        // will automatically be changed to "getChoice() returns (uint8)"
        // for all matters external to Solidity. The integer type used is just
        // large enough to hold all enum values, i.e. if you have more than 256 values,
        // `uint16` will be used and so on.
        function getChoice() public view returns (ActionChoices) {
            return choice;
        }

        function getDefaultChoice() public pure returns (uint) {
            return uint(defaultChoice);
        }
    }

.. note::
    Enums can also be declared on the file level, outside of contract or library definitions.


.. index:: ! function type, ! type; function

.. _function_types:

Function Types
--------------

.. warning::

  Function types are not supported.
