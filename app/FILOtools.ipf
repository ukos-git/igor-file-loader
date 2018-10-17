#pragma TextEncoding = "UTF-8"
#pragma rtGlobals = 3
#pragma IndependentModule = FILO

Function/S popUpChooseDirectory(strPath)
	String strPath

	NewPath/O/Q path, strPath
	PathInfo/S path

	NewPath/M="choose Folder"/O/Q path
	PathInfo path
	strPath = S_path

	GetFileFolderInfo/Q/Z=1 strPath
	if(!V_isFolder)
		strPath = ""
	endif

	return strPath
End

// gets a list of files with the matching extension from a folder
// returns full paths.
Function/S pathActionGetFileList(strFolder, strExtension)
	String strFolder, strExtension

	String listFiles

	NewPath/Q/O path strFolder
	listFiles = IndexedFile(path, -1, strExtension)
	listFiles = SortList(listFiles,";",16)
	listFiles = AddPrefixToListItems(strFolder, listFiles)

	return listFiles
End

// adds a given string to a semicolon separated list
Function/S AddPrefixToListItems(prefix, list)
	String prefix, list

	Variable i, numItems
	String outList = ""
	
	numItems = ItemsInList(list)
	for(i = 0; i < numItems; i += 1)
		outList = AddListItem(prefix + StringFromList(i, list), outList, ";", i)
	endfor

	return outList
End


Function/S UniqueList(list)
	String list

	WAVE/T wvList = ListToTextWave(list, ";")
	FindDuplicates/RT=uniqueWave wvList
	wfprintf list, "%s;", uniqueWave

	return list
End

Function createSVAR(name, [dfr, set, init])
	String name
	DFREF dfr
	String set, init

	if(ParamIsDefault(dfr))
		dfr = GetDataFolderDFR()
	endif

	SVAR/Z/SDFR=dfr var = $name
	if(!SVAR_EXISTS(var))
		if(ParamIsDefault(init))
			String/G dfr:$name = ""
		else
			String/G dfr:$name = init
		endif
	endif

	if(!ParamIsDefault(set))
		SVAR/SDFR=dfr var = $name
		var = set
	endif
End

Function/S loadSVAR(name, [dfr])
	String name
	DFREF dfr
   
	if(ParamIsDefault(dfr))
		dfr = GetDataFolderDFR()
	endif

	SVAR/Z/SDFR=dfr var = $name

	return var
End

Function saveSVAR(name, set, [dfr])
	String name, set
	DFREF dfr
   
	if(ParamIsDefault(dfr))
		dfr = GetDataFolderDFR()
	endif

	SVAR/Z/SDFR=dfr var = $name
	if(!SVAR_EXISTS(var))
		return 0
	endif

	var = set

	return 1
End

Function loadNVAR(name, [dfr])
	String name
	DFREF dfr
   
	if(ParamIsDefault(dfr))
		dfr = GetDataFolderDFR()
	endif

	NVAR/Z/SDFR=dfr var = $name

	return var
End

Function saveNVAR(name, set, [dfr])
	String name
	Variable set
	DFREF dfr
   
	if(ParamIsDefault(dfr))
		dfr = GetDataFolderDFR()
	endif

	NVAR/Z/SDFR=dfr var = $name
	if(!NVAR_EXISTS(var))
		return 0
	endif

	var = set

	return 1
End

Function createNVAR(name, [dfr, set])
	String name
	DFREF dfr
	Variable set

	if(ParamIsDefault(dfr))
		dfr = GetDataFolderDFR()
	endif

	NVAR/Z/SDFR=dfr var = $name
	if(!NVAR_EXISTS(var))
		Variable/G dfr:$name
	endif

	if(!ParamIsDefault(set))
		NVAR/SDFR=dfr var = $name
		var = set
	endif
End
