.. index:: ! installing

.. _installing-solidity:

################################
Installing the Solidity Compiler
################################

Installing & Compiling
----------------------

**Method 1: Using solc Command Line**

1) Windows: Download solc.exe from https://github.com/quantumcoinproject/Solidity/releases/download/v32b.8.7/solc.exe

   Linux: Download solc from https://github.com/quantumcoinproject/Solidity/releases/download/v32b.8.7/solc.exe

2) To build a contract named MyContract.sol in Windows:

   ``solc.exe --bin --bin-runtime --abi MyContract.sol -o c:\output``

   To build a contract named MyContract.sol in Linux:

   ``./solc --bin --bin-runtime --abi MyContract.sol -o /home/myusername/output``

**Method 2: Using Visual Studio Code**

1) Download and install Visual Studio code from https://code.visualstudio.com/download

2) Download the Solidity JS Compiler https://github.com/quantumcoinproject/Solidity/releases/download/v32b.8.7/soljson.js

3) In Visual Studio code, search for Solidity extension (File->Extensions) and install it. The specific extension to install is https://marketplace.visualstudio.com/items?itemName=JuanBlanco.solidity

4) In Visual Studio code, click File->Settings->Extensions->Solidity Configuration

5) In the "Compile Using Local Version" box, enter the path where the soljson.js file is downloaded in Step 2. In Windows, you may need to use double forward slashes for the path.

6) In the "Default Compiler" dropdown, select "localFile".

7) Create a sol file or open an existing file.

8) Right click on the file and select "Solidity: Compile with configured Local solc file"

9) In the Explorer pane of Visual Studio Code, you will notice a folder named bin created. In this folder, you will notice the compiled .abi and .bin files corresponding to your smart contract.
