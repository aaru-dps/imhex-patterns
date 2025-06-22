// /***************************************************************************
// Aaru Data Preservation Suite
// ----------------------------------------------------------------------------
//
// Filename       : 2mg.hexpat
// Author(s)      : Natalia Portillo <claunia@claunia.com>
//
// Component      : ImHex pattern for parsing Apple 2MG disk images.
// Version        : 1.00
//
// --[ Description ] ----------------------------------------------------------
//
//     Parses Apple 2MG disk images.
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
#pragma description Apple 2MG disk images parser (*.2mg)
#pragma endian little
#pragma magic [ "2IMG" ] @ 0x00

import type.magic;

enum sector_order_t : u32
{
    DOS     = 0,
    PRODOS  = 1,
    NIBBLES = 2
};

struct header_t
{
    // Magic
    type::Magic<"2IMG"> magic;
    // Disk image creator ID
    char creator[4];
    // Header size, constant 0x0040
    u16 header_size;
    // Disk image version
    u16 version;
    // Disk image format
    sector_order_t image_format;
    // Flags and volume number
    u32 flags;
    // Blocks for ProDOS, 0 otherwise
    u32 blocks;
    // Offset to data
    u32 data_off;
    // Data size in bytes
    u32 data_len;
    // Offset to optional comment
    u32 comment_off;
    // Length of optional comment
    u32 comment_len;
    // Offset to creator specific chunk
    u32 creator_specific_off;
    // Creator specific chunk size
    u32 creator_specific_len;
    // Reserved, should be zero
    u32 reserved1;
    // Reserved, should be zero
    u32 reserved2;
    // Reserved, should be zero
    u32 reserved3;
    // Reserved, should be zero
    u32 reserved4;
};

header_t header @ 0x00;
u8 data[header.data_len] @ header.data_off;
char comments[header.comment_len] @ header.comment_off;
u8 creator_specific[header.creator_specific_len] @ header.creator_specific_off;