from pathlib import Path
import sys

ROOT = Path(sys.argv[1])
p = ROOT / "src/cryptonote_config.h"
t = p.read_text()
old = """    uint16_t const P2P_DEFAULT_PORT = 28080;
    uint16_t const RPC_DEFAULT_PORT = 28081;
    uint16_t const ZMQ_RPC_DEFAULT_PORT = 28082;
    boost::uuids::uuid const NETWORK_ID = { {
        0x12 ,0x30, 0xF1, 0x71 , 0x61, 0x04 , 0x41, 0x61, 0x17, 0x31, 0x00, 0x82, 0x16, 0xA1, 0xA1, 0x11
      } }; // Bender's daydream"""
new = """    uint16_t const P2P_DEFAULT_PORT = 48080;
    uint16_t const RPC_DEFAULT_PORT = 48081;
    uint16_t const ZMQ_RPC_DEFAULT_PORT = 48082;
    boost::uuids::uuid const NETWORK_ID = { {
        0x48, 0x4d, 0x4e, 0x59, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x02
      } };"""
if old not in t:
    raise SystemExit("testnet block not found")
p.write_text(t.replace(old, new))
print("testnet ports ok")
