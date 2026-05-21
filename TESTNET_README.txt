HashmonkeyCoin (HMNY) — Public testnet
======================================

NETWORK (use Testnet in wallet/GUI)
-----------------------------------
P2P seed:  155.4.209.124:48080
           seednode.hashmonkey.cloud:48080  (when DNS is configured)
RPC node:  155.4.209.124:48081
Explorer:  https://explorer.hashmonkeys.cloud

Bootstrap address: leave EMPTY
Restore height: 0 for new wallets

SEED NODE
---------
Mining: 4 CPU threads on the official seed (monkeynas).
Testnet seed address (reference):
9u5JNEvePkpMn8cL3KnQ5qDS2NBnbigsQUvn1QcmaZPLKWUNJWftgSmWhKNnuQisXDj7nzodaAuYkCuXjiFtNTXrPxbZT4Z

WINDOWS
-------
1. Extract hmny-testnet-windows-x64.zip
2. Run start-hmny-testnet.ps1 or hashmonkey-wallet-gui.exe
3. Create a TESTNET wallet

LINUX
-----
Run hashmonkeyd --testnet or use hashmonkey-wallet-cli --testnet

MAINNET
-------
NOT launched. Mining blocked unless daemon uses --allow-mainnet-mining.
See docs/MAINNET-SECURITY.md in the source repository.

Verify downloads with SHA256SUMS.txt in this archive.
