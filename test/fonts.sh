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
    CHECK font_LM_12 31fffb64b521d8ad66d6ab9251b62a7f

    export UUT_ARGS="-font LiberationMono -fontsize 15"
    CHECK font_LM_15 c555151b625b6703c2bc53d77cbcd597

    export UUT_ARGS="-font LiberationMono -fontsize 18"
    CHECK font_LM_18 8d6c520db5159cbe48ae99de3805339a

    export UUT_ARGS="-font LiberationMono -fontsize 21"
    CHECK font_LM_21 164ffa71970bb5f6e1199b1a3acbd36c

    export UUT_ARGS="-font LiberationMono -fontsize 24"
    CHECK font_LM_24 1b0acf7752a4e5d6cb23ddfb31e71251

    export UUT_ARGS="-font LiberationMono -fontsize 27"
    CHECK font_LM_27 7215c6b32ded01af7f8af17963a2d8b9

    export UUT_ARGS="-font LiberationMono -fontsize 30"
    CHECK font_LM_30 768f44b7d5083afd4cfb21e0e723be24

    export UUT_ARGS="-font LiberationMono -fontsize 37"
    CHECK font_LM_37 d34ca5f0381c1d453b31b89e550ee7bd
}

function FONTS_DEJA_VU_SANS_MONO {

    # Deja Vu Sans Mono
    # Package: fonts-dejavu-core

    export UUT_ARGS="-font DejaVuSansMono -fontsize 12"
    CHECK font_DV_12 a919b6ab8113259acdb3d3fe54148f63

    export UUT_ARGS="-font DejaVuSansMono -fontsize 15"
    CHECK font_DV_15 c7636d3f0e1a88ffb61894f615ea63b1

    export UUT_ARGS="-font DejaVuSansMono -fontsize 18"
    CHECK font_DV_18 ea7b26c958113d5735590debbfc8511e

    export UUT_ARGS="-font DejaVuSansMono -fontsize 21"
    CHECK font_DV_21 a007cb618591cf6aac5dd51ec44f7b5c

    export UUT_ARGS="-font DejaVuSansMono -fontsize 24"
    CHECK font_DV_24 44530fbe8571346a1720cc8b90573343

    export UUT_ARGS="-font DejaVuSansMono -fontsize 27"
    CHECK font_DV_27 236eb889c98b1f6052beb8bb355dd6d1

    export UUT_ARGS="-font DejaVuSansMono -fontsize 30"
    CHECK font_DV_30 60a6f8a5461c0bb1ab935bd4028d74f4

    export UUT_ARGS="-font DejaVuSansMono -fontsize 37"
    CHECK font_DV_37 7c2c03af7b91aa62be090eff131dd621
}

function FONTS_FIRA_CODE {

    # Fira Code
    # URL: https://github.com/tonsky/FiraCode/releases/download/6.2/Fira_Code_v6.2.zip

    export UUT_ARGS="-fontpath deps/fonts -font FiraCode -fontsize 12"
    CHECK font_FC_12 640d0800ea2930c07ded571a44b82827

    export UUT_ARGS="-fontpath deps/fonts -font FiraCode -fontsize 15"
    CHECK font_FC_15 138ab56e5a5aaccb752f951136102928

    export UUT_ARGS="-fontpath deps/fonts -font FiraCode -fontsize 18"
    CHECK font_FC_18 8fe66345a5496fcdc5ad2115217e23be

    export UUT_ARGS="-fontpath deps/fonts -font FiraCode -fontsize 21"
    CHECK font_FC_21 9d3d70646a8cd3127741eea7442be6a7

    export UUT_ARGS="-fontpath deps/fonts -font FiraCode -fontsize 24"
    CHECK font_FC_24 7b51ac61413f8f0aa77249b4d9ba135e

    export UUT_ARGS="-fontpath deps/fonts -font FiraCode -fontsize 27"
    CHECK font_FC_27 7082254cbb870e36dfce0133b069445e

    export UUT_ARGS="-fontpath deps/fonts -font FiraCode -fontsize 30"
    CHECK font_FC_30 2b49a0552ce08634eba19f9c4e8dacc1

    export UUT_ARGS="-fontpath deps/fonts -font FiraCode -fontsize 37"
    CHECK font_FC_37 4978a74c68136b076bbc0672bcef4638
}

function FONTS_JETBRAINS_MONO {

    # JetBrains Mono
    # URL: https://github.com/JetBrains/JetBrainsMono/releases/download/v2.304/JetBrainsMono-2.304.zip

    export UUT_ARGS="-fontpath deps/fonts -font JetBrainsMono -fontsize 12"
    CHECK font_JB_12 599cd7ae111abfc522ad4053d6e9652f

    export UUT_ARGS="-fontpath deps/fonts -font JetBrainsMono -fontsize 15"
    CHECK font_JB_15 cef22687d9d8e27402cdd3b6c33c7390

    export UUT_ARGS="-fontpath deps/fonts -font JetBrainsMono -fontsize 18"
    CHECK font_JB_18 29ecd8a1e8cd5f178e7cda31c267da2f

    export UUT_ARGS="-fontpath deps/fonts -font JetBrainsMono -fontsize 21"
    CHECK font_JB_21 4445db4216dd447b795bc3799e5073ba

    export UUT_ARGS="-fontpath deps/fonts -font JetBrainsMono -fontsize 24"
    CHECK font_JB_24 a6ba2c94fdd0f12bdfa0c029b1da7142

    export UUT_ARGS="-fontpath deps/fonts -font JetBrainsMono -fontsize 27"
    CHECK font_JB_27 c40a94f43c069afb003dda64885361fa

    export UUT_ARGS="-fontpath deps/fonts -font JetBrainsMono -fontsize 30"
    CHECK font_JB_30 835181a226494e04604c4959326e61b3

    export UUT_ARGS="-fontpath deps/fonts -font JetBrainsMono -fontsize 37"
    CHECK font_JB_37 75e688ce08af192e50fe5c68a9711a42
}

function FONTS_SOURCE_CODE_PRO {

    # Source Code Pro
    # URL: https://github.com/adobe-fonts/source-code-pro/releases/download/2.042R-u%2F1.062R-i%2F1.026R-vf/TTF-source-code-pro-2.042R-u_1.062R-i.zip

    export UUT_ARGS="-fontpath deps/fonts -font SourceCodePro -fontsize 12"
    CHECK font_SC_12 97716b9da937e72ff50dd9075f80d6b4

    export UUT_ARGS="-fontpath deps/fonts -font SourceCodePro -fontsize 15"
    CHECK font_SC_15 4e1ec88a14d068f7af7943cf749b6933

    export UUT_ARGS="-fontpath deps/fonts -font SourceCodePro -fontsize 18"
    CHECK font_SC_18 70bd52feacbf8ab799dee6e9e72b0739

    export UUT_ARGS="-fontpath deps/fonts -font SourceCodePro -fontsize 21"
    CHECK font_SC_21 c3b857207c246e7795da9f9355f901d8

    export UUT_ARGS="-fontpath deps/fonts -font SourceCodePro -fontsize 24"
    CHECK font_SC_24 b7ec0d21910a2f839a546415c09abe00

    export UUT_ARGS="-fontpath deps/fonts -font SourceCodePro -fontsize 27"
    CHECK font_SC_27 21014b47db3b4c5d8451940b7ab2504f

    export UUT_ARGS="-fontpath deps/fonts -font SourceCodePro -fontsize 30"
    CHECK font_SC_30 5f6111fe8d838e4ec3c693731840d337

    export UUT_ARGS="-fontpath deps/fonts -font SourceCodePro -fontsize 37"
    CHECK font_SC_37 ab12b513cbc5c60c3caa63d15cbc78ba
}

function FONTS_HASKLIG {

    # Hasklig
    # URL: https://github.com/i-tu/Hasklig/releases/download/v1.2/Hasklig-1.2.zip

    export UUT_ARGS="-fontpath deps/fonts -font Hasklig -fontsize 12"
    CHECK font_HA_12 b998fd966069c6b291745b5b42f98f58

    export UUT_ARGS="-fontpath deps/fonts -font Hasklig -fontsize 15"
    CHECK font_HA_15 d8488c70f61fbc3810264ebdb4546613

    export UUT_ARGS="-fontpath deps/fonts -font Hasklig -fontsize 18"
    CHECK font_HA_18 89acad3fabaeeca63bd49fb9f518cb04

    export UUT_ARGS="-fontpath deps/fonts -font Hasklig -fontsize 21"
    CHECK font_HA_21 1796eaef7a979504bd4f4c041ad9fe04

    export UUT_ARGS="-fontpath deps/fonts -font Hasklig -fontsize 24"
    CHECK font_HA_24 7cc187ac9b15c158701f0ea5958d4c11

    export UUT_ARGS="-fontpath deps/fonts -font Hasklig -fontsize 27"
    CHECK font_HA_27 a227ed69abffa03bb27bc18bc2506bbb

    export UUT_ARGS="-fontpath deps/fonts -font Hasklig -fontsize 30"
    CHECK font_HA_30 d79ecb1611bf52f831c943fbccc4d575

    export UUT_ARGS="-fontpath deps/fonts -font Hasklig -fontsize 37"
    CHECK font_HA_37 e734c222f7ac5f175b5634c688ae03d1
}

function FONTS_FREEMONO {

    # Free Mono
    # Package: fonts-freemono-ttf

    export UUT_ARGS="-font FreeMono -fontsize 12"
    CHECK font_FM_12 29b0fcce8b6a147f0efe8c50056ba683

    export UUT_ARGS="-font FreeMono -fontsize 15"
    CHECK font_FM_15 e26b35105612da5280c38638b4bdc45a

    export UUT_ARGS="-font FreeMono -fontsize 18"
    CHECK font_FM_18 0d6dfac310dcc5e743460780c2d0d025

    export UUT_ARGS="-font FreeMono -fontsize 21"
    CHECK font_FM_21 ce3ac22c94a7918317db29568f59b5b1

    export UUT_ARGS="-font FreeMono -fontsize 24"
    CHECK font_FM_24 ad595ccd04f5f01173d05192669256be

    export UUT_ARGS="-font FreeMono -fontsize 27"
    CHECK font_FM_27 83a1216e00223413905cf5cc0a627998

    export UUT_ARGS="-font FreeMono -fontsize 30"
    CHECK font_FM_30 7db2adabd2071275c9d34a5ad27323d0

    export UUT_ARGS="-font FreeMono -fontsize 37"
    CHECK font_FM_37 0d503a83d1c5e0c3b6adc73939d3b200
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
    CHECK font_AP_15 220e3de704236b9cf93e36c2081f5cc0

    export UUT_ARGS="-fontpath deps/fonts -font AnonymousPro -fontsize 18"
    CHECK font_AP_18 f70d0397978c83c7215fcea1bbe1c0ed

    export UUT_ARGS="-fontpath deps/fonts -font AnonymousPro -fontsize 21"
    CHECK font_AP_21 0ad427502619d85f397a8ac518261de1

    export UUT_ARGS="-fontpath deps/fonts -font AnonymousPro -fontsize 24"
    CHECK font_AP_24 c186c082b5c1bb4088322a8a83029a34

    export UUT_ARGS="-fontpath deps/fonts -font AnonymousPro -fontsize 27"
    CHECK font_AP_27 a1ef62ef60cae2d40d683f1125c6659b

    export UUT_ARGS="-fontpath deps/fonts -font AnonymousPro -fontsize 30"
    CHECK font_AP_30 c2fe545e429b374c2ba6876645a9719b

    export UUT_ARGS="-fontpath deps/fonts -font AnonymousPro -fontsize 37"
    CHECK font_AP_37 d0172867057b4394c839f9e7b6a9817d
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
