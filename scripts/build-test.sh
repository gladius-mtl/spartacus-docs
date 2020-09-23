#!/usr/bin/env bash
# Builds current committed master branch from GitHub to gh-pages, replacing
# everything in gh-pages. Intended to be run locally when you want to publish.
# Run with the version number as a parameter.

# Variables
installed="bundle"
v=1.x

# Get the latest commit SHA in sourcedir branch
last_SHA=( $(git rev-parse --short HEAD) )
# The name of the temporary folder will be the
#   last commit SHA, to prevent possible conflicts
#   with other folder names.
clone_dir="/tmp/clone_$last_SHA/"
echo $last_SHA

# Make sure Jekyll is installed locally
if ! gem list $installed; then
        echo "You do not have the pre-reqs installed. Refer to the README for
requirements."
        exit 0
fi

# Create directory to hold temporary clone
mkdir $clone_dir
cd $clone_dir
git clone git@github.com:gladius-mtl/spartacus-docs.git
cd spartacus-docs
build_dir="/tmp/build_$last_SHA"
echo $build_dir
git checkout stable/$v
bundle install
bundle exec jekyll build --config _config.yml,_config.$v.yml -d $build_dir/spartacus-docs/$v

if [ $? = 0 ]; then
  echo "Jekyll build successful for " $v
else
   echo "Jekyll build failed for " $v
#    exit 1
fi


