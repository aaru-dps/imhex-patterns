// /***************************************************************************
// Aaru Data Preservation Suite
// ----------------------------------------------------------------------------
//
// Filename       : CopyQM.hexpat
// Author(s)      : Natalia Portillo <claunia@claunia.com>
//
// Component      : ImHex pattern for parsing CopyQM disk images.
// Version        : 1.00
//
// --[ Description ] ----------------------------------------------------------
//
//     Parses CopyQM disk images.
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
#pragma description CopyQM disk images parser (*.CQM)
#pragma endian little
#pragma magic [ 43 51 14 ] @ 0x00

import type.base;
import type.magic;
import type.time;

enum blind_mode_t : u8
{
    DOS = 0,
    Blind = 1,
    HFS = 2
};

enum density_t : u8
{
    Double = 0,
    High = 1,
    Quad = 2
};

struct cqm_header_t
{
    // magic, "CQ"
    type::Magic<"CQ\x14"> magic;
    // Bytes per sector (part of FAT's BPB)
    u16 sector_size;
    // Sectors per cluster (part of FAT's BPB)
    u8 sectors_per_cluster;
    // Reserved sectors (part of FAT's BPB)
    u16 reserved_sectors;
    // Number of FAT copies (part of FAT's BPB)
    u8 fat_copies;
    // Maximum number of entries in root directory (part of FAT's BPB)
    u16 root_entries;
    // Sectors on disk (part of FAT's BPB)
    u16 sectors;
    // Media descriptor (part of FAT's BPB)
    u8 media_type;
    // Sectors per FAT (part of FAT's BPB)
    u16 sectors_per_fat;
    // Sectors per track (part of FAT's BPB)
    u16 sectors_per_track;
    // Heads (part of FAT's BPB)
    u16 heads;
    // Hidden sectors (part of FAT's BPB)
    u32 hidden;
    // Sectors on disk (part of FAT's BPB)
    u32 sectors_big;
    // Description
    char description[60];
    // Blind mode. 0 = DOS, 1 = blind, 2 = HFS
    blind_mode_t blind;
    // Density. 0 = Double, 1 = High, 2 = Quad/Extra
    density_t density;
    // Cylinders in image
    u8 image_cylinders;
    // Cylinders on disk
    u8 total_cylinders;
    // CRC32 of data
    type::Hex<u32> crc;
    // DOS volume label
    char volume_label[11];
    // Modification time
    type::DOSTime time;
    // Modification date
    type::DOSDate date;
    // Comment length
    u16 comment_len;
    // Sector base (first sector - 1)
    u8 sector_base;
    // Unknown
    u16 unknown;
    // Interleave
    u8 interleave;
    // Skew
    u8 skew;
    // Source drive type. 1 = 5.25" DD, 2 = 5.25" HD, 3 = 3.5" DD, 4 = 3.5" HD, 6 = 3.5" ED
    u8 drive;
    // Filling bytes
    padding[13];
    // Checksum
    u8 checksum;
};

cqm_header_t header @ 0x00;
char comments[header.comment_len];