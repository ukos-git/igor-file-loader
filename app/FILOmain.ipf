#pragma TextEncoding = "UTF-8"
#pragma rtGlobals = 3

// require these files
// #include "FILOstructure"
// #include "FILOprefs"
// #include "FILOtools"

strConstant cFILOpackage    = "FILO"
Constant    cFILOversion = 0001
StrConstant cFILOpath   = "X:Documents:RAW:"

Function FILOload([fileType, packageID])
    String fileType
    Variable packageID

	String fullPath, files

	STRUCT FILOpackage package
	STRUCT FILOexperiment filo

    if(ParamIsDefault(packageID))
        packageID = 0
    endif
    if(ParamIsDefault(fileType))
        fileType = ".ibw"
    endif

	LoadPackagePrefs(package, id = packageID)
	FILOstructureLoad(filo)

	fullPath = FILOpopUpChooseDirectory(package.path)
	files = PathActionGetFileList(fullPath, fileType)
	
	filo.strFolder   = fullPath
	filo.strFileList = files
    filo.strFileExtension = fileType

	package.path = filo.strFolder	
	SavePackagePrefs(package, id = packageID)
	FILOstructureSave(filo)
End

static Function/S PathActionGetFileList(strFolder, strExtension)
	String strFolder, strExtension

	String listFiles

	NewPath/Q/O path strFolder
	listFiles = IndexedFile(path, -1, strExtension)
	listFiles = SortList(listFiles,";",16)

	return listFiles
End