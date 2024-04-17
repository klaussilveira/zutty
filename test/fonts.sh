#!/usr/bin/env bash

cd $(dirname $0)

# This test requires a set of fonts to be present.  See the comments
# above each test function on how to install them on a Debian system.
#
# Certain fonts are simply available via packages; others can be
# manually downloaded as an archive.  Some require further
# installation steps, outlined below.
#
# This test is a little bit special in that it starts up a new UUT
# instance for each snapshot - this is needed so we can hack the
# font-selection arguments in (plus, Zutty does not presently support
# any form of runtime font selection).
#
# Also, fonts might change in subtle ways and an altered hash does not
# necessarily indicate a bug. It merely serves as an indication of
# where manual inspection should be directed.
#
# For all the above reasons, this test is *not* run as part of run-ci,
# but it should nevertheless be manually run (and the results
# inspected) whenever touching the font rasterization code (font.cc).


ABORT_ON_MISMATCH=1


function CHECK {
    local snap_name="$1"; shift
    local snap_hash="$1"; shift

    export SNAP_NAME=${snap_name}
    export SNAP_HASH=${snap_hash}

    ./fonttest.sh
    [ $? -ne 0 ] && [ ${ABORT_ON_MISMATCH} -ne 0 ] && exit 1
}


function FONTS_MISC_FIXED {

    # Misc-fixed
    # Package: xfonts-base

    export UUT_ARGS="-font 6x13"
    CHECK font_MF_6x13 c122541e434a3936292313fe5a1dcb23

    export UUT_ARGS="-font 7x13"
    CHECK font_MF_7x13 fb81be8e07d640444b4f3bde989cecd2

    export UUT_ARGS="-font 7x14"
    CHECK font_MF_7x14 d1dd54ae5d2e6ad4c8f974b3997803bf

    export UUT_ARGS="-font 8x13"
    CHECK font_MF_8x13 ffa541369babee888b3ab010fd78b498

    export UUT_ARGS="-font 9x15"
    CHECK font_MF_9x15 eb6b842bf53a7d438c5fc4383055d4b6

    export UUT_ARGS="-font 9x18"
    CHECK font_MF_9x18 f59252acd1a6ef42da1ba57df1bedf23
}

function FONTS_UW_T0 {

    # UW ttyp0
    # URL: https://people.mpi-inf.mpg.de/~uwe/misc/uw-ttyp0/uw-ttyp0-1.3.tar.gz
    #
    # After downloading and unpacking the archive under deps/fonts,
    # the font files need to be built:
    #   cd uw-ttyp0-1.3 && ./configure && make && cd ..
    #
    # Then, copy the generated Unicode-encoded files to discoverable names:
    #   for f in uw-ttyp0-1.3/genpcf/*-uni.pcf.gz
    #   do
    #       cp $f $(basename $(echo $f | sed 's/-uni//'))
    #   done

    export UUT_ARGS="-fontpath deps/fonts -font t0-11"
    CHECK font_T0_11 7740f3bb70272deaa5066b3ef0a51b4e

    export UUT_ARGS="-fontpath deps/fonts -font t0-12"
    CHECK font_T0_12 3f113c28efe40d3970e0295a4b79f4e3

    export UUT_ARGS="-fontpath deps/fonts -font t0-13"
    CHECK font_T0_13 ddbfae80b0879a53b7ca480f6e13346c

    export UUT_ARGS="-fontpath deps/fonts -font t0-14"
    CHECK font_T0_14 f60eced153d792f70901c4ce8cb88c51

    export UUT_ARGS="-fontpath deps/fonts -font t0-15"
    CHECK font_T0_15 8ad5eb26d8b37950b96bd149cde003e0

    export UUT_ARGS="-fontpath deps/fonts -font t0-16"
    CHECK font_T0_16 6aecc93c613f6cd467aba2e91cbf9336

    export UUT_ARGS="-fontpath deps/fonts -font t0-17"
    CHECK font_T0_17 47c9a227e17bbb15917da23335af9a2d

    export UUT_ARGS="-fontpath deps/fonts -font t0-18"
    CHECK font_T0_18 d40cec931c10d3792d314e622c68526f

    export UUT_ARGS="-fontpath deps/fonts -font t0-22"
    CHECK font_T0_22 1604af8ac6c2cb4a5cd855dbecb2e559
}

function FONTS_LIBERATION_MONO {

    # Liberation Mono
    # Package: fonts-liberation

    export UUT_ARGS="-font LiberationMono -fontsize 12"
    CHECK font_LM_12 d70a20cdd9003fb5fe8241e454e1c8ea

    export UUT_ARGS="-font LiberationMono -fontsize 15"
    CHECK font_LM_15 b2cce7703725f0092eb1781c2974d911

    export UUT_ARGS="-font LiberationMono -fontsize 18"
    CHECK font_LM_18 7267e38115006764d1e70d05b43b2ef3

    export UUT_ARGS="-font LiberationMono -fontsize 21"
    CHECK font_LM_21 5e3c63509226b67c67a7c750714a7cd8

    export UUT_ARGS="-font LiberationMono -fontsize 24"
    CHECK font_LM_24 d611af9bb719e5779db867e3bad0faa4

    export UUT_ARGS="-font LiberationMono -fontsize 27"
    CHECK font_LM_27 60c4f0dca0a726663eb9ea650e32c40c

    export UUT_ARGS="-font LiberationMono -fontsize 30"
    CHECK font_LM_30 9b46c5e8289f3606cedad8a9b37005fc

    export UUT_ARGS="-font LiberationMono -fontsize 37"
    CHECK font_LM_37 502258e7ebb590723f067354e414f561
}

function FONTS_DEJA_VU_SANS_MONO {

    # Deja Vu Sans Mono
    # Package: fonts-dejavu-core

    export UUT_ARGS="-font DejaVuSansMono -fontsize 12"
    CHECK font_DV_12 387a074d3eb23123241ea68f1034b1a8

    export UUT_ARGS="-font DejaVuSansMono -fontsize 15"
    CHECK font_DV_15 d76835f0bf175bb0d9a3d4ed0690d092

    export UUT_ARGS="-font DejaVuSansMono -fontsize 18"
    CHECK font_DV_18 288edeb3c7dfd347bcbf87c75abf8c13

    export UUT_ARGS="-font DejaVuSansMono -fontsize 21"
    CHECK font_DV_21 5a6596cf68f2ac87525b96c6b10c8938

    export UUT_ARGS="-font DejaVuSansMono -fontsize 24"
    CHECK font_DV_24 f552af85ccef5e576f8db0ec45193dfc

    export UUT_ARGS="-font DejaVuSansMono -fontsize 27"
    CHECK font_DV_27 6d8bf44247884a55afe093fc309ecaf4

    export UUT_ARGS="-font DejaVuSansMono -fontsize 30"
    CHECK font_DV_30 dceedcc1e456c2b1c96129a274e7c107

    export UUT_ARGS="-font DejaVuSansMono -fontsize 37"
    CHECK font_DV_37 e0bae55be600f1d712061c9817fed895
}

function FONTS_FIRA_CODE {

    # Fira Code
    # URL: https://github.com/tonsky/FiraCode/releases/download/6.2/Fira_Code_v6.2.zip

    export UUT_ARGS="-fontpath deps/fonts -font FiraCode -fontsize 12"
    CHECK font_FC_12 9f1f28e0e5159e85138a7979d87d41d1

    export UUT_ARGS="-fontpath deps/fonts -font FiraCode -fontsize 15"
    CHECK font_FC_15 b657452e1cb0e8ccaa3ba052610ff385

    export UUT_ARGS="-fontpath deps/fonts -font FiraCode -fontsize 18"
    CHECK font_FC_18 82e0857f1a3ec0cd7ba19e011e6a705e

    export UUT_ARGS="-fontpath deps/fonts -font FiraCode -fontsize 21"
    CHECK font_FC_21 b64b57e23a27628fa21c7ebe416f7cd7

    export UUT_ARGS="-fontpath deps/fonts -font FiraCode -fontsize 24"
    CHECK font_FC_24 8ff3bbffe0c6f2d6239b7dd257072256

    export UUT_ARGS="-fontpath deps/fonts -font FiraCode -fontsize 27"
    CHECK font_FC_27 ba0d19771baab8ecfe0e312b2091168f

    export UUT_ARGS="-fontpath deps/fonts -font FiraCode -fontsize 30"
    CHECK font_FC_30 ad8003daf5d0cc746e397f149e7e6214

    export UUT_ARGS="-fontpath deps/fonts -font FiraCode -fontsize 37"
    CHECK font_FC_37 bcbfdf2e4d8f74790ae915bc5484561e
}

function FONTS_JETBRAINS_MONO {

    # JetBrains Mono
    # URL: https://github.com/JetBrains/JetBrainsMono/releases/download/v2.304/JetBrainsMono-2.304.zip

    export UUT_ARGS="-fontpath deps/fonts -font JetBrainsMono -fontsize 12"
    CHECK font_JB_12 0a985f62d760216bf0319f81240b82cc

    export UUT_ARGS="-fontpath deps/fonts -font JetBrainsMono -fontsize 15"
    CHECK font_JB_15 f0841922647875e6b9fb7ea0b60480ae

    export UUT_ARGS="-fontpath deps/fonts -font JetBrainsMono -fontsize 18"
    CHECK font_JB_18 b75b07d02b85514f45b8764f7e95e8cd

    export UUT_ARGS="-fontpath deps/fonts -font JetBrainsMono -fontsize 21"
    CHECK font_JB_21 5c0c51bdd1da66b196cdb38cd129cc68

    export UUT_ARGS="-fontpath deps/fonts -font JetBrainsMono -fontsize 24"
    CHECK font_JB_24 5ab03d0b54424484e4a18b7638e22986

    export UUT_ARGS="-fontpath deps/fonts -font JetBrainsMono -fontsize 27"
    CHECK font_JB_27 75ed8883aecb0992e5d1550330088a73

    export UUT_ARGS="-fontpath deps/fonts -font JetBrainsMono -fontsize 30"
    CHECK font_JB_30 a2768a4dc8e92e583283f55f221876a0

    export UUT_ARGS="-fontpath deps/fonts -font JetBrainsMono -fontsize 37"
    CHECK font_JB_37 49b3a745dba60d91f28afa8da4a8d450
}

function FONTS_SOURCE_CODE_PRO {

    # Source Code Pro
    # URL: https://github.com/adobe-fonts/source-code-pro/releases/download/2.042R-u%2F1.062R-i%2F1.026R-vf/TTF-source-code-pro-2.042R-u_1.062R-i.zip

    export UUT_ARGS="-fontpath deps/fonts -font SourceCodePro -fontsize 12"
    CHECK font_SC_12 c3eb55f5f06055b52a282ce304a79cbd

    export UUT_ARGS="-fontpath deps/fonts -font SourceCodePro -fontsize 15"
    CHECK font_SC_15 5bb8b91b60e570af4d1733d57d70d169

    export UUT_ARGS="-fontpath deps/fonts -font SourceCodePro -fontsize 18"
    CHECK font_SC_18 c3f7a87c96233daf6f2377fe24ce5c2f

    export UUT_ARGS="-fontpath deps/fonts -font SourceCodePro -fontsize 21"
    CHECK font_SC_21 c9cfc32109a9b817f040fe381bef1b08

    export UUT_ARGS="-fontpath deps/fonts -font SourceCodePro -fontsize 24"
    CHECK font_SC_24 025963f1bfa8b20479a44b6495d57ea2

    export UUT_ARGS="-fontpath deps/fonts -font SourceCodePro -fontsize 27"
    CHECK font_SC_27 8d07192fbbc83545b7778fd962a5fcf7

    export UUT_ARGS="-fontpath deps/fonts -font SourceCodePro -fontsize 30"
    CHECK font_SC_30 6a5c2040f759b12703a81c6c51df6d1a

    export UUT_ARGS="-fontpath deps/fonts -font SourceCodePro -fontsize 37"
    CHECK font_SC_37 1f4493ca4f41861525ae051e1d22f250
}

function FONTS_HASKLIG {

    # Hasklig
    # URL: https://github.com/i-tu/Hasklig/releases/download/v1.2/Hasklig-1.2.zip

    export UUT_ARGS="-fontpath deps/fonts -font Hasklig -fontsize 12"
    CHECK font_HA_12 2ec9e3a922a311b0d616bf10e5c6c89f

    export UUT_ARGS="-fontpath deps/fonts -font Hasklig -fontsize 15"
    CHECK font_HA_15 ac879e0c6fd8b7ef877b8374baecd95f

    export UUT_ARGS="-fontpath deps/fonts -font Hasklig -fontsize 18"
    CHECK font_HA_18 6c4ba85a63732c3794c3cd5f58b8f9aa

    export UUT_ARGS="-fontpath deps/fonts -font Hasklig -fontsize 21"
    CHECK font_HA_21 dcd667b355058b58c2c0cbd2fa40244f

    export UUT_ARGS="-fontpath deps/fonts -font Hasklig -fontsize 24"
    CHECK font_HA_24 5b65900c763ebf72c582c5f1084eb47e

    export UUT_ARGS="-fontpath deps/fonts -font Hasklig -fontsize 27"
    CHECK font_HA_27 432d2ed5ea4b0d8cf2001ae9877662b2

    export UUT_ARGS="-fontpath deps/fonts -font Hasklig -fontsize 30"
    CHECK font_HA_30 e906027f9f9c620ae369a2e8400d3c19

    export UUT_ARGS="-fontpath deps/fonts -font Hasklig -fontsize 37"
    CHECK font_HA_37 ab9541bc620cfb3530142600c57dd7a5
}

function FONTS_FREEMONO {

    # Free Mono
    # Package: fonts-freemono-ttf

    export UUT_ARGS="-font FreeMono -fontsize 12"
    CHECK font_FM_12 ef689d7012ffb4277802b3e57b6b1565

    export UUT_ARGS="-font FreeMono -fontsize 15"
    CHECK font_FM_15 ed44823b7c273bf706362033032808eb

    export UUT_ARGS="-font FreeMono -fontsize 18"
    CHECK font_FM_18 a2239631c0cb759793756652babd3780

    export UUT_ARGS="-font FreeMono -fontsize 21"
    CHECK font_FM_21 10dfe7ffedfb5af34400cfdc0d701683

    export UUT_ARGS="-font FreeMono -fontsize 24"
    CHECK font_FM_24 4b199b89b461b743287b0ced997c6f42

    export UUT_ARGS="-font FreeMono -fontsize 27"
    CHECK font_FM_27 87d96b476aca260322459142f2ed3aad

    export UUT_ARGS="-font FreeMono -fontsize 30"
    CHECK font_FM_30 5d02f70cebc235777b97969340a39b0d

    export UUT_ARGS="-font FreeMono -fontsize 37"
    CHECK font_FM_37 ae2682c38fd0bd9bfe9d28600bbac5bd
}

function FONTS_ANONYMOUS_PRO {

    # Anonymous Pro
    # Package: fonts-anonymous-pro
    #
    # After installing, copy the font files to more convenient names:
    #   for f in /usr/share/fonts/truetype/anonymous-pro/*.ttf
    #   do
    #       cp "$f" $(basename $(echo $f | sed 's/ //g'))
    #   done

    # N.B.: Size 12 is a bitmap face that does not seem to work well ATM

    export UUT_ARGS="-fontpath deps/fonts -font AnonymousPro -fontsize 15"
    CHECK font_AP_15 35b0f2aad0665183c9081535a05a472d

    export UUT_ARGS="-fontpath deps/fonts -font AnonymousPro -fontsize 18"
    CHECK font_AP_18 8bbaba14ae286e1bb131b9649f87cd9a

    export UUT_ARGS="-fontpath deps/fonts -font AnonymousPro -fontsize 21"
    CHECK font_AP_21 8cf63a480f7b872524856a82c3431673

    export UUT_ARGS="-fontpath deps/fonts -font AnonymousPro -fontsize 24"
    CHECK font_AP_24 d1f43e0ee1ed5c94adfdcc3a7ecdbb57

    export UUT_ARGS="-fontpath deps/fonts -font AnonymousPro -fontsize 27"
    CHECK font_AP_27 2222438d80d1dd827d3e32ac474f9ba6

    export UUT_ARGS="-fontpath deps/fonts -font AnonymousPro -fontsize 30"
    CHECK font_AP_30 c678970d1b7202b1e910520f638ea731

    export UUT_ARGS="-fontpath deps/fonts -font AnonymousPro -fontsize 37"
    CHECK font_AP_37 a36024aee7de6950614a5e0d20929a13
}

FONTS_MISC_FIXED
FONTS_UW_T0

FONTS_LIBERATION_MONO
FONTS_DEJA_VU_SANS_MONO
FONTS_FIRA_CODE
FONTS_JETBRAINS_MONO
FONTS_SOURCE_CODE_PRO
FONTS_HASKLIG
FONTS_FREEMONO
FONTS_ANONYMOUS_PRO
