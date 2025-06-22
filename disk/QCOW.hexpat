// /***************************************************************************
// Aaru Data Preservation Suite
// ----------------------------------------------------------------------------
//
// Filename       : QCOW.hexpat
// Author(s)      : Natalia Portillo <claunia@claunia.com>
//
// Component      : ImHex pattern for parsing QEMU Copy On Write disk images.
// Version        : 1.00
//
// --[ Description ] ----------------------------------------------------------
//
//     Parses QEMU Copy On Write disk images.
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
#pragma description QEMU Copy On Write parser
#pragma endian big
#pragma magic [ 51 46 49 FB ] @ 0x00

import type.magic;
import type.time;

struct qfi_header_t
{
    type::Magic<"QFI\xFB"> magic1;
    // Must be 1
    u32 version;
    // Offset inside file to string containing backing file
    u64 backing_file_offset;
    // Size of backing_file_offset
    u32 backing_file_size;
    // Modification time
    type::time32_t mtime;
    // Size in bytes
    u64 size;
    // Cluster bits
    u8 cluster_bits;
    // L2 table bits
    u8 l2_bits;
    // Padding</summary>
    padding[2];
    // Encryption method
    u32 crypt_method;
    // Offset to L1 table
    u64 l1_table_offset;
};

qfi_header_t header @ 0x00;

s32 shift = header.cluster_bits + header.l2_bits;
s32 l1_size = ((header.size + (1 << shift)) - 1) >> shift;

u64 l1[l1_size] @ header.l1_table_offset;