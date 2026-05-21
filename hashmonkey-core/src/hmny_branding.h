#pragma once

#include "cryptonote_config.h"
#include "version.h"
#include <cstring>
#include <string>

#define HMNY_PROJECT_DISPLAY_NAME "HashmonkeyCoin"
#define HMNY_PROJECT_TICKER "HMNY"
#define HMNY_RELEASES_URL "https://github.com/stabner/hashmonkeycoin/releases"

inline bool hmny_is_hashmonkeycoin()
{
  return std::strcmp(CRYPTONOTE_NAME, "hashmonkeycoin") == 0;
}

inline std::string hmny_version_string()
{
  return std::string(HMNY_PROJECT_DISPLAY_NAME) + " (v" + MONERO_VERSION_FULL + ")";
}
