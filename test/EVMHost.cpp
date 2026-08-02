/*
	This file is part of solidity.

	solidity is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	solidity is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with solidity.  If not, see <http://www.gnu.org/licenses/>.
*/
// SPDX-License-Identifier: GPL-3.0
/**
 * EVM execution host, i.e. component that implements a simulated Ethereum blockchain
 * for testing purposes.
 */

#include <test/EVMHost.h>

#include <test/evmc/loader.h>

#include <libevmasm/GasMeter.h>

#include <libsolutil/Exceptions.h>
#include <libsolutil/Assertions.h>
#include <libsolutil/Keccak256.h>
#include <libsolutil/picosha2.h>

using namespace std;
using namespace solidity;
using namespace solidity::util;
using namespace solidity::test;
using namespace evmc::literals;

evmc::VM& EVMHost::getVM(string const& _path)
{
	static evmc::VM NullVM{nullptr};
	static map<string, unique_ptr<evmc::VM>> vms;
	if (vms.count(_path) == 0)
	{
		evmc_loader_error_code errorCode = {};
		auto vm = evmc::VM{evmc_load_and_configure(_path.c_str(), &errorCode)};
		if (vm && errorCode == EVMC_LOADER_SUCCESS)
		{
			if (vm.get_capabilities() & (EVMC_CAPABILITY_EVM1 | EVMC_CAPABILITY_EWASM))
				vms[_path] = make_unique<evmc::VM>(evmc::VM(move(vm)));
			else
				cerr << "VM loaded neither supports EVM1 nor EWASM" << endl;
		}
		else
		{
			cerr << "Error loading VM from " << _path;
			if (char const* errorMsg = evmc_last_error_msg())
				cerr << ":" << endl << errorMsg;
			cerr << endl;
		}
	}

	if (vms.count(_path) > 0)
		return *vms[_path];

	return NullVM;
}

bool EVMHost::checkVmPaths(vector<boost::filesystem::path> const& _vmPaths)
{
	bool evmVmFound = false;
	bool ewasmVmFound = false;
	for (auto const& path: _vmPaths)
	{
		evmc::VM& vm = EVMHost::getVM(path.string());
		if (!vm)
			return false;

		if (vm.has_capability(EVMC_CAPABILITY_EVM1))
		{
			if (evmVmFound)
				throw runtime_error("Multiple evm1 evmc vms defined. Please only define one evm1 evmc vm.");
			evmVmFound = true;
		}

		if (vm.has_capability(EVMC_CAPABILITY_EWASM))
		{
			if (ewasmVmFound)
				throw runtime_error("Multiple ewasm evmc vms where defined. Please only define one ewasm evmc vm.");
			ewasmVmFound = true;
		}
	}
	return evmVmFound;
}

EVMHost::EVMHost(langutil::EVMVersion _evmVersion, evmc::VM& _vm):
	m_vm(_vm),
	m_evmVersion(_evmVersion)
{
	if (!m_vm)
	{
		cerr << "Unable to find evmone library" << endl;
		assertThrow(false, Exception, "");
	}

	if (_evmVersion == langutil::EVMVersion::homestead())
		m_evmRevision = EVMC_HOMESTEAD;
	else if (_evmVersion == langutil::EVMVersion::tangerineWhistle())
		m_evmRevision = EVMC_TANGERINE_WHISTLE;
	else if (_evmVersion == langutil::EVMVersion::spuriousDragon())
		m_evmRevision = EVMC_SPURIOUS_DRAGON;
	else if (_evmVersion == langutil::EVMVersion::byzantium())
		m_evmRevision = EVMC_BYZANTIUM;
	else if (_evmVersion == langutil::EVMVersion::constantinople())
		m_evmRevision = EVMC_CONSTANTINOPLE;
	else if (_evmVersion == langutil::EVMVersion::petersburg())
		m_evmRevision = EVMC_PETERSBURG;
	else if (_evmVersion == langutil::EVMVersion::istanbul())
		m_evmRevision = EVMC_ISTANBUL;
	else if (_evmVersion == langutil::EVMVersion::berlin())
		m_evmRevision = EVMC_BERLIN;
	else
		assertThrow(false, Exception, "Unsupported EVM version");

	tx_context.block_difficulty = evmc::uint256be{200000000};
	tx_context.block_gas_limit = 20000000;
	tx_context.block_coinbase = 0x7878787878787878787878787878787878787878787878787878787878787878_address;
	tx_context.tx_gas_price = evmc::uint256be{3000000000};
	tx_context.tx_origin = 0x9292929292929292929292929292929292929292929292929292929292929292_address;
	// Mainnet according to EIP-155
	tx_context.chain_id = evmc::uint256be{1};

	reset();
}

void EVMHost::reset()
{
	accounts.clear();
	m_currentAddress = {};

	// Mark all precompiled contracts as existing. Existing here means to have a balance (as per EIP-161).
	// NOTE: keep this in sync with `EVMHost::call` below.
	//
	// The Quantum Coin node only provides sha256 (0x02), ripemd160 (0x03),
	// identity (0x04), modexp (0x05) and blake2F (0x09); ecrecover (0x01),
	// the bn256 precompiles (0x06-0x08) and bls12-381 were removed. Calls to
	// removed addresses behave like calls to any empty account.
	for (unsigned precompiledAddress: {2u, 3u, 4u, 5u, 9u})
	{
		evmc::address address{precompiledAddress};
		// 1wei
		accounts[address].balance = evmc::uint256be{1};
		// Set according to EIP-1052.
		if (precompiledAddress < 5 || m_evmVersion >= langutil::EVMVersion::byzantium())
			accounts[address].codehash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470_bytes32;
	}
}

void EVMHost::selfdestruct(const evmc::address& _addr, const evmc::address& _beneficiary) noexcept
{
	// TODO actual selfdestruct is even more complicated.
	evmc::uint256be balance = accounts[_addr].balance;
	accounts.erase(_addr);
	accounts[_beneficiary].balance = balance;
}

evmc::result EVMHost::call(evmc_message const& _message) noexcept
{
	// Only the precompiles kept by the Quantum Coin node are dispatched here;
	// removed precompiles (ecrecover at 0x01, bn256 at 0x06-0x08, bls12-381)
	// fall through and behave like calls to empty accounts.
	if (_message.destination == 0x0000000000000000000000000000000000000000000000000000000000000002_address)
		return precompileSha256(_message);
	else if (_message.destination == 0x0000000000000000000000000000000000000000000000000000000000000003_address)
		return precompileRipeMD160(_message);
	else if (_message.destination == 0x0000000000000000000000000000000000000000000000000000000000000004_address)
		return precompileIdentity(_message);
	else if (
		_message.destination == 0x0000000000000000000000000000000000000000000000000000000000000005_address
		&& m_evmVersion >= langutil::EVMVersion::byzantium())
		return precompileModExp(_message);

	auto const stateBackup = accounts;

	u256 value{convertFromEVMC(_message.value)};
	auto& sender = accounts[_message.sender];

	evmc::bytes code;

	evmc_message message = _message;
	if (message.depth == 0)
	{
		message.gas -= message.kind == EVMC_CREATE ? evmasm::GasCosts::txCreateGas : evmasm::GasCosts::txGas;
		for (size_t i = 0; i < message.input_size; ++i)
			message.gas -= message.input_data[i] == 0 ? evmasm::GasCosts::txDataZeroGas : evmasm::GasCosts::txDataNonZeroGas(m_evmVersion);
		if (message.gas < 0)
		{
			evmc::result result({});
			result.status_code = EVMC_OUT_OF_GAS;
			accounts = stateBackup;
			return result;
		}
	}

	if (message.kind == EVMC_CREATE)
	{
		// TODO this is not the right formula
		// TODO is the nonce incremented on failure, too?
		h32B createAddress(keccak256(
			bytes(begin(message.sender.bytes), end(message.sender.bytes)) +
			asBytes(to_string(sender.nonce++))
		));
		message.destination = convertAddressToEVMC(createAddress);
		code = evmc::bytes(message.input_data, message.input_data + message.input_size);
	}
	else if (message.kind == EVMC_CREATE2)
	{
		h32B createAddress(keccak256(
			bytes(1, 0xff) +
			bytes(begin(message.sender.bytes), end(message.sender.bytes)) +
			bytes(begin(message.create2_salt.bytes), end(message.create2_salt.bytes)) +
			keccak256(bytes(message.input_data, message.input_data + message.input_size)).asBytes()
		));
		message.destination = convertAddressToEVMC(createAddress);
		if (accounts.count(message.destination) && (
			accounts[message.destination].nonce > 0 ||
			!accounts[message.destination].code.empty()
		))
		{
			evmc::result result({});
			result.status_code = EVMC_OUT_OF_GAS;
			accounts = stateBackup;
			return result;
		}

		code = evmc::bytes(message.input_data, message.input_data + message.input_size);
	}
	else if (message.kind == EVMC_DELEGATECALL)
	{
		code = accounts[message.destination].code;
		message.destination = m_currentAddress;
	}
	else if (message.kind == EVMC_CALLCODE)
	{
		code = accounts[message.destination].code;
		message.destination = m_currentAddress;
	}
	else
		code = accounts[message.destination].code;

	auto& destination = accounts[message.destination];

	if (value != 0 && message.kind != EVMC_DELEGATECALL && message.kind != EVMC_CALLCODE)
	{
		sender.balance = convertToEVMC(u256(convertFromEVMC(sender.balance)) - value);
		destination.balance = convertToEVMC(u256(convertFromEVMC(destination.balance)) + value);
	}

	evmc::address currentAddress = m_currentAddress;
	m_currentAddress = message.destination;
	evmc::result result = m_vm.execute(*this, m_evmRevision, message, code.data(), code.size());
	m_currentAddress = currentAddress;

	if (message.kind == EVMC_CREATE || message.kind == EVMC_CREATE2)
	{
		result.gas_left -= static_cast<int64_t>(evmasm::GasCosts::createDataGas * result.output_size);
		if (result.gas_left < 0)
		{
			result.gas_left = 0;
			result.status_code = EVMC_OUT_OF_GAS;
			// TODO clear some fields?
		}
		else
		{
			result.create_address = message.destination;
			destination.code = evmc::bytes(result.output_data, result.output_data + result.output_size);
			destination.codehash = convertToEVMC(keccak256({result.output_data, result.output_size}));
		}
	}

	if (result.status_code != EVMC_SUCCESS)
		accounts = stateBackup;

	return result;
}

evmc::bytes32 EVMHost::get_block_hash(int64_t _number) const noexcept
{
	return convertToEVMC(u256("0x3737373737373737373737373737373737373737373737373737373737373737") + _number);
}

h32B EVMHost::convertAddressFromEVMC(evmc::address const& _addr)
{
	return h32B(bytes(begin(_addr.bytes), end(_addr.bytes)));
}

evmc::address EVMHost::convertAddressToEVMC(h32B const& _addr)
{
	evmc::address a;
	for (unsigned i = 0; i < 32; ++i)
		a.bytes[i] = _addr[i];
	return a;
}

h256 EVMHost::convertFromEVMC(evmc::bytes32 const& _data)
{
	return h256(bytes(begin(_data.bytes), end(_data.bytes)));
}

evmc::bytes32 EVMHost::convertToEVMC(h256 const& _data)
{
	evmc::bytes32 d;
	for (unsigned i = 0; i < 32; ++i)
		d.bytes[i] = _data[i];
	return d;
}

evmc::result EVMHost::precompileSha256(evmc_message const& _message) noexcept
{
	// static data so that we do not need a release routine...
	bytes static hash;
	hash = picosha2::hash256(bytes(
		_message.input_data,
		_message.input_data + _message.input_size
	));

	evmc::result result({});
	result.gas_left = _message.gas;
	result.output_data = hash.data();
	result.output_size = hash.size();
	return result;
}

evmc::result EVMHost::precompileRipeMD160(evmc_message const& _message) noexcept
{
	// NOTE this is a partial implementation for some inputs.
	static map<bytes, bytes> const inputOutput{
		{
			bytes{},
			fromHex("0000000000000000000000009c1185a5c5e9fc54612808977ee8f548b2258d31")
		},
		{
			fromHex("0000000000000000000000000000000000000000000000000000000000000004"),
			fromHex("0000000000000000000000001b0f3c404d12075c68c938f9f60ebea4f74941a0")
		},
		{
			fromHex("0000000000000000000000000000000000000000000000000000000000000005"),
			fromHex("000000000000000000000000ee54aa84fc32d8fed5a5fe160442ae84626829d9")
		},
		{
			fromHex("ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff"),
			fromHex("0000000000000000000000001cf4e77f5966e13e109703cd8a0df7ceda7f3dc3")
		},
		{
			fromHex("0000000000000000000000000000000000000000000000000000000000000000"),
			fromHex("000000000000000000000000f93175303eba2a7b372174fc9330237f5ad202fc")
		},
		{
			fromHex(
				"0800000000000000000000000000000000000000000000000000000000000000"
				"0401000000000000000000000000000000000000000000000000000000000000"
				"0000000400000000000000000000000000000000000000000000000000000000"
				"00000100"
			),
			fromHex("000000000000000000000000f93175303eba2a7b372174fc9330237f5ad202fc")
		},
		{
			fromHex(
				"0800000000000000000000000000000000000000000000000000000000000000"
				"0501000000000000000000000000000000000000000000000000000000000000"
				"0000000500000000000000000000000000000000000000000000000000000000"
				"00000100"
			),
			fromHex("0000000000000000000000004f4fc112e2bfbe0d38f896a46629e08e2fcfad5")
		},
		{
			fromHex(
				"08ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff"
				"ff010000ffffffffffffffffffffffffffffffffffffffffffffffffffffffff"
				"ffffffff00000000000000000000000000000000000000000000000000000000"
				"00000100"
			),
			fromHex("000000000000000000000000c0a2e4b1f3ff766a9a0089e7a410391730872495")
		},
		{
			fromHex(
				"6162636465666768696a6b6c6d6e6f707172737475767778797a414243444546"
				"4748494a4b4c4d4e4f505152535455565758595a303132333435363738393f21"
			),
			fromHex("00000000000000000000000036c6b90a49e17d4c1e1b0e634ec74124d9b207da")
		},
		{
			fromHex("6162636465666768696a6b6c6d6e6f707172737475767778797a414243444546"),
			fromHex("000000000000000000000000ac5ab22e07b0fb80c69b6207902f725e2507e546")
		}
	};
	return precompileGeneric(_message, inputOutput);
}

evmc::result EVMHost::precompileIdentity(evmc_message const& _message) noexcept
{
	// static data so that we do not need a release routine...
	bytes static data;
	data = bytes(_message.input_data, _message.input_data + _message.input_size);
	evmc::result result({});
	result.gas_left = _message.gas;
	result.output_data = data.data();
	result.output_size = data.size();
	return result;
}

evmc::result EVMHost::precompileModExp(evmc_message const&) noexcept
{
	// TODO implement
	evmc::result result({});
	result.status_code = EVMC_FAILURE;
	return result;
}

evmc::result EVMHost::precompileGeneric(
	evmc_message const& _message,
	map<bytes, bytes> const& _inOut) noexcept
{
	bytes input(_message.input_data, _message.input_data + _message.input_size);
	if (_inOut.count(input))
		return resultWithGas(_message, _inOut.at(input));
	else
	{
		evmc::result result({});
		result.status_code = EVMC_FAILURE;
		return result;
	}
}

evmc::result EVMHost::resultWithGas(
	evmc_message const& _message,
	bytes const& _data
) noexcept
{
	evmc::result result({});
	result.status_code = EVMC_SUCCESS;
	result.gas_left = _message.gas;
	result.output_data = _data.data();
	result.output_size = _data.size();
	return result;
}
