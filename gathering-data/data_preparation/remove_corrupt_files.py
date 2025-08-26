import os
import cv2

def safe_delete_file(file_path):
    try:
        os.remove(file_path)
        return True
    except Exception as e:
        print(f'Error deleting {file_path}: {str(e)}')
        return False
    
def check_images( s_dir, ext_list):
    bad_images=[]
    bad_ext=[]
    deleted_files=[]
    s_list= os.listdir(s_dir)
    for klass in s_list:
        klass_path=os.path.join (s_dir, klass)
        print ('processing class directory ', klass)
        if os.path.isdir(klass_path):
            file_list=os.listdir(klass_path)
            for f in file_list:               
                f_path=os.path.join (klass_path,f)
                index=f.rfind('.')
                ext=f[index+1:].lower()
                if ext not in ext_list:
                    print('file ', f_path, ' has an invalid extension ', ext)
                    bad_ext.append(f_path)
                if os.path.isfile(f_path):
                    try:
                        img=cv2.imread(f_path)
                        shape=img.shape
                    except:
                        print('file ', f_path, ' is not a valid image file')
                        bad_images.append(f_path)
                        if safe_delete_file(f_path):
                            deleted_files.append(f_path)
                else:
                    print('*** fatal error, there is a sub directory ', f, ' in class directory ', klass)
        else:
            print ('*** WARNING*** there are  files in ', s_dir, ' it should only contain sub directories')
    return bad_images, bad_ext, deleted_files

source_dirs =[ r'/Users/remo/Library/CloudStorage/GoogleDrive-remodivito57@gmail.com/My Drive/train']
good_exts=['jpg', 'png', 'jpeg', 'gif', 'bmp' ] # list of acceptable extensions
for source_dir in source_dirs:
    bad_file_list, bad_ext_list, deleted_files =check_images(source_dir, good_exts)
    if len(bad_file_list) !=0:
        print('improper image files are listed below')
        for i in range (len(bad_file_list)):
            print (bad_file_list[i])
    else:
        print(' no improper image files were found')
    if deleted_files:
        print('\nDeleted the following corrupt files:')
        for file in deleted_files:
            print(f'- {file}')
    else:
        print('No files were deleted')
if len(bad_file_list) !=0:
    print('improper image files are listed below')
    for i in range (len(bad_file_list)):
        print (bad_file_list[i])
else:
    print(' no improper image files were found')