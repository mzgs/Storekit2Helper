#!/bin/bash

# File path to the pubspec.yaml
FILE_PATH="pubspec.yaml"

# Extract current version
current_version=$(grep 'version: ' $FILE_PATH | sed 's/version: //')

# Break down the version number into major, minor, and patch
IFS='.' read -r -a version_parts <<< "$current_version"

# Increment the patch version
patch_version=$((version_parts[2] + 1))

# Construct the new version number
new_version="${version_parts[0]}.${version_parts[1]}.$patch_version"

# Replace the old version with the new version in the file
sed -i '' "s/version: $current_version/version: $new_version/" $FILE_PATH



flutter pub get

dart pub publish -f

git add .
git commit -m "update to $new_version"
git push

echo "--------------------------------------"
echo "Version updated to $new_version"
echo "--------------------------------------"