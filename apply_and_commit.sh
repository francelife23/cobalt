#!/bin/bash

# Error Handling Patches - Auto Apply & Commit Script
# This script applies the error handling patches and commits them to the repository

set -e  # Exit on any error

echo "=========================================="
echo "Error Handling Patches - Apply & Commit"
echo "=========================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Step 1: Verify we're in the right directory
echo -e "${YELLOW}[1/6] Checking repository...${NC}"
if [ ! -d ".git" ]; then
    echo -e "${RED}ERROR: Not in a git repository!${NC}"
    echo "Please run this script from the repository root directory."
    exit 1
fi
echo -e "${GREEN}✓ Git repository found${NC}"
echo ""

# Step 2: Check for patch files
echo -e "${YELLOW}[2/6] Verifying patch files...${NC}"
if [ ! -f "error_handling.patch" ]; then
    echo -e "${RED}ERROR: error_handling.patch not found!${NC}"
    exit 1
fi
if [ ! -f "error_handling_panel.patch" ]; then
    echo -e "${RED}ERROR: error_handling_panel.patch not found!${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Both patch files found${NC}"
echo ""

# Step 3: Apply patches
echo -e "${YELLOW}[3/6] Applying error_handling.patch...${NC}"
if patch -p0 < error_handling.patch; then
    echo -e "${GREEN}✓ error_handling.patch applied successfully${NC}"
else
    echo -e "${RED}ERROR: Failed to apply error_handling.patch${NC}"
    exit 1
fi
echo ""

echo -e "${YELLOW}[4/6] Applying error_handling_panel.patch...${NC}"
if patch -p0 < error_handling_panel.patch; then
    echo -e "${GREEN}✓ error_handling_panel.patch applied successfully${NC}"
else
    echo -e "${RED}ERROR: Failed to apply error_handling_panel.patch${NC}"
    exit 1
fi
echo ""

# Step 4: Show what changed
echo -e "${YELLOW}[5/6] Staging changes...${NC}"
git add .
echo -e "${GREEN}✓ Changes staged${NC}"
echo ""

# Step 5: Commit changes
echo -e "${YELLOW}[6/6] Committing changes...${NC}"
git commit -m "Add comprehensive error handling to controller and panel

## Summary
Added robust error handling across critical system functions with try-catch blocks,
input validation, null pointer checks, and detailed error logging.

## Controller Changes (mvhr/software/controller/src/main.cpp)
- Sensor operations: null pointer validation, bounds checking, NaN detection
- RTC operations: timestamp validation, date range checking (2020-2100), verification
- Storage operations: key validation, length checks, exception handling
- I2C communications: address validation, bus enable check, transmission error handling
- Fan control: PWM bounds checking, speed clamping with logging
- Bypass damper: timer validation, status checking
- Schedule evaluation: time value validation, null pointer safety

## Panel Changes (mvhr/software/panel/src/main.cpp)
- Storage initialization: verification tests, exception handling
- All storage operations: key validation, empty string checks, write verification
- Web parameter parsing: input validation, timezone range checking (-12 to +14)
- Hour/minute validation: 0-23 for hours, 0-59 for minutes
- I2C communications: interface enable check, address validation

## Statistics
- Try-catch blocks: 65+
- Null pointer checks: 40+
- Input validations: 50+
- Range/bounds checks: 60+
- Error log messages: 90+

## Files Modified
- mvhr/software/controller/src/main.cpp (20.7 KB patch)
- mvhr/software/panel/src/main.cpp (18.8 KB patch)"

echo -e "${GREEN}✓ Changes committed${NC}"
echo ""

# Step 6: Show summary
echo -e "${GREEN}=========================================="
echo "SUCCESS! Changes Applied"
echo "==========================================${NC}"
echo ""
echo "Next steps:"
echo "  1. Review the changes: git log --oneline -1"
echo "  2. Push to repository: git push origin main"
echo ""
echo "To push automatically, run:"
echo "  git push origin main"
echo ""
