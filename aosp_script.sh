################################################################
##################### CONFIGURE STUFF HERE #####################
################################################################

##################### USE TMUX #################################

# sudo apt install nano tmux htop neofetch btop

MY_WORKSPACE_DIR="derp"
MY_ROM="https://github.com/DerpFest-AOSP/manifest.git"
MY_ROM_BRANCH="15"
MY_LOCAL_MANIFEST="15-derp"
CUSTOMCLANG="r487747c"
MY_EMAIL="singhsamarjeet2007@gmail.com"
MY_USERNAME="DevInfinix"
DIRKEYS="vendor/derp/signing/keys/"
KEYS_BRANCH="15.0-derp"

LUNCH_CMD=derp_ice-userdebug
MAKE_CMD=derp

export USE_CCACHE=1
export CCACHE_EXEC=/usr/bin/ccache
export CCACHE_COMPRESS=1
MY_CCACHE_SIZE=40G

export BUILD_USERNAME=DevInfinix
export BUILD_HOSTNAME=Garudinix


################################################################
######################### LET IT COOK ##########################
################################################################

sudo apt-get update && sudo apt-get upgrade -y

cd ~

sudo apt install bc bison build-essential ccache curl flex g++-multilib gcc-multilib git gnupg gperf imagemagick lib32ncurses5-dev lib32readline-dev lib32z1-dev liblz4-tool libncurses5-dev libsdl1.2-dev libssl-dev libxml2 libxml2-utils lzop pngcrush rsync schedtool squashfs-tools xsltproc zip zlib1g-dev neofetch htop tmux netcat

bash <(curl -s https://raw.githubusercontent.com/akhilnarang/scripts/master/setup/android_build_env.sh)

ccache -M $MY_CCACHE_SIZE

git lfs install

mkdir -p $MY_WORKSPACE_DIR
cd $MY_WORKSPACE_DIR

git config --global user.email $MY_EMAIL
git config --global user.name $MY_USERNAME

echo "========================================================================"
echo "WORKSPACE SETUP COMPLETED"
echo "========================================================================"


repo init -u $MY_ROM -b $MY_ROM_BRANCH --git-lfs

git clone https://github.com/DevInfinix/android-aosp-local-manifests.git -b $MY_LOCAL_MANIFEST .repo/local_manifests

repo sync -c --force-sync --optimized-fetch --no-tags --no-clone-bundle --prune -j$(nproc --all)

echo "========================================================================"
echo "SYNCING FINISHED"
echo "========================================================================"


################################################################
######################### CUSTOM CLANG #########################
################################################################

rm -rf "prebuilts/clang/host/linux-x86/clang-${CUSTOMCLANG}"
git clone "https://gitlab.com/crdroidandroid/android_prebuilts_clang_host_linux-x86_clang-${CUSTOMCLANG}" --depth=1 -b 14.0 "prebuilts/clang/host/linux-x86/clang-${CUSTOMCLANG}"

echo "========================================================================"
echo "CLONED CUSTOM CLANG"
echo "========================================================================"


################################################################
######################### CLONE KEYS ###########################
################################################################

# Check if the directory exists
if [ -d "$DIRKEYS" ]; then
    echo "Directory $DIRKEYS exists. Deleting it..."
    rm -rf "$DIRKEYS"
    echo "Directory deleted."
else
    echo "Directory $DIRKEYS does not exist. No need to delete."
fi

echo "Cloning the repository..."
git clone https://github.com/DevInfinix/devinfinix-aosp-roms-keys --depth=1 -b $KEYS_BRANCH "$DIRKEYS"

echo "========================================================================"
echo "CLONED KEYS"
echo "========================================================================"


echo "========================================================================"
echo "BUILDING........."
echo "========================================================================"


################################################################
######################### LUNCH ################################
################################################################

source build/envsetup.sh
lunch $LUNCH_CMD
make installclean
mka $MAKE_CMD | tee build.log