#!/bin/bash

echo "Enter the file name: "
read filename

# Directory containing the files to compare
dic="/home/krithick/Documents/miniproject"

# Flag to check if at least one file matched
matched=false

# Loop through each file in the directory
for file in "$dic"/*; do
    if [ -f "$file" ]; then
        # Compare the current file with the specified filename
        cmp -s "$filename" "$file"
        cmp_result=$?
        
        if [ $cmp_result -eq 0 ]; then
            echo "Files $filename and $(basename "$file") are identical."
            
            # Assuming you want to add the specified file to Git if it matches
            git add "$filename"
            git status
            
            echo ""
            sleep 1
            
            echo "Enter the commit message:"
            read message
            
            # Commit changes to Git
            git commit -m "$message"
            git push origin main
            
            echo ""
            echo "Your changes have been successfully uploaded."
            
            # Set matched flag to true since at least one file matched
            matched=true
            
            # Exit the loop after the first match (if that's your requirement)
            break
        fi
    fi
done

# Check if no files matched the specified filename
if [ "$matched" = false ]; then
    echo "No files in $dic matched $filename."
fi

