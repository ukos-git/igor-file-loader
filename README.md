# igor-file-loader
A wrapper class for Igor7 that is loading the contents of a file system folder into a structure

# Igor7
The Project is procedure for Wave Metrics Igor 7. Igor7 is a scientific plotting tool that is designed to easily manage measured data sets. See [their website](http://www.wavemetrics.com/products/igorpro/igorpro.htm) for details on Igor7.

# Installation
You can navigate to the Igor Pro User Files folder from the menu bar: ![Igor Pro User Files Folder](images/installation-igor-procedures-folder.png?raw=true "Show Igor Procedures Folder in Igor7")
All files from the Igor Procedures Folder are loaded by default on program start. So navigate there and copy or link the this Repo to your Igor Procedures Folder. 

# Usage
 ```
Function load()
    FILOload(fileType = ".ibw", packageID = 1)
End

Function read()
	String file
	Variable numFiles, i
	STRUCT FILOexperiment filo

    FILOstructureLoad(filo)

	numFiles = ItemsInList(filo.strFileList)
	for(i = 0; i < numFiles; i += 1)
		file = StringFromList(i, filo.strFileList)
		print filo.strFolder, file
	endfor
End
```
