// /***************************************************************************
// Aaru Data Preservation Suite
// ----------------------------------------------------------------------------
//
// Filename       : stfs.hexpat
// Author(s)      : Natalia Portillo <claunia@claunia.com>
//
// Component      : ImHex pattern for parsing STFS.
// Version        : 1.00
//
// --[ Description ] ----------------------------------------------------------
//
//     Parses Microsoft Secure Transacted File System.
//
// --[ History ] --------------------------------------------------------------
//     
//     1.00: Initial release, parses header, metadata and volume descriptors.
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
#pragma description Microsoft Secure Transacted File System
#pragma endian big
#pragma magic [ 43 4F 4E 20 ] @ 0x00
#pragma magic [ 4C 49 56 45 ] @ 0x00
#pragma magic [ 50 49 52 53 ] @ 0x00

import type.base;
import type.types.win32;
import type.size;

using WCHAR = char16;

enum ContentType : DWORD
{
    SavedGame          = 0x00000001,
    MarketplaceContent = 0x00000002,
    Publisher          = 0x00000003,
    Xbox360Title       = 0x00001000,
    IPTVPauseBuffer    = 0x00002000,
    InstalledGame      = 0x00004000,
    XboxOriginalGame   = 0x00005000,
    XboxTitle          = 0x00005000,
    GameOnDemand       = 0x00007000,
    AvatarItem         = 0x00009000,
    Profile            = 0x00010000,
    GamerPicture       = 0x00020000,
    Theme              = 0x00030000,
    CacheFile          = 0x00040000,
    StorageDownload    = 0x00050000,
    XboxSavedGame      = 0x00060000,
    XboxDownload       = 0x00070000,
    GameDemo           = 0x00080000,
    Video              = 0x00090000,
    GameTitle          = 0x000A0000,
    Installer          = 0x000B0000,
    GameTrailer        = 0x000C0000,
    ArcadeTitle        = 0x000D0000,
    XNA                = 0x000E0000,
    LicenseStore       = 0x000F0000,
    Movie              = 0x00100000,
    TV                 = 0x00200000,
    MusicVideo         = 0x00300000,
    GameVideo          = 0x00400000,
    PodcastVideo       = 0x00500000,
    ViralVideo         = 0x00600000,
    CommunityGame      = 0x02000000
};

enum Platform : BYTE
{
    None    = 0,
    Xbox360 = 2,
    PC      = 4
};

bitfield TransferFlags
{
    ProfileId             : 1 [[comment("Profile ID")]];
    DeviceId              : 1 [[comment("Device ID")]];
    MoveOnly              : 1 [[comment("Move only")]];
    KinectEnabled         : 1 [[comment("Kinect enabled")]];
    DisableNetworkStorage : 1 [[comment("Disable network storage")]];
    DeepLinkSupported     : 1 [[comment("Deep Link supported")]];
    padding               : 2;
};

struct LicenseEntry
{
    type::Hex<LONGLONG> LicenseID    [[comment("XUID / PUID / Console ID")]];
              DWORD     LicenseBits  [[comment("Bits")]];
              DWORD     LicenseFlags [[comment("License flags")]];
} [[comment("License data")]];

struct ConsolePackage
{
    type::Size<WORD> cbPublicKeyCertificateSize   [[comment("Public Key Certificate Size")]];
     type::Hex<BYTE> aConsoleId[5]                [[comment("Certificate Owner Console ID")]];
               CHAR  sConsolePartNumber[0x14]     [[comment("Certificate Owner Console Part Number")]];
               BYTE  cConsoleType                 [[comment("Certificate Owner Console Type")]];
               CHAR  sDateOfGeneration[8]         [[comment("Certificate Date of Generation")]];
               DWORD dwPublicExponent             [[comment("Public Exponent")]];
               BYTE  aPublicModulus[0x80]         [[comment("Public Modulus")]];
               BYTE  aCertificateSignature[0x100] [[comment("Certificate Signature")]];
               BYTE  aSignature[0x80]             [[comment("Signature")]];
} [[comment("Console-signed package")]];

struct RemotePackage
{
    BYTE aSignature[0x100] [[comment("Signature")]];
         padding[0x128];
} [[comment("Microsoft-signed package")]];

struct StfsVolumeDescriptor
{
    type::Size<BYTE> cbSize                       [[comment("Volume Descriptor size")]];
                     padding[1];
               BYTE  cBlockSeparation             [[comment("Block separation")]];
               SHORT cxFileTableBlockCount        [[comment("File table block count")]];
               s24   dwFileTableBlockNumber       [[comment("File table block number")]];
               BYTE  aTopHashTableHash[0x14]      [[comment("Top hash table hash")]];
               LONG  cxTotalAllocatedBlockCount   [[comment("Total allocated block count")]];
               LONG  cxTotalUnallocatedBlockCount [[comment("Total unallocated block count")]];
} [[comment("STFS Volume Descriptor")]];

struct SvodVolumeDescriptor
{
    type::Size<BYTE> cbSize                  [[comment("Volume Descriptor size")]];
               BYTE  cBlockCacheElementCount [[comment("Block cache element count")]];
               BYTE  cWorkerThreadProcessor  [[comment("Worker thread processor")]];
               BYTE  cWorkerThreadPriority   [[comment("Worked thread priority")]];
               BYTE  aHash[0x14]             [[comment("Hash")]];
               BYTE  cDeviceFeatures         [[comment("Device features")]];
               u24   dwDataBlockCount        [[comment("Data block count")]];
               u24   dwDataBlockOffset       [[comment("Data block offset")]];
                     padding[5];
} [[comment("SVOD Volume Descriptor")]];

struct MetadataString
{
    WCHAR szName[0x40];
} [[inline]];

struct Metadata
{
        LicenseEntry      aLicensingData[0x10] [[comment("Licensing data")]];
               BYTE       aHeaderSha1[0x14]    [[comment("Header SHA1")]];
    type::Size<DWORD>     cbHeaderSize         [[comment("Header size")]];
         ContentType      dwContentType        [[comment("Content type")]];
               DWORD      dwMetadataVersion    [[comment("Metadata version")]];
    type::Size<LONGLONG>  cbContentSize        [[comment("Content size")]];
     type::Hex<DWORD>     dwMediaId            [[comment("Media ID")]];
               LONG       lVersion             [[comment("Version")]];
               LONG       lBaseVersion         [[comment("Base version")]];
     type::Hex<DWORD>     dwTitleId            [[comment("Title ID")]];
            Platform      cPlatform            [[comment("Platform")]];
               BYTE       cExecutableType      [[comment("Executable type")]];
               BYTE       cDiscNumber          [[comment("Disc number")]];
               BYTE       cDiscInSet           [[comment("Disc in set")]];
     type::Hex<DWORD>     dwSaveGameID         [[comment("Save game ID")]];
     type::Hex<BYTE>      aConsoleID[5]        [[comment("Console ID")]];
     type::Hex<ULONGLONG> ullProfileID         [[comment("Profile ID")]];
    
    // Jump to descriptor type    
    $ += sizeof(StfsVolumeDescriptor) + sizeof(LONG) + sizeof(LONGLONG);
    DWORD dwDescriptorType [[comment("Descriptor type")]];
    // Jump back
    $ -= (sizeof(StfsVolumeDescriptor) + sizeof(LONG) + sizeof(LONGLONG) + sizeof(DWORD));

    if(dwDescriptorType == 0)
        StfsVolumeDescriptor VolumeDescriptor [[comment("Volume Descriptor")]];
    else if(dwDescriptorType == 1)
        SvodVolumeDescriptor VolumeDescriptor [[comment("Volume Descriptor")]];
    else
        std::error("Invalid descriptor type.");
               LONG      lDataFileCount         [[comment("Data file count")]];
    type::Size<LONGLONG> cbDataFileCombinedSize [[comment("Data file combined size")]];
    padding[sizeof(DWORD)];
    LONG lReserved [[comment("Reserved")]];
    if(dwMetadataVersion == 1)
        padding[0x4C];
    else if(dwMetadataVersion == 2)
    {
        type::Hex<BYTE> aSeriesID[0x10] [[comment("Series ID")]];
        type::Hex<BYTE> aSeasonID[0x10] [[comment("Season ID")]];
                  SHORT iSeasonNumber   [[comment("Season number")]];
                  SHORT iEpisodeNumber  [[comment("Episode number")]];
                        padding[0x28];
    }
    else
        std::error("Invalid metadata version.");

               CHAR  szDeviceID[0x14]          [[comment("Device ID")]];
      MetadataString aDisplayName[18]          [[comment("Display names")]];
      MetadataString aDisplayDescription[18]   [[comment("Display descriptions")]];
               WCHAR szPublisherName[0x40]     [[comment("Publisher name")]];
               WCHAR szTitleName[0x40]         [[comment("Title name")]];
       TransferFlags cTransferFlags            [[comment("Transfer flags")]];
    type::Size<LONG> cbThumbnailImageSize      [[comment("Thumbnail image size")]];
    type::Size<LONG> cbTitleThumbnailImageSize [[comment("Title thumbnail image size")]];

    if(dwMetadataVersion == 1)
    {
        BYTE aThumbnailImage[0x4000] [[comment("Thumbnail image")]];
        BYTE aTitleThumbnailImage[0x4000] [[comment("Title thumbnail image")]];
    }
    else if(dwMetadataVersion == 2)
    {
                  BYTE aThumbnailImage[0x3D00]           [[comment("Thumbnail image")]];
        MetadataString aAdditionalDisplayNames[6]        [[comment("Additional display names")]];
                  BYTE aTitleThumbnailImage[0x3D00]      [[comment("Title thumbnail image")]];
        MetadataString aAdditionalDisplayDescriptions[6] [[comment("Additional display descriptions")]];
    }
    else
        std::error("Invalid metadata version.");
} [[comment("Package metadata")]];

struct STFS
{
    CHAR sMagic[4] [[comment("Magic identifier")]];
    
    if(sMagic == "CON ")
        ConsolePackage package;
    else if(sMagic == "LIVE" || sMagic == "PIRS")
        RemotePackage package;
    else
        std::error("Invalid magic.");
    
    Metadata metadata;
};

STFS stfs @ 0x00 [[comment("Secure Transacted File System")]];
