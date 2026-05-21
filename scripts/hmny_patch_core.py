#!/usr/bin/env python3
from pathlib import Path
ROOT = Path(__file__).resolve().parents[1] / "monero"
def patch_config():
    p = ROOT / "src/cryptonote_config.h"
    t = p.read_text()
    t = t.replace("#define CRYPTONOTE_NAME                         \"bitmonero\"", "#define CRYPTONOTE_NAME                         \"hashmonkeycoin\"")
    old = "  uint64_t const CRYPTONOTE_PUBLIC_ADDRESS_BASE58_PREFIX = 18;\n  uint64_t const CRYPTONOTE_PUBLIC_INTEGRATED_ADDRESS_BASE58_PREFIX = 19;\n  uint64_t const CRYPTONOTE_PUBLIC_SUBADDRESS_BASE58_PREFIX = 42;\n  uint16_t const P2P_DEFAULT_PORT = 18080;\n  uint16_t const RPC_DEFAULT_PORT = 18081;\n  uint16_t const ZMQ_RPC_DEFAULT_PORT = 18082;\n  boost::uuids::uuid const NETWORK_ID = { {\n      0x12 ,0x30, 0xF1, 0x71 , 0x61, 0x04 , 0x41, 0x61, 0x17, 0x31, 0x00, 0x82, 0x16, 0xA1, 0xA1, 0x10\n    } }; // Bender's nightmare\n  std::string const GENESIS_TX = \"013c01ff0001ffffffffffff03029b2e4c0281c0b02e7c53291a94d1d0cbff8883f8024f5142ee494ffbbd08807121017767aafcde9be00dcfd098715ebcf7f410daebc582fda69d24a28e9d0bc890d1\";\n  uint32_t const GENESIS_NONCE = 10000;"
    new = "  uint64_t const CRYPTONOTE_PUBLIC_ADDRESS_BASE58_PREFIX = 48;\n  uint64_t const CRYPTONOTE_PUBLIC_INTEGRATED_ADDRESS_BASE58_PREFIX = 49;\n  uint64_t const CRYPTONOTE_PUBLIC_SUBADDRESS_BASE58_PREFIX = 50;\n  uint16_t const P2P_DEFAULT_PORT = 28080;\n  uint16_t const RPC_DEFAULT_PORT = 28081;\n  uint16_t const ZMQ_RPC_DEFAULT_PORT = 28082;\n  boost::uuids::uuid const NETWORK_ID = { {\n      0x48, 0x4d, 0x4e, 0x59, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01\n    } }; // HMNY mainnet\n  std::string const GENESIS_TX = \"013c01ff0001ffffffffffff0302df5d56da0c7d643ddd1ce61901c7bdc5fb1738bfe39fbe69c28a3a7032729c0f2101168d0c4ca86fb55a4cf6a36d31431be1c53a3bd7411bb24e8832410289fa6f3b\";\n  uint32_t const GENESIS_NONCE = 424242;"
    if old not in t: raise SystemExit("mainnet config not found")
    t = t.replace(old, new).replace("MoneroMessageSignature", "HashmonkeyMessageSigning")
    p.write_text(t); print("config OK")
if __name__ == "__main__": patch_config()
