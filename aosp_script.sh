################################################################
##################### CONFIGURE STUFF HERE #####################
################################################################

##################### USE TMUX #################################

# sudo apt install nano tmux htop neofetch btop

MY_ROOT_DIR="~"
MY_WORKSPACE_DIR="pixelage"
MY_ROM="https://github.com/ProjectPixelage/android_manifest.git"
MY_ROM_BRANCH="15"
MY_LOCAL_MANIFEST="15-pixelage"
CUSTOMCLANG="r522817"
MY_EMAIL="debarpanhalder8@gmail.com"
MY_USERNAME="Debarpan102"
#DIRKEYS="vendor/lineage-priv/keys"
#KEYS_BRANCH=" "

#BRUNCH_CMD=brunch ice userdebug
#MAKE_CMD=mka bacon

export USE_CCACHE=1
export CCACHE_EXEC=/usr/bin/ccache
export CCACHE_COMPRESS=1
MY_CCACHE_SIZE=50G

export BUILD_USERNAME=Debarpan
export BUILD_HOSTNAME=Linux


################################################################
######################### LET IT COOK ##########################
################################################################

sudo apt-get update && sudo apt-get upgrade -y
sudo apt update && sudo apt install libc6-dev
sudo apt install openssl libssl-dev && sudo apt install libssl-dev
sudo apt-get install -y libfl-dev

cd $MY_ROOT_DIR

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

git clone https://github.com/Debarpan102/android-aosp-local-manifests.git -b $MY_LOCAL_MANIFEST .repo/local_manifests

repo sync -c -j$(nproc --all)

echo "========================================================================"
echo "SYNCING FINISHED"
echo "========================================================================"


################################################################
######################### CUSTOM CLANG #########################
################################################################

rm -rf "prebuilts/clang/host/linux-x86/clang-${CUSTOMCLANG}"
git clone "https://gitlab.com/kei-space/clang/r522817.git" --depth=1 -b master "prebuilts/clang/host/linux-x86/clang-${CUSTOMCLANG}"

echo "========================================================================"
echo "CLONED CUSTOM CLANG"
echo "========================================================================"


################################################################
######################### CLONE KEYS ###########################
################################################################

# Check if the directory exists
#if [ -d "$DIRKEYS" ]; then
# echo "Directory $DIRKEYS exists. Deleting it..."
#  rm -rf "$DIRKEYS"
#  echo "Directory deleted."
#else
 #   echo "Directory $DIRKEYS does not exist. No need to delete."
#fi

#echo "Cloning the repository..."
#git clone https://github.com/DevInfinix/devinfinix-aosp-roms-keys --depth=1 -b $KEYS_BRANCH "$DIRKEYS" **/

echo "========================================================================"
echo "NOT CLONED KEYS"
echo "========================================================================"


echo "========================================================================"
echo "BUILDING........."
echo "========================================================================"


################################################################
######################### LUNCH ################################
################################################################

export PIXELAGE_BUILD="ice"
source build/envsetup.sh
lunch pixelage_ice-ap4a-userdebug
mka bacon -j96
