// /***************************************************************************
// Aaru Data Preservation Suite
// ----------------------------------------------------------------------------
//
// Filename       : DC42.hexpat
// Author(s)      : Natalia Portillo <claunia@claunia.com>
//
// Component      : ImHex pattern for parsing DiskCopy 4.2 disk images.
// Version        : 1.00
//
// --[ Description ] ----------------------------------------------------------
//
//     Parses Disk Copy 4.2 disk images.
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
#pragma description Disk Copy 4.2 disk images parser (*.dc42)
#pragma endian big

enum format_t : u8
{
    // 3.5", single side, double density, GCR
    kSonyFormat400K = 0x00,
    // 3.5", double side, double density, GCR
    kSonyFormat800K = 0x01,
    // 3.5", double side, double density, MFM
    kSonyFormat720K = 0x02,
    // 3.5", double side, high density, MFM
    kSonyFormat1440K = 0x03,
    // 3.5", double side, high density, MFM, 21 sectors/track (aka, Microsoft DMF)
    kSonyFormat1680K = 0x04,
    // Defined by Sigma Seven's BLU
    kSigmaFormatTwiggy = 0x54,
    // Defined by LisaEm
    kNotStandardFormat = 0x5D
};

enum fmt_t : u8
{
    // Based on GCR nibble
    // Always 0x02 for MFM disks
    // Unknown for Apple HD20
    
    // Defined by Sigma Seven's BLU</summary>
    kSigmaFmtByteTwiggy = 0x01,
    // 3.5" single side double density GCR and MFM all use same code
    kSonyFmtByte400K = 0x02,
    // 3.5" double side double density GCR, 512 bytes/sector, interleave 2:1
    kSonyFmtByte800K = 0x22,
    // 3.5" double side double density GCR, 512 bytes/sector, interleave 2:1, incorrect value (but appears on official documentation)
    kSonyFmtByte800KIncorrect = 0x12,
    // 3.5" double side double density GCR, ProDOS format, interleave 4:1
    kSonyFmtByteProDos = 0x24,
    // Defined by LisaEm
    kFmtNotStandard = 0x93,
    // Unformatted sectors
    kInvalidFmtByte = 0x96,
    // Used incorrectly by Mac OS X with certaing disk images
    kMacOSXFmtByte = 0x00
};

struct dc42_header_t
{
    // Pascal string, disk name or "-not a Macintosh disk-", filled with garbage
    char DiskName[64];
    // Size of data in bytes (usually sectors*512)
    u32 DataSize;
    // Size of tags in bytes (usually sectors*12)
    u32 TagSize;
    // Checksum of data bytes
    u32 DataChecksum;
    // Checksum of tag bytes
    u32 TagChecksum;
    // Format of disk, see constants
    format_t Format;
    // Format of sectors, see constants
    fmt_t FmtByte;
    // Is disk image valid? always 0x01
    u8 Valid;
    // Reserved, always 0x00
    padding[1];
};

dc42_header_t header @ 0x00;