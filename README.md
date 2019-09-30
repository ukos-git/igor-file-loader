![compile status](https://gitlab.com/ukos-git/igor-file-loader/badges/master/pipeline.svg)

# igor-file-loader

A independent module for [WaveMetrics](http://www.wavemetrics.com/) Igor Pro 8 that
can load the contents of a file system folder into a structure. Although
versions < 8 may be working, the CI job only tests compatibility to Igor Pro 8.

# Installation

Navigate to the Igor Pro User Files folder from the menu bar:

![Igor Pro User Files Folder](images/installation-igor-procedures-folder.png?raw=true "Show Igor Procedures Folder in Igor7")

All files from the Igor Procedures Folder are loaded by default on program
start.

# usage in Functions

 ```igor
Function load()
    FILO#load(fileType = ".ibw", packageID = 1)
End

Function read()
	String file
	Variable numFiles, i
	STRUCT FILO#experiment filos

    FILO#structureLoad(filos)

	numFiles = ItemsInList(filos.strFileList)
	for(i = 0; i < numFiles; i += 1)
		file = StringFromList(i, filos.strFileList)
		print filos.strFolder, file
	endfor
End
```

# usage from Command Line

The package stores its values in variables. The package can therefore also be
called directly from the cli. An example is shown in the following figure.  Try
testing it with the following code:

 ```igor
FILO#load()
print root:Packages:FILO:structure:strFileList
```

![Igor Pro User Files Folder](images/igor-command-line.png?raw=true "call from igor cli")
