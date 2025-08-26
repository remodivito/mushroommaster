import os
import stat
from pathlib import Path

def find_hidden_files(directory):
    hidden_files = []
    for root, dirs, files in os.walk(directory):
        for filename in files:
            filepath = os.path.join(root, filename)
            
            # Check for dot files
            if filename.startswith('.'):
                hidden_files.append(filepath)
                continue
                
            # Check hidden flag on macOS
            try:
                if bool(os.stat(filepath).st_flags & stat.UF_HIDDEN):
                    hidden_files.append(filepath)
                    continue
            except (OSError, AttributeError):
                pass
            
            # Check if file is in known system hidden paths
            path = Path(filepath)
            if any(part.startswith('.') for part in path.parts):
                hidden_files.append(filepath)
                
    return hidden_files

source_directory = '/Users/remo/repos/mushroom_master/gathering-data/MO_MI_images'
source_hidden_files = find_hidden_files(source_directory)
print("Hidden files in source directory:")
for file in source_hidden_files:
    print(file)

