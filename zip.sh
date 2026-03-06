rm allfiles.zip
zip -r allfiles.zip * -x \
 "venv/*" \
 ".gitignore" \
 "zip.sh" \
 "requirements.txt" \
 "README.md" \
 "*.mako" 
