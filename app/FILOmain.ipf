#pragma TextEncoding = "UTF-8"
#pragma rtGlobals = 3
#pragma IndependentModule = FILO

// require these files
// #include "FILOstructure"
// #include "FILOprefs"
// #include "FILOtools"

strConstant cpackage	= "FILO"
Constant	cversion = 0003
StrConstant cpath	= "C:"

Function load([fileType, packageID, appendToList])
	String fileType
	Variable packageID, appendToList

	String strPath, files

	STRUCT package package
	STRUCT experiment filo

	if(ParamIsDefault(packageID))
		packageID = 0
	endif
	if(ParamIsDefault(fileType))
		fileType = ".ibw"
	endif
	if(ParamIsDefault(appendToList))
		appendToList = 0
	endif

	LoadPackagePrefs(package, id = packageID)
	StructureLoad(filo)

	// get path
	strPath = filo.strFolder
	GetFileFolderInfo/Q/Z=1 strPath
	if(!V_isFolder)
		strPath = package.path
	endif
	strPath = popUpChooseDirectory(strPath)
	GetFileFolderInfo/Q/Z=1 strPath
	if(!V_isFolder)
		Abort "Path does not exist"
	endif
	filo.strFolder = strPath
	package.path = strPath
	SavePackagePrefs(package, id = packageID)

	// get files
	files = pathActionGetFileList(strPath, fileType)
	if(appendToList)
		filo.strFileList += files
		filo.strFileList = UniqueList(filo.strFileList)
	else
		filo.strFileList = files
	endif
	filo.strFileExtension = fileType

	structureSave(filo)
End
