#!/bin/bash

# Check if a tag argument was provided
if [ -z "$1" ]; then
    echo "Error: Please provide a BAML tag to update to"
    echo "Usage: $0 <tag>"
    echo "Example: $0 0.87.2"
    exit 1
fi

TAG=$1

# Ensure we're in the root directory of the project
if [ ! -d "native/baml_elixir/baml" ]; then
    echo "Error: Could not find BAML submodule at native/baml_elixir/baml"
    exit 1
fi

# Update the submodule to the specified tag
echo "Updating BAML submodule to tag: $TAG"
cd native/baml_elixir/baml
git fetch --tags
git checkout "$TAG"
if [ $? -ne 0 ]; then
    echo "Error: Failed to checkout tag $TAG"
    exit 1
fi

# Update the submodule in the main repository
cd ../../..
git add native/baml_elixir/baml

# Update the BAML version in the Elixir module
echo "Updating BAML version in Elixir module to: $TAG"
sed -i '' "s/@baml_version \".*\"/@baml_version \"$TAG\"/" lib/baml_elixir.ex
git add lib/baml_elixir.ex

# Compile the project to ensure everything works and update Cargo.lock
echo "Compiling project..."
mix compile
if [ $? -ne 0 ]; then
    echo "Error: Compilation failed. Please fix any issues before committing."
    exit 1
fi

# Add the updated Cargo.lock
git add native/baml_elixir/Cargo.lock

# Show preview of changes
echo -e "\nPreview of changes to be committed:"
echo "----------------------------------------"
git diff --cached
echo "----------------------------------------"

# Ask for confirmation
read -p "Do you want to commit these changes? (y/N) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Aborting commit. Changes are staged but not committed."
    exit 1
fi

# Commit all changes
git commit -m "Update BAML submodule and version to $TAG"

echo "Successfully updated BAML submodule and version to $TAG"