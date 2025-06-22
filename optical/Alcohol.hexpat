// /***************************************************************************
// Aaru Data Preservation Suite
// ----------------------------------------------------------------------------
//
// Filename       : Alcohol.hexpat
// Author(s)      : Natalia Portillo <claunia@claunia.com>
//
// Component      : ImHex pattern for parsing Alcohol 120% disc images.
// Version        : 1.00
//
// --[ Description ] ----------------------------------------------------------
//
//     Parses Alcohol 120% disc images.
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
// Copyright © 2020 RibShark
// ****************************************************************************/

#pragma author Nat Portillo <claunia@claunia.com>
#pragma description Alcohol 120% parser (*.mds)
#pragma endian little
#pragma magic [ "MEDIA DESCRIPTOR" ] @ 0x00

import type.magic;
import std.string;

enum medium_type_t : u16
{
    CD = 0x00,
    CDR = 0x01,
    CDRW = 0x02,
    DVD = 0x10,
    DVDR = 0x12
};

enum track_mode_t : u8
{
    NoData = 0x00,
    Data = 0x02,
    Audio = 0xA9,
    Mode1 = 0xAA,
    Mode2 = 0xAB,
    Mode2F1 = 0xEC,
    Mode2F2 = 0xED,
    Mode2F1Alt = 0xAC,
    Mode2F2Alt = 0xAD,
};

enum subchannel_mode_t : u8
{
    None = 0x00,
    Interleaved = 0x08
};

struct alc_dpm_t
{
    u32 unknown;  // 0x01
    u32 unknown2; // 0x1FC
    u32 unknown3; // 0x01
    u32 start_sector; // 0x00
    u32 resolution;
    u32 count;
    u32 entries[count];
};

struct alc_footer_t
{
    u32 filename_off;
    u32 widechar;
    u32 unknown1;
    u32 unknown2;
};

struct alc_extra_t
{
    u32 pregap;
    u32 sectors;
};

struct alc_track_t
{
    track_mode_t mode;
    subchannel_mode_t subMode;
    u8 adr_ctrl;
    u8 tno;
    u8 point;
    u8 min;
    u8 sec;
    u8 frame;
    u8 zero;
    u8 pmin;
    u8 psec;
    u8 pframe;
    u32 extra_off;
    u16 sector_size;
    u8 unknown[18];
    u32 start_lba;
    u64 start_off;
    u32 files;
    u32 footer_off;
    u8 unknown2[24];

    if(extra_off > 0)
        alc_extra_t extra @ extra_off;
};

struct alc_session_t
{
    s32 start;
    s32 end;
    u16 sequence;
    u8 all_blocks;
    u8 non_track_blocks;
    u16 first_track;
    u16 last_track;
    u32 unknown;
    u32 track_off;
    alc_track_t tracks[this.all_blocks] @ track_off;
};

struct alc_header_t
{
    type::Magic<"MEDIA DESCRIPTOR"> magic;
    u8 major_version;
    u8 minor_version;
    medium_type_t type;
    u16 sessions;
    u16 unknown1[2];
    u16 bca_len;
    u32 unknown2[2];
    u32 bca_off;
    u32 unknown3[6];
    u32 structures_off;
    u32 unknown4[3];
    u32 session_off;
    u32 dpm_off;
};

alc_header_t header @ 0x00;
alc_session_t sessions[header.sessions] @ header.session_off;

if(sessions[0].tracks[3].footer_off > 0)
{
    alc_footer_t footer @ sessions[0].tracks[3].footer_off;
    
    if(footer.widechar > 0)
        std::string::NullString16 filename @ footer.filename_off;
    else
        std::string::NullString filename @ footer.filename_off;
}

if(header.dpm_off > 0)
    alc_dpm_t dpm @ header.dpm_off;