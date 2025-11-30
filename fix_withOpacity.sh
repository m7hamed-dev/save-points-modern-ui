#!/bin/bash

# Script to replace deprecated withOpacity with withValues(alpha: ...)
# Usage: ./fix_withOpacity.sh

echo "Fixing deprecated withOpacity warnings..."

# Find all Dart files and replace .withOpacity(value) with .withValues(alpha: value)
find lib -name "*.dart" -type f | while read -r file; do
    if grep -q "withOpacity" "$file"; then
        echo "Processing: $file"
        
        # Replace .withOpacity(value) with .withValues(alpha: value)
        # This handles decimal values like 0.3, 0.5, 0.7, etc.
        sed -i '' 's/\.withOpacity(\([0-9.]*\))/\.withValues(alpha: \1)/g' "$file"
        
        echo "  ✓ Fixed: $file"
    fi
done

echo ""
echo "Done! All withOpacity calls have been replaced with withValues(alpha: ...)"
echo "Please review the changes and test your application."

