// /***************************************************************************
// Aaru Data Preservation Suite
// ----------------------------------------------------------------------------
//
// Filename       : D88.hexpat
// Author(s)      : Natalia Portillo <claunia@claunia.com>
//
// Component      : ImHex pattern for parsing D88 disk images.
// Version        : 1.00
//
// --[ Description ] ----------------------------------------------------------
//
//     Parses D88 disk images.
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

// TODO: Parse tracks and sectors. Missing how to do array of pointers

#pragma author Nat Portillo <claunia@claunia.com>
#pragma description D88 disk image parser (*.D88)
#pragma endian little

enum ibm_sector_size_t : u8
{
    _128b = 0,
    _256b = 1,
    _512b = 2,
    _1k = 3,
    _2k = 4,
    _4k = 5,
    _8k = 6,
    _16k = 7
};

enum disk_type_t : u8
{
    D2  = 0x00,
    DD2 = 0x10,
    HD2 = 0x20
};

enum density_type_t : u8
{
    MFM = 0x00,
    FM  = 0x40
};

struct d88_sector_t
{
    // Cylinder ID の C
    u8 c;
    // Head ID の H
    u8 h;
    // Sector number ID の R
    u8 r;
    // Sector size ID の N
    ibm_sector_size_t n;
    // Number of sectors in this track このトラック内に存在するセクタの数
    s16 spt;
    // Density: 0x00 MFM, 0x40 FM 記録密度： 0x00 倍密度、0x40 単密度
    density_type_t density;
    // Deleted sector, 0x00 not deleted, 0x10 deleted DELETED MARK： 0x00 ノーマル、 0x10 DELETED
    u8 deleted_mark;
    // Sector status ステータス
    u8 status;
    // Reserved リザーブ
    padding[5];
    // Size of data following this field このセクタ部のデータサイズ
    s16 size_of_data;
};

struct d88_header_t
{
    // Disk name, nul-terminated ASCII ディスクの名前(ASCII + '\0')
    char name[17];
    // Reserved ディスクの名前(ASCII + '\0')
    padding[9];
    // Write protect status ライトプロテクト： 0x00 なし、0x10 あり
    u8 write_protect;
    // Disk type ディスクの種類： 0x00 2D、 0x10 2DD、 0x20 2HD
    disk_type_t disk_type;
    // Disk image size ディスクのサイズ
    s32 disk_size;
    // Track pointers トラック部のオフセットテーブル 0 Track ～ 163 Track
    s32 track_table[164];
};
    
d88_header_t header @ 0x00;