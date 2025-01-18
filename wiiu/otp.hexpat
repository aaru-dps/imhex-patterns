// /***************************************************************************
// Aaru Data Preservation Suite
// ----------------------------------------------------------------------------
//
// Filename       : aaruformat.hexpat
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
#pragma description WII OTP parser (otp.bin)
#pragma endian big

#include <aaru/lib/functions.incpat>

import std.sys;
import std.mem;
import std.time;
import type.base;

bitfield fuse_type_t
{
    bool evaluation_disabled : 1 [[name("Disables evaluation mode")]];
    bool boot0_error : 1 [[name("Causes an error in boot0")]];
    bool unknown : 1 [[name("Unknown")]];
    bool production : 1 [[name("Production")]];
    bool development : 1 [[name("Development")]];
    padding : 27;
};

bitfield debug_type_t
{
    bool unknown1 : 1 [[name("Unknown")]];
    bool unknown2 : 1 [[name("Unknown")]];
    padding : 22;
    bool jtag_disabled : 1 [[name("JTAG is disabled")]];
    bool unknown3 : 1 [[name("Unknown")]];
    bool unknown4 : 1 [[name("Unknown")]];
    bool unknown5 : 1 [[name("Unknown")]];
    padding : 3;
    bool production : 1 [[name("Production")]];
};

struct wiiu_otp_t
{
    u8 wii_boot1_sha1_hash[20] [[name("Wii's boot1 SHA1 hash"), format_read("format_array_as_hex")]];
    u8 wii_common_key[16] [[name("Wii Common Key"), format_read("format_array_as_hex")]];
    u8 wii_device_id[4] [[name("Wii Device ID"), format_read("format_array_as_hex")]];
    u8 wii_device_pk[28] [[name("Wii Device Private Key"), format_read("format_array_as_hex")]];
    $=0x44;
    u8 wii_nand_hmac[20] [[name("Wii NAND HMAC"), format_read("format_array_as_hex")]];
    u8 wii_nand_key[16] [[name("Wii NAND Key"), format_read("format_array_as_hex")]];
    u8 wii_backup_key[16] [[name("Wii Backup Key"), format_read("format_array_as_hex")]];
    type::Hex<u16> unknown [[highlight_hidden]];
    padding[6];
    fuse_type_t fuse_type [[name("eFuse flags")]];
    u32 io_strength_flags [[name("IOStrength configuration flags")]];
    u32 seeprom_pulse_length [[name("SEEPROM Pulse Length")]];
    u32 signature_type [[name("Signature type")]];
    u8 starbuck_ancast_key[16] [[name("Starbuck Ancast Key"), format_read("format_array_as_hex")]];
    u8 seeprom_key[16] [[name("SEEPROM Key"), format_read("format_array_as_hex")]];
    u8 unknown2[16] [[highlight_hidden, format_read("format_array_as_hex")]];
    u8 unknown3[16] [[highlight_hidden, format_read("format_array_as_hex")]];
    u8 vwii_common_key[16] [[name("vWii Common Key"), format_read("format_array_as_hex")]];
    u8 wiiu_common_key[16] [[name("Wii U Common Key"), format_read("format_array_as_hex")]];
    u8 unknown4[16] [[highlight_hidden, format_read("format_array_as_hex")]];
    u8 unknown5[16] [[highlight_hidden, format_read("format_array_as_hex")]];
    u8 unknown6[16] [[highlight_hidden, format_read("format_array_as_hex")]];
    u8 ssl_rsa_enc_key[16] [[name("SSL RSA Key's Encryption Key"), format_read("format_array_as_hex")]];
    u8 ivs_key[16] [[name("IVS Key"), format_read("format_array_as_hex")]];
    u8 wii_media_title_key[16] [[name("Wii Media Title Key"), format_read("format_array_as_hex")]];
    u8 xor_key[16] [[name("XOR Key"), format_read("format_array_as_hex")]];
    u8 wiiu_backup_key[16] [[name("Wii U Backup Key"), format_read("format_array_as_hex")]];
    u8 slc_nand_key[16] [[name("SLC NAND Key"), format_read("format_array_as_hex")]];
    u8 mlc_nand_key[16] [[name("MLC NAND Key"), format_read("format_array_as_hex")]];
    u8 shdd_key[16] [[name("SHDD Key"), format_read("format_array_as_hex")]];
    u8 drh_wlan_data_key[16] [[name("DRH WLAN Data Key"), format_read("format_array_as_hex")]];
    u8 unknown7[48] [[highlight_hidden, format_read("format_array_as_hex")]];
    u8 slc_nand_hmac_key[20] [[name("SLC NAND HMAC Key"), format_read("format_array_as_hex")]];
    u8 unknown8[12] [[highlight_hidden, format_read("format_array_as_hex")]];
    u8 unknown9[16] [[highlight_hidden, format_read("format_array_as_hex")]];
    u8 unknown10[12] [[highlight_hidden, format_read("format_array_as_hex")]];
    u8 wiiu_device_id[4] [[name("Wii U Device ID"), format_read("format_array_as_hex")]];
    u8 wiiu_device_pk[32] [[name("Wii U Private Key"), format_read("format_array_as_hex")]];
    u8 wiiu_device_uniq_cert_pk[32] [[name("Wii U Device Unique Certificate Private Key"), format_read("format_array_as_hex")]];
    u8 rng_seed[16] [[name("RNG Seed"), format_read("format_array_as_hex")]];
    u8 unknown11[16] [[highlight_hidden, format_read("format_array_as_hex")]];
    type::Hex<u32> wiiu_dev_uniq_cert_ms_id [[name("Wii U Device Unique Certificate Manufacturing ID (MS)")]];
    type::Hex<u32> wiiu_dev_uniq_cert_ca_id [[name("Wii U Device Unique Certificate Authority ID (CA)")]];
    u32 wiiu_dev_uniq_cert_mfg_date [[name("Wii U Device Unique Certificate Manufacturing Date"), format_read("format_wiiu_time")]];
    u8 wiiu_dev_uniq_cert_sig[60] [[name("Wii U Device Unique Certificate Signature")]];
    u8 unknown12[24] [[highlight_hidden, format_read("format_array_as_hex")]];
    padding[32];
    type::Hex<u32> wiiu_dev_auth_common_cert_ms_id [[name("Wii U Device Authentication Common Certificate Manufacturing ID (MS)")]];
    type::Hex<u32> wiiu_dev_auth_common_cert_ca_id [[name("Wii U Device Authentication Common Certificate Authority (CA)")]];
    u32 wiiu_dev_auth_common_cert_mfg_date [[name("Wii U Device Authentication Common Certificate Manufacturing Date"), format_read("format_wiiu_time")]];
    u8 wiiu_dev_auth_common_cert_sig[60] [[name("Wii U Device Authentication Common Certificate Signature"), format_read("format_array_as_hex")]];
    u8 wii_common_key_korea[16] [[name("Wii Common Key (Korea)"), format_read("format_array_as_hex")]];
    u8 unknown13[8] [[highlight_hidden, format_read("format_array_as_hex")]];
    u8 wiiu_dev_auth_common_cert_pk[32] [[name("Wii U Device Authentication Common Certificate Private Key"), format_read("format_array_as_hex")]];
    padding[32];
    u8 boot1_key[16] [[name("boot1's Key (shall be empty)"), format_read("format_array_as_hex")]];
    padding[16];
    padding[32];
    u32 reserved5;
    u32 latte_pkg_wafer_x [[name("Latte Package Wafer X Coordinate")]];
    u32 latte_pkg_wafer_y [[name("Latte Package Wafer Y Coordinate")]];
    u32 latte_pkg_rev [[name("Latte Package Revision")]];
    char latte_pkg_id[8] [[name("Latte Package ID")]];
    u32 reserved6;
    debug_type_t debug_type;
};

fn format_wiiu_time(ref u32 wiiu_time)
{
    return std::time::format(std::time::to_local(wiiu_time - 631152000));
};

if(std::mem::size() != 1024)
    std::error("Invalid size.");

wiiu_otp_t otp @ 0x00;

std::print(" Wii U Device ID: {}", otp.wiiu_device_id);
std::print(" Wii   Device ID: {}", otp.wii_device_id);
std::print("Latte Package ID: {}", otp.latte_pkg_id);
std::print("");
std::print("==== Wii Keys =======================================================================");
std::print("        Common Key: {}", otp.wii_common_key);
std::print("Common Key (Korea): {}", otp.wii_common_key_korea);
std::print("Device Private Key: {}", otp.wii_device_pk);
std::print("         NAND HMAC: {}", otp.wii_nand_hmac);
std::print("          NAND Key: {}", otp.wii_nand_key);
std::print("        Backup Key: {}", otp.wii_backup_key);
std::print("   Media Title Key: {}", otp.wii_media_title_key);
std::print("");
std::print("==== Wii U Keys =======================================================================");
std::print("                  Common Key: {}", otp.wiiu_common_key);
std::print("             vWii Common Key: {}", otp.vwii_common_key);
std::print("          Device Private Key: {}", otp.wiiu_device_pk);
std::print("               SLC NAND HMAC: {}", otp.slc_nand_hmac_key);
std::print("                SLC NAND Key: {}", otp.slc_nand_key);
std::print("                MLC NAND Key: {}", otp.mlc_nand_key);
std::print("                  Backup Key: {}", otp.wiiu_backup_key);
std::print("         Starbuck Ancast Key: {}", otp.starbuck_ancast_key);
std::print("                 SEEPROM Key: {}", otp.seeprom_key);
std::print("SSL RSA Key's Encryption Key: {}", otp.ssl_rsa_enc_key);
std::print("                     IVS Key: {}", otp.ivs_key);
std::print("                     XOR Key: {}", otp.xor_key);
std::print("                    SHDD Key: {}", otp.shdd_key);
std::print("           DRH WLAN Data Key: {}", otp.drh_wlan_data_key);
