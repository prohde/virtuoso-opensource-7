#!/bin/sh
# first script to be called during the initialization
# creates the expected folders; they were deleted when created in Dockerfile
mkdir /opt/virtuoso-opensource/database/dumps
mkdir /opt/virtuoso-opensource/database/toLoad

