#pragma TextEncoding = "UTF-8"
#pragma rtGlobals = 3
#pragma IndependentModule = FILO

// require these files
// #include "FILOstructure"
// #include "FILOprefs"
// #include "FILOtools"

strConstant cpackage    = "FILO"
Constant    cversion = 0001
StrConstant cpath   = "X:Documents:RAW:"

Function load([fileType, packageID])
    String fileType
    Variable packageID

	String fullPath, files

	STRUCT package package
	STRUCT experiment filo

    if(ParamIsDefault(packageID))
        packageID = 0
    endif
    if(ParamIsDefault(fileType))
        fileType = ".ibw"
    endif

	LoadPackagePrefs(package, id = packageID)
	structureLoad(filo)

	fullPath = popUpChooseDirectory(package.path)
	files = pathActionGetFileList(fullPath, fileType)
	
	filo.strFolder   = fullPath
	filo.strFileList = files
    filo.strFileExtension = fileType

	package.path = filo.strFolder	
	SavePackagePrefs(package, id = packageID)
	structureSave(filo)
End
