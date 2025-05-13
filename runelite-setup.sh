# Install Java
pkg install openjdk-21

# Download RuneLite.jar
VERSION=$(git ls-remote --tags --refs https://github.com/runelite/launcher.git | sed -n 's|.*refs/tags/\([0-9]\+\(\.[0-9]\+\)*\)$|\1|p' | sort -V | tail -n 1)
wget https://github.com/runelite/launcher/releases/download/$VERSION/RuneLite.jar
# TODO: Create RuneLite.desktop file
