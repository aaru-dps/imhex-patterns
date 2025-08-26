// /***************************************************************************
// Aaru Data Preservation Suite
// ----------------------------------------------------------------------------
//
// Filename       : ZOO.hexpat
// Author(s)      : Natalia Portillo <claunia@claunia.com>
//
// Component      : ImHex pattern for parsing ZOO archives.
// Version        : 1.00
//
// --[ Description ] ----------------------------------------------------------
//
//     Parses ZOO archives.
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
#pragma description ZOO archive parser
#pragma endian little
#pragma magic [ FD C4 A7 DC ] @ 0x14

import type.base;
import type.magic;
import type.size;
import type.time;

enum system_t : u8
{
    Unix = 0,
    DOS = 1,
    Portable = 2
};

enum packing_t : u8
{
    Store = 0,
    LZW = 1,
    LZH = 2
};

using dirent;

struct zoohdr
{
    // archive header text
    char text[20];
    // identifies archives
    type::Magic<"\xDC\xA7\xC4\xFD"> zoo_tag;
    // where the archive's data starts
    dirent *zoo_start : s32;
    // for consistency checking of zoo_start
    s32 zoo_minus;
    u8 major_ver;
    // minimum version to extract all files
    u8 minor_ver;
    // type of archive header
    u8 type;
    // position of archive comment
    s32 acmt_pos;
    // length of archive comment
    u16 acmt_len;
    // byte in archive;   data about versions
    u16 vdata;
    
    if(acmt_len > 0)
        char comment[acmt_len] @ acmt_pos;
};

struct dirent
{
    // tag -- redundancy check
    type::Magic<"\xDC\xA7\xC4\xFD"> zoo_tag;
    // type of directory entry.   always 1 for now
    u8 type;
    // 0 = no packing, 1 = normal LZW
    packing_t packing_method;
    // pos'n of next directory entry
    s32 next;
    
    if(next == 0)
        break;
        
    // position of this file
    s32 offset;
    // DOS format date
    type::DOSDate date;
    // DOS format time
    type::DOSTime time;
    // CRC of this file
    type::Hex<u16> file_crc;
    type::Size<s32> org_size;
    type::Size<s32> size_now;
    u8 major_ver;
    // minimum version needed to extract
    u8 minor_ver;
    // will be 1 if deleted, 0 if not
    u8 deleted;
    // file structure if any
    u8 struc;
    // points to comment;  zero if none
    s32 cmt_pos;
    // length of comment, 0 if none
    u16 cmt_size;
    // filename
    char fname[13];

    // length of variable part of dir entry
    s16 var_dir_len;
    // timezone where file was archived
    u8 tz;
    // CRC of directory entry
    type::Hex<u16> dir_crc;

    /* fields for variable part of directory entry follow */

    // length of long filename
    u8 namlen;
    // length of directory name
    u8 dirlen;
    // long filename
    char lfname[namlen];
    // directory name
    char dirname[dirlen];
    // Filesystem ID
    system_t system_id;
    // File attributes -- 24 bits
    u32 fattr;
    // version flag bits -- one byte in archive
    u16 vflag;
    // file version number if any
    u16 version_no;
    
    if(cmt_size > 0)
        char comment[cmt_size] @ cmt_pos;

    u8 data[size_now] @ offset;
    
    dirent next_entry @ next;
};

zoohdr zoo @ 0x00;
