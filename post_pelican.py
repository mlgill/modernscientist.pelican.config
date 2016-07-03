#!/usr/bin/env python

import glob, shutil, os, re
from rewrite_rss import rewrite_rss


# Copy files from source to destination by extension

FILE_LIST = ()
# FILE_LIST = (('./static/css/*','./output/static/css/'),
# 	         ('./static/js/*','./output/static/js/'),)



# First clean the directories and files
for src, dest in FILE_LIST:
	if os.path.isfile(src):
		try:
			os.remove(dest)
		except:
			pass
	else:
		try:
			shutil.rmtree(dest)
		except:
			pass
		os.mkdir(dest)
	# if os.path.isdir(src):
	# 	shutil.rmtree(dest)
	# 	os.mkdir(dest)

for src, dest in FILE_LIST:
	if os.path.isfile(src):
		# file to directory, file to file
		shutil.copy(src,dest)
		print('1 Copying source '+src+' to dest '+dest)
	elif os.path.isdir(src):
		# directory to directory
		for dirpath, dirnames, filenames in os.walk(src):
			if len(dirnames) > 0:
				for dirn in dirnames:
					for fil in filenames:
						if dirn[0] != '.':
							shutil.copy(dirpath+dirn+'/'+fil, dest+'/'+dirn+'/'+fil)
							print('2 Copying source '+dirpath+dirn+'/'+fil+' to dest '+dest+'/'+dirn+'/'+fil)
			else:
				for fil in filenames:
					shutil.copy(dirpath+'/'+fil, dest+'/'+fil)
					print('3 Copying source '+dirpath+'/'+fil+' to dest '+dest+'/'+fil)
	else:
		# regex glob to directory
		dirname, fileregex = os.path.split(src)
		globlist = glob.glob1(dirname,fileregex)
		for fil in globlist:
			if fil[0] != '_':
				shutil.copy(dirname+'/'+fil,dest+fil)
				print('4 Copying source '+dirname+'/'+fil+' to dest '+dest+fil)
				suffix = os.path.splitext(fil)[1]
				if suffix == '.ipynb':
					fil2 = fil.replace('ipynb','py')
					shutil.copy(dirname+'/'+fil2,dest+fil2)



backup = './main_rss.xml.backup'
original = './output/feeds/main_rss.xml'

if os.path.isfile(backup):
	os.remove(backup)

shutil.copy(original,backup)

# if os.path.isfile(backup):
# 	rewrite_rss()
# else:
# 	print 'There was an error rewriting the RSS file.'

if os.path.isfile(backup):
	fil = open(original,'r')
	filstr = fil.read()
	fil.close()

	# Strip images
	# filstrs1 = re.sub(r'''&lt;img\s?\n?\s?src="data:image/png;base64.*?&lt;/img&gt;''','',filstr,flags=re.MULTILINE|re.DOTALL)
	filstrs1 = re.sub(r'''&lt;img\s?\n?\s?src="data:image/png;base64.*?"\s?\n?\s?&gt;''','',filstr,flags=re.MULTILINE|re.DOTALL)

	# Strip javascript animation
	filstrs2 = re.sub(r'''&lt;script language="javascript"&gt;.*?&lt;/script&gt;''','',filstrs1,flags=re.MULTILINE|re.DOTALL)

	fil = open(original,'w')
	fil.write(filstrs2)
	fil.close()
else:
	print('Backup was not made.')


