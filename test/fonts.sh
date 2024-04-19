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
    CHECK font_LM_12 9ea66f51231dcc20de9fae19c552de38

    export UUT_ARGS="-font LiberationMono -fontsize 15"
    CHECK font_LM_15 16e68d535d232bc2970052e26eca748c

    export UUT_ARGS="-font LiberationMono -fontsize 18"
    CHECK font_LM_18 39c19d7d42f9249c39f9fc6798aca4c6

    export UUT_ARGS="-font LiberationMono -fontsize 21"
    CHECK font_LM_21 63550ee26a269978f642c00ad0f749ab

    export UUT_ARGS="-font LiberationMono -fontsize 24"
    CHECK font_LM_24 fd5ae539b845e823207071123ef31438

    export UUT_ARGS="-font LiberationMono -fontsize 27"
    CHECK font_LM_27 3dcb454c2fc372a18e4cab6ef0472c63

    export UUT_ARGS="-font LiberationMono -fontsize 30"
    CHECK font_LM_30 f639c17df8c72fbdec83f4922401ca74

    export UUT_ARGS="-font LiberationMono -fontsize 37"
    CHECK font_LM_37 f796e4356b3d2c838ebc9a4ce08fcb29
}

function FONTS_DEJA_VU_SANS_MONO {

    # Deja Vu Sans Mono
    # Package: fonts-dejavu-core

    export UUT_ARGS="-font DejaVuSansMono -fontsize 12"
    CHECK font_DV_12 9090771135527719714f844e6063a914

    export UUT_ARGS="-font DejaVuSansMono -fontsize 15"
    CHECK font_DV_15 bbd4ef117344f73cd14579bc29dd0573

    export UUT_ARGS="-font DejaVuSansMono -fontsize 18"
    CHECK font_DV_18 93c144ce3c5e80d33f16240f225294e7

    export UUT_ARGS="-font DejaVuSansMono -fontsize 21"
    CHECK font_DV_21 bee642f6e36bcea483451905994ad49d

    export UUT_ARGS="-font DejaVuSansMono -fontsize 24"
    CHECK font_DV_24 aa57b67a4ad08d5e655560e607794713

    export UUT_ARGS="-font DejaVuSansMono -fontsize 27"
    CHECK font_DV_27 3d14bbc2fc01424c6b5669b1b01a630a

    export UUT_ARGS="-font DejaVuSansMono -fontsize 30"
    CHECK font_DV_30 c2a3efdd4aaf717b3d821682f7d89a06

    export UUT_ARGS="-font DejaVuSansMono -fontsize 37"
    CHECK font_DV_37 2c36936c319a18c46072f3d8250b2e0c
}

function FONTS_FIRA_CODE {

    # Fira Code
    # URL: https://github.com/tonsky/FiraCode/releases/download/6.2/Fira_Code_v6.2.zip

    export UUT_ARGS="-fontpath deps/fonts -font FiraCode -fontsize 12"
    CHECK font_FC_12 7455799c3de6753e5b91a6ae43ea0afb

    export UUT_ARGS="-fontpath deps/fonts -font FiraCode -fontsize 15"
    CHECK font_FC_15 e644cd42b7ea38290615b829aa9c5b87

    export UUT_ARGS="-fontpath deps/fonts -font FiraCode -fontsize 18"
    CHECK font_FC_18 cdef496458f1ee34bb3168c47af665ab

    export UUT_ARGS="-fontpath deps/fonts -font FiraCode -fontsize 21"
    CHECK font_FC_21 8b2d2c04882ff815adca58ca70900d2c

    export UUT_ARGS="-fontpath deps/fonts -font FiraCode -fontsize 24"
    CHECK font_FC_24 c398e86601130ebb727db6f69a5a406a

    export UUT_ARGS="-fontpath deps/fonts -font FiraCode -fontsize 27"
    CHECK font_FC_27 423a16f3227402b06bf9c789afcb8dbf

    export UUT_ARGS="-fontpath deps/fonts -font FiraCode -fontsize 30"
    CHECK font_FC_30 73fd555bc0070df9fcf1435addb5589d

    export UUT_ARGS="-fontpath deps/fonts -font FiraCode -fontsize 37"
    CHECK font_FC_37 67f6120a6fd84637792b04ea9d41a20b
}

function FONTS_JETBRAINS_MONO {

    # JetBrains Mono
    # URL: https://github.com/JetBrains/JetBrainsMono/releases/download/v2.304/JetBrainsMono-2.304.zip

    export UUT_ARGS="-fontpath deps/fonts -font JetBrainsMono -fontsize 12"
    CHECK font_JB_12 1d12a448e5d48ece057ee04c146cff58

    export UUT_ARGS="-fontpath deps/fonts -font JetBrainsMono -fontsize 15"
    CHECK font_JB_15 b3bde6c91f06f5912f7984becd43b497

    export UUT_ARGS="-fontpath deps/fonts -font JetBrainsMono -fontsize 18"
    CHECK font_JB_18 87b0a778432d3a604dd325a87397f09f

    export UUT_ARGS="-fontpath deps/fonts -font JetBrainsMono -fontsize 21"
    CHECK font_JB_21 f0079ec131d279b98079c7da757c2cdf

    export UUT_ARGS="-fontpath deps/fonts -font JetBrainsMono -fontsize 24"
    CHECK font_JB_24 d6a53762baffed162f89e2281abec697

    export UUT_ARGS="-fontpath deps/fonts -font JetBrainsMono -fontsize 27"
    CHECK font_JB_27 185e2b5a24c038ba307be36a7706c66b

    export UUT_ARGS="-fontpath deps/fonts -font JetBrainsMono -fontsize 30"
    CHECK font_JB_30 5bc37123fecf3d9e671f9eaae7f720e3

    export UUT_ARGS="-fontpath deps/fonts -font JetBrainsMono -fontsize 37"
    CHECK font_JB_37 33fa1fdf7848d3f1054489318509de89
}

function FONTS_SOURCE_CODE_PRO {

    # Source Code Pro
    # URL: https://github.com/adobe-fonts/source-code-pro/releases/download/2.042R-u%2F1.062R-i%2F1.026R-vf/TTF-source-code-pro-2.042R-u_1.062R-i.zip

    export UUT_ARGS="-fontpath deps/fonts -font SourceCodePro -fontsize 12"
    CHECK font_SC_12 d917d67fc74ef6e50dc5a48d5c37aa73

    export UUT_ARGS="-fontpath deps/fonts -font SourceCodePro -fontsize 15"
    CHECK font_SC_15 2cb4d8d575f430d6bed02e06574d2a39

    export UUT_ARGS="-fontpath deps/fonts -font SourceCodePro -fontsize 18"
    CHECK font_SC_18 4008f5d264358c61063bb88510f9f8b5

    export UUT_ARGS="-fontpath deps/fonts -font SourceCodePro -fontsize 21"
    CHECK font_SC_21 bf780e4e797cb6811f2e27209cbb188d

    export UUT_ARGS="-fontpath deps/fonts -font SourceCodePro -fontsize 24"
    CHECK font_SC_24 ef527e736bac6b5e2802af6490a34e0a

    export UUT_ARGS="-fontpath deps/fonts -font SourceCodePro -fontsize 27"
    CHECK font_SC_27 036201d4ece179bc0e0ad65d953a484a

    export UUT_ARGS="-fontpath deps/fonts -font SourceCodePro -fontsize 30"
    CHECK font_SC_30 9fe2b036301cd3d8a0b0035f51c95ba3

    export UUT_ARGS="-fontpath deps/fonts -font SourceCodePro -fontsize 37"
    CHECK font_SC_37 544527237b9d98d4f95623b9ac9480ec
}

function FONTS_HASKLIG {

    # Hasklig
    # URL: https://github.com/i-tu/Hasklig/releases/download/v1.2/Hasklig-1.2.zip

    export UUT_ARGS="-fontpath deps/fonts -font Hasklig -fontsize 12"
    CHECK font_HA_12 20828b3ce6745fd1353394141239586a

    export UUT_ARGS="-fontpath deps/fonts -font Hasklig -fontsize 15"
    CHECK font_HA_15 95ac0b50feb4ebb459af791e41796c03

    export UUT_ARGS="-fontpath deps/fonts -font Hasklig -fontsize 18"
    CHECK font_HA_18 d972dcde9ce200509cfeac884dd2b775

    export UUT_ARGS="-fontpath deps/fonts -font Hasklig -fontsize 21"
    CHECK font_HA_21 11310f0d15360ec13e6bf05f21b421c0

    export UUT_ARGS="-fontpath deps/fonts -font Hasklig -fontsize 24"
    CHECK font_HA_24 322935cbd0c12217b965d37651a02197

    export UUT_ARGS="-fontpath deps/fonts -font Hasklig -fontsize 27"
    CHECK font_HA_27 faeffa429d8985af9eba33457cd0558f

    export UUT_ARGS="-fontpath deps/fonts -font Hasklig -fontsize 30"
    CHECK font_HA_30 4eda9c7500b8a40e0537aa1abbbf4168

    export UUT_ARGS="-fontpath deps/fonts -font Hasklig -fontsize 37"
    CHECK font_HA_37 c1ca0a1cd19cc58acd4486203795cb17
}

function FONTS_FREEMONO {

    # Free Mono
    # Package: fonts-freemono-ttf

    export UUT_ARGS="-font FreeMono -fontsize 12"
    CHECK font_FM_12 756092686eaa661679b61de67a2a1ca0

    export UUT_ARGS="-font FreeMono -fontsize 15"
    CHECK font_FM_15 751af5105853a535d9a0b22b4f1150cb

    export UUT_ARGS="-font FreeMono -fontsize 18"
    CHECK font_FM_18 c35d09c61902c7201fa8164981546f21

    export UUT_ARGS="-font FreeMono -fontsize 21"
    CHECK font_FM_21 33d52edc4150c99c88d90577a7ddf2af

    export UUT_ARGS="-font FreeMono -fontsize 24"
    CHECK font_FM_24 43d4e5b4449c72db6bf725c2c639458d

    export UUT_ARGS="-font FreeMono -fontsize 27"
    CHECK font_FM_27 03b449c56615837dceccb8739d8f41cf

    export UUT_ARGS="-font FreeMono -fontsize 30"
    CHECK font_FM_30 85ff2a17b9795bbfd4764b366d780c21

    export UUT_ARGS="-font FreeMono -fontsize 37"
    CHECK font_FM_37 8c7a73ca3f0a35e5e568050aecdd004c
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
    CHECK font_AP_15 419004f6d49d30b75a29b5a1fc3d7ecb

    export UUT_ARGS="-fontpath deps/fonts -font AnonymousPro -fontsize 18"
    CHECK font_AP_18 85c0a864c192bd79c23c38c9767864a4

    export UUT_ARGS="-fontpath deps/fonts -font AnonymousPro -fontsize 21"
    CHECK font_AP_21 154d25a3281282e049ef5caf79af939b

    export UUT_ARGS="-fontpath deps/fonts -font AnonymousPro -fontsize 24"
    CHECK font_AP_24 2b96321d83f33d67ea28677f5f7836e0

    export UUT_ARGS="-fontpath deps/fonts -font AnonymousPro -fontsize 27"
    CHECK font_AP_27 a15ad4d0783c2c6c384964ab641c1f64

    export UUT_ARGS="-fontpath deps/fonts -font AnonymousPro -fontsize 30"
    CHECK font_AP_30 1f101ec92df95d2e5f8dfa7961655b74

    export UUT_ARGS="-fontpath deps/fonts -font AnonymousPro -fontsize 37"
    CHECK font_AP_37 75584d04d8c3b69a1350f53532ca19ad
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
