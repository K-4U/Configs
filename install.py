#!/usr/bin/env python
import sys, os, glob

options = {}
#do_global will only copy the files that have a global dir
#no_global will only copy the files that have no global dir
#if they are both False, the script will copy both type of files to the home dir
options['is_server'] = False
options['do_remove'] = False
options['do_global'] = False
options['no_global'] = False
options['noglobaldir'] = os.getenv("HOME")


def getRealDir(*dir):
    """Get the real directory path"""
    return os.path.join(sys.path[0], *dir)

if len(sys.argv) > 1:
    args = 1
    if 'global' in sys.argv:
        options['do_global'] = True
        args+=1
    if 'noglobal' in sys.argv:
        options['no_global'] = True
        args+=1
    if 'remove' in sys.argv:
        options['do_remove'] = True
        args+=1
    if 'server' in sys.argv:
        options['is_server'] = True
        args+=1

    if len(sys.argv) > args and options['do_global'] == False:
        #Username to install
        options['noglobaldir'] = "/home/%s"%(sys.argv[args])

classes = {}
for folder in glob.glob(os.path.join(getRealDir(""), '*') ):
    if os.path.isdir(folder):
        folderName = os.path.basename(folder)
        print(folderName)
        if os.path.isfile(os.path.join(getRealDir(folderName,"__init__.py"))):
            classes[folderName] = __import__(folderName,globals(),None,['modules']).cc()




if __name__ ==  '__main__':
    print(options)
    print(classes)

    for installerName,installer in classes.items():
        print("Installing ",installerName)
        installer.install()
