import os
import subprocess
import sys

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
LIB_DIR = os.path.join(SCRIPT_DIR, 'lib')

def lambda_handler(event, context):
    print ("Python version: {}".format(sys.version))
    imgfilepath = os.path.join(SCRIPT_DIR, 'test.png')
    jsonfilepath = '/tmp/result'

    command = 'LD_LIBRARY_PATH={} TESSDATA_PREFIX={}/tessdata/ {}/tesseract {} {}'.format(
        LIB_DIR,
        SCRIPT_DIR,
        SCRIPT_DIR,
        imgfilepath,
        jsonfilepath
    )

    try:
        print ('Running tesseract command:\n{}'.format(command))
        output = subprocess.check_output(command, shell=True)
        print(output)
    except subprocess.CalledProcessError as e:
        print(e.output)

    try:
        with open(jsonfilepath + '.txt', 'r') as f:
            print (f.read())
    except:
        raise

    print ('done!')
    return 'yay'

