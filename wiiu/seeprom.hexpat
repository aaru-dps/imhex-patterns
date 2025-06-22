// /***************************************************************************
// Aaru Data Preservation Suite
// ----------------------------------------------------------------------------
//
// Filename       : seeprom.hexpat
// Author(s)      : Natalia Portillo <claunia@claunia.com>
//
// Component      : ImHex pattern for parsing Wii U's SPI EEPROM.
// Version        : 1.00
//
// --[ Description ] ----------------------------------------------------------
//
//     Parses Wii U's SPI EEPROM dumps.
//
// --[ History ] --------------------------------------------------------------
//     
//     1.00: Initial release.
//
// --[ License ] --------------------------------------------------------------
//
//     This program is free software: you can redistribute it and/or modify
//     it under the terms of the GNU General Public License as
//     published by the Free Software Foundation, either version 3 of the
//     License, or (at your option) any later version.
//
//     This program is distributed in the hope that it will be useful,
//     but WITHOUT ANY WARRANTY; without even the implied warranty of
//     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//     GNU General Public License for more details.
//
//     You should have received a copy of the GNU General Public License
//     along with this program.  If not, see <http://www.gnu.org/licenses/>.
//
// ----------------------------------------------------------------------------
// Copyright © 2011-2025 Natalia Portillo
// ****************************************************************************/

#pragma author Nat Portillo <claunia@claunia.com>
#pragma description WII U SPI EEPROM parser (seeprom.bin)
#pragma endian big
#pragma magic [ AA 55 ] @ 0x192

#include <aaru/lib/functions.incpat>

import std.core;
import std.mem;
import std.sys;
import type.base;
import type.bcd;
import type.magic;

struct espresso_package_info_t
{
    type::Hex<u32> ppc_pvr [[name("PPC PVR")]];
    char package_id[6] [[name("Package ID")]];
    u16 unknown [[highlight_hidden]];
};

struct latte_package_info_t
{
    u16 latte_pkg_wafer_x [[name("Package Wafer X Coordinate")]];
    u16 latte_pkg_wafer_y [[name("Package Wafer Y Coordinate")]];
    char latte_pkg_id[8] [[name("Package ID")]];
};

enum sata_device_t : u16
{
    Default = 1,
    None = 2,
    ROM = 3,
    R = 4,
    MION = 5,
    SES = 6,
    GEN2_HDD = 7,
    GEN1_HDD = 8
};

enum console_type_t : u16
{
    WUP = 1,
    CAT_R = 2,
    CAT_DEV = 3,
    EV = 4,
    Promotion = 5,
    OrchestraX = 6,
    WUIH = 7,
    WUIH_DEV = 8,
    CAT_DEV_WUIH = 9
};

struct board_config_t
{
    type::Hex<u32> crc;
    u16 size;
    u16 version;
    char author[2];
    char board_type[2];
    u16 board_revision;
    char boot_source[2];
    u16 ddr3_size;
    u16 ddr3_speed;
    u16 ppc_clock_multiplier;
    u16 iop_clock_multiplier;
    u16 video_1080;
    char ddr3_vendor[2];
    u16 mov_passive_reset;
    u16 sys_pii_speed;
    sata_device_t sata_device;
    console_type_t console_type;
    u32 device_presence;
    u8 reserved[0x20];
};

struct sys_prod_info_t
{
    u32 product_area;
    u16 eeprom_version;
    padding[2];
    u32 game_region;
    padding[4];
    char ntsc_pal[4];
    char _5ghz_country_code[3];
    u8 _5ghz_country_code_revision;
    char code_id[8];
    char serial_id[12];
    padding[4];
    char model_number[16];
};

struct cpu_board_log_t
{
    u16 version;
    u16 id;
    u8 ng_code[4] [[format_read("format_array_as_hex")]];
    u32 date;
    u16 time;
    type::Hex<u32> crc;
};

struct dcr_mcr_t
{
    type::Magic<"\xAA\x55"> magic1;
    u16 mcr_group;
    u16 mcr_diag;
    u16 mcr_flags;
    u32 dcr_status;
    u32 dcr_disk_id;
    type::Magic<"\xBB\x66"> magic2;
    u16 dcr_file_idx;
    u16 dcr_state;
    char dcr_name[8];
    type::Hex<u16> crc;
};

struct diag_result_log_t
{
    u16 result0;
    u16 result1;
    u16 result2;
    u16 result3;
};

struct other_info_t
{
    u8 mlc_size;
    u8 crush_log;
};

struct wii_u_spi_eeprom_t
{
    padding[18];
    u8 rng_seed[8] [[format_read("format_array_as_hex")]];
    padding[6];
    espresso_package_info_t espresso_package_info;
    latte_package_info_t latte_package_info;
    board_config_t board_config;
    u8 drive_key[16] [[format_read("format_array_as_hex")]];
    u8 factory_key[16] [[format_read("format_array_as_hex")]];
    u8 shdd_seed[16] [[format_read("format_array_as_hex")]];
    u8 ivs_seed[16] [[format_read("format_array_as_hex")]];
    u16 drive_config;
    u16 ivs_config;
    u16 shdd_config;
    padding[106];
    type::Hex<u32> unknown1 [[highlight_hidden]];
    type::Hex<u16> unknown2 [[highlight_hidden]];
    type::Hex<u16> unknown3 [[highlight_hidden]];
    padding[8];
    sys_prod_info_t sys_prod_info;
    cpu_board_log_t cpu_board_log;
    dcr_mcr_t dcr_mcr;
    diag_result_log_t diag_result_log;
    type::Hex<u16> unknown4 [[highlight_hidden]];
    type::Hex<u16> unknown5 [[highlight_hidden]];
    other_info_t other_info;
    u8 boot_params[48]; // Encrypted
    padding[16];
};

if(std::mem::size() != 512)
    std::error("Invalid size.");

wii_u_spi_eeprom_t eeprom @ 0x00;

std::print("Espresso Package ID: {}", eeprom.espresso_package_info.package_id);
std::print("   Latte Package ID: {}", eeprom.latte_package_info.latte_pkg_id);
std::print("");
std::print("==== Board configuration =======================================================================");
if(eeprom.board_config.author == "@M")
    std::print(" Board manufacturer: Nintendo");
else
    std::print(" Board manufacturer: {}", eeprom.board_config.author);

match(eeprom.board_config.board_type)
{
    ("CF"): std::print("         Board type: Production");
    ("CT"): std::print("         Board type: Development");
    ("EV" | "EY"): std::print("         Board type: Evaluation");
    (_): std::print("         Board type: {}", eeprom.board_config.board_type);
}
   
match(eeprom.board_config.boot_source)
{   
    ("N1"): std::print("        Boot source: NAND");
    ("S0"): std::print("        Boot source: SDIO0");
    ("S3"): std::print("        Boot source: SDIO3");
    (_): std::print("        Boot source: {}", eeprom.board_config.boot_source);
}

std::print("          DDR3 size: {} MiB", eeprom.board_config.ddr3_size);

match(eeprom.board_config.sata_device)
{
    (1): std::print("        SATA device: default");
    (2): std::print("        SATA device: none");
    (3): std::print("        SATA device: -ROM");
    (4): std::print("        SATA device: -R");
    (5): std::print("        SATA device: MION");
    (6): std::print("        SATA device: SES");
    (7): std::print("        SATA device: Gen. 2 HDD");
    (8): std::print("        SATA device: Gen. 1 HDD");
    (_): std::print("        SATA device: {}", eeprom.board_config.sata_device);
}

match(eeprom.board_config.console_type)
{
    (1): std::print("       Console type: Production");
    (2): std::print("       Console type: Test");
    (3): std::print("       Console type: Development");
    (4): std::print("       Console type: Evaluation");
    (5): std::print("       Console type: Promotion");
    (6): std::print("       Console type: OrchestraX");
    (7): std::print("       Console type: WUIH");
    (8): std::print("       Console type: WUIH_DEV");
    (9): std::print("       Console type: CAT_DEV_WUIH");
    (_): std::print("       Console type: {}", eeprom.board_config.console_type);
}

std::print("==== Keys ======================================================================================");
match(eeprom.drive_config)
{
    (0x0000): std::print("    The drive key is unencrypted");
    (0xFFFE): std::print("    The drive key is empty");
    (0xFFFF): std::print("    The drive key is encrypted with the EEPROM key");
}
std::print("          Drive key: {}", eeprom.drive_key);
std::print("        Factory key: {}", eeprom.factory_key);
match(eeprom.shdd_config)
{
    (0x0000): std::print("    The SHDD seed is empty");
    (0xFFFF): std::print("    The SHDD seed is encrypted with the SHDD key from the OTP");
}
std::print("          SHDD seed: {}", eeprom.shdd_seed);
match(eeprom.ivs_config)
{
    (0x0010): std::print("    Real IVS should be used");
}
std::print("           IVS seed: {}", eeprom.ivs_seed);

std::print("==== System product information ================================================================");
std::print("       Product area: {}", eeprom.sys_prod_info.product_area);
std::print("     EEPROM version: {}", eeprom.sys_prod_info.eeprom_version);
std::print("        Game region: {}", eeprom.sys_prod_info.game_region);
std::print("           NTSC/PAL: {}", eeprom.sys_prod_info.ntsc_pal);
std::print("  5GHz Country Code: {}", eeprom.sys_prod_info._5ghz_country_code);
std::print(" 5Ghz C.C. Revision: {}", eeprom.sys_prod_info._5ghz_country_code_revision);
std::print("            Code ID: {}", eeprom.sys_prod_info.code_id);
std::print("          Serial ID: {}", eeprom.sys_prod_info.serial_id);
std::print("       Model number: {}", eeprom.sys_prod_info.model_number);
