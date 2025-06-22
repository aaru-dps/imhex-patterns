// /***************************************************************************
// Aaru Data Preservation Suite
// ----------------------------------------------------------------------------
//
// Filename       : BlindWrite5.hexpat
// Author(s)      : Natalia Portillo <claunia@claunia.com>
//
// Component      : ImHex pattern for parsing BlindWrite 5 disc images.
// Version        : 1.00
//
// --[ Description ] ----------------------------------------------------------
//
//     Parses BlindWrite 5 disc images.
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
#pragma description BlindWrite 5 disc image parser (*.B5T)
#pragma endian big
#pragma magic [ "BWT5 STREAM SIGN" ] @ 0x00

import type.magic;

enum bw5_track_type_t : u8
{
 NotData = 0,
 Audio = 1,
 Mode1 = 2,
 Mode2 = 3,
 Mode2F1 = 4,
 Mode2F2 = 5,
 Dvd = 6
};

enum bw5_subchannel_type_t : u8
{
 None = 0,
 Q16 = 2,
 Linear = 4
};

struct bw5_data_file_t
{
    u32 type;
    u32 length;
    u32 unknown1[4];
    u32 offset;
    u32 unknown2[3];
    s32 start_lba;
    s32 sectors;
    u32 filename_len;
    char16 filename[filename_len/2];
    u32 unknown3;
};

bitfield HOUR
{
    PHOUR : 4;
    AHOUR : 4;
};

struct bw5_track_descriptor_t
{
    bw5_track_type_t type;
    u8 unknown1[3];
    u32 unknown2;
    bw5_subchannel_type_t subchannel;
    u8 unknown3;
    u8 CONTROL;
    u8 ADR;
    u8 POINT;
    u8 TNO;
    u8 AMIN;
    u8 ASEC;
    u8 AFRAME;
    HOUR;
    u8 PMIN;
    u8 PSEC;
    u8 PFRAME;
    u8 unknown5;
    u32 pregap;
    u32 unknown6[4];
    s32 startLba;
    s32 sectors;
    u32 unknown7[2];
    u32 session;
    u16 unknown8;
    if(type != 6 && type != 0)
        u32 unknown9[2];
};

struct bw5_session_t
{
    u16 sequence;
    u8 entries;
    u8 unknown;
    s32 start;
    s32 end;
    u16 firstTrack;
    u16 lastTrack;
    bw5_track_descriptor_t tracks[entries];
};

struct bw5_header_t
{
    type::Magic<"BWT5 STREAM SIGN"> header;
    u32 unknown1[8];
    u16 profile;
    u16 sessions;
    u32 unknown2[3];
    bool valid_mcn;
    char mcn[13];
    u16 unknown3;
    u32 unknown4[4];
    u16 pma_len;
    u16 atip_len;
    u16 cdtext_len;
    u16 cdinfo_len;
    u32 bca_len;
    u32 unknown5[3];
    u32 dvd_structures_len;
    u32 dvdinfo_len;
    u8 unknown6[32];
    char manufacturer[8];
    char product[16];
    char revision[4];
    char vendor[20];
    char volumeId[32];
    u32 mode_2a_len;
    u32 unknown_block_len;
    u32 data_len;
    u32 sessions_len;
    u32 dpm_len;
    u8 mode_2a[mode_2a_len];
    u8 unknown_block[unknown_block_len];
    u8 pma[pma_len];
    u8 atip[atip_len];
    u8 cdtext[cdtext_len];
    u8 bca[bca_len];
    u8 dvd_structures[dvd_structures_len];
    u8 dvdinformation[dvdinfo_len];
    u8 cdinformation[cdinfo_len];
    u32 data_block_count;
    u32 data_path_len;
    char16 data_path[data_path_len/2];
    bw5_data_file_t data_blocks[data_block_count];
    bw5_session_t session[sessions];
    u8 dpm[dpm_len];
    u32 unknown7;
    type::Magic<"BWT5 STREAM FOOT"> footer;
};

bw5_header_t header @ 0x00;