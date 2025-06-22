// /***************************************************************************
// Aaru Data Preservation Suite
// ----------------------------------------------------------------------------
//
// Filename       : BlindWrite4.hexpat
// Author(s)      : Natalia Portillo <claunia@claunia.com>
//
// Component      : ImHex pattern for parsing BlindWrite 4 disc images.
// Version        : 1.00
//
// --[ Description ] ----------------------------------------------------------
//
//     Parses BlindWrite 4 disc images.
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
#pragma description BlindWrite 4 disc images parser (*.BWT)
#pragma endian little
#pragma magic [ "BLINDWRITE TOC FILE" ] @ 0x00

import type.magic;

enum bw4_track_mode_t : u8
{
    Audio = 0,
    Mode1 = 1,
    Mode2 = 2
};

bitfield CtrlAdr
{
    CONTROL : 4;
    ADR : 4;
};

struct bw4_track_t
{
    u32 filename_len;
    char filename[filename_len] [[name("Filename")]];
    u32 offset [[name("Track offset in file")]];
    u8 subchannel [[name("Subchannel reading mode")]];
    u8 unknown1[3];
    u32 unknown2;
    u8 unknown3;
    u8 session;
    u8 unknown4;
    CtrlAdr;
    u8 unknown5;
    bw4_track_mode_t track_mode [[name("Track mode")]];
    u8 unknown6;
    u8 point [[name("Track point")]];
    u32 unknown7;
    u32 unknown8;
    u32 unknown9;
    u32 unknown10;
    u16 unknown11;
    s32 lastSector [[name("Last sector")]];
    s8 unknown12;
    s32 pregap [[name("Track pregap")]];
    s32 startSector [[name("Track starting sector (index 1)")]];
    u32 unknown13[2];
    u32 title_len;
    char title[title_len] [[name("Album title")]];
    u32 performer_len;
    char performer[performer_len] [[name("Album performer")]];
    u32 unknown14_len;
    char unknown14[unknown14_len];
    u32 unknown15_len;
    char unknown15[unknown15_len];
    u32 unknown16_len;
    char unknown16[unknown16_len];
    u32 unknown17_len;
    char unknown17[unknown17_len];
    u32 disc_id_len;
    char disc_id[disc_id_len] [[name("Disc ID from CD-Text")]];
    u32 unknown18_len;
    char unknown18[unknown18_len];
    u32 unknown19_len;
    char unknown19[unknown19_len];
    u32 unknown20_len;
    char unknown20[unknown20_len];
    u32 unknown21_len;
    char unknown21[unknown21_len];
    u32 unknown22_len;
    char unknown22[unknown22_len];
    u32 unknown23_len;
    char unknown23[unknown23_len];
    u32 unknown24_len;
    char unknown24[unknown24_len];
    u32 isrc_len;
    char isrc[isrc_len] [[name("ISRC")]];
};

struct bw4_header_t
{
    type::Magic<"BLINDWRITE TOC FILE"> magic;
    u32 unknown1 [[highlight_hidden]];
    u64 timestamp;
    u32 volid_len;
    char volume_id[volid_len] [[name("Volume identifier")]];
    u32 sysid_len;
    char system_id[sysid_len] [[name("System identifier")]];
    u32 comments_len;
    char comments[comments_len] [[name("Image comments")]];
    u32 track_descriptors;
    u32 data_file_len;
    char data_file[data_file_len] [[name("Data file")]];
    u32 subchannel_file_len;
    char subchannel_file[subchannel_file_len] [[name("Subchannel file")]];
    u32 unknown2 [[highlight_hidden]];
    u8 unknown3_len [[highlight_hidden]];
    char unknown3[unknown3_len] [[highlight_hidden]];
    bw4_track_t tracks[track_descriptors];
};

bw4_header_t header @ 0x00;