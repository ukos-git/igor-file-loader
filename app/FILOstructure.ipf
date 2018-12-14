#pragma TextEncoding = "UTF-8"
#pragma rtGlobals = 3
#pragma IndependentModule = FILO

static strConstant cstructure	= "structure" // path forglobal var in filo Package dfr

Structure experiment
	String strFolder, strFileList, strFileExtension
	Variable numVersion

	DFREF dfrPackage
	DFREF dfrStructure
EndStructure

static Function/S StructureDF()
	string strDataFolder = "root:Packages:" + cpackage + ":" + cstructure
	return strDataFolder
End

static Function StructureIsInit()
	String strDataFolder = StructureDF()

	if(!DataFolderExists(strDataFolder))
		return 0
	endif

	return 1
End

static Function StructureInitDF()
	DFREF dfrSave = GetDataFolderDFR()
	
	SetDataFolder root:
	NewDataFolder/O/S Packages
	NewDataFolder/O/S $cpackage
	NewDataFolder/O/S $cstructure

	createNVAR("numVersion", set = 0)
	
	SetDataFolder dfrSave	
End

static Function StructureUpdate(filo)
	Struct experiment &filo

	string strPath

	if(filo.numVersion == 0001)
		// 0001 --> 0002: changed to full path
		filo.strFileList = AddPrefixToListItems(filo.strFolder, filo.strFileList)
	endif
	if(filo.numVersion < 0003)
		// 0002 --> 0003: replace drive d
		strPath = filo.strFolder
		GetFileFolderInfo/Q/Z=1 strPath
		if(!V_isFolder)
			if(!cmpstr(strPath[0], "D"))
				strPath = "W:data" + strPath[1, inf]
				GetFileFolderInfo/Q/Z=1 strPath
				if(!V_isFolder)
					strPath = filo.strFolder
				endif
			endif
		endif
		filo.strFolder = strPath
	endif
	filo.numVersion = cVersion
	structureSave(filo)
End

static Function StructureInitGlobalVariables(numVersion)
	Variable numVersion
	DFREF dfrStructure = $StructureDF()

	if(numVersion == 0)
		createSVAR("strFileList", dfr = dfrStructure)
		createSVAR("strFileExtension", dfr = dfrStructure)
		createSVAR("strFolder",		dfr = dfrStructure, init = cpath)
	endif
End 

Function structureLoad(filo)
	Struct experiment &filo
	Variable SetDefault = 0
	
	if(!StructureIsInit())
		StructureInitDF()
	endif

	DFREF filo.dfrStructure = $StructureDF()
	if(DataFolderRefStatus(filo.dfrStructure) == 0)
		Abort "FILO#structureLoad: Unexpected Behaviour."
	endif
	NVAR/SDFR=filo.dfrStructure/Z numVersion
	if(!NVAR_Exists(numVersion))
		Abort "FILO#structureLoad: Unexpected Behaviour."
	endif

	StructureInitGlobalVariables(numVersion)

	filo.strFolder		= loadSVAR("strFolder",		dfr = filo.dfrStructure)
	filo.strFileList	  = loadSVAR("strFileList",	  dfr = filo.dfrStructure)
	filo.strFileExtension = loadSVAR("strFileExtension", dfr = filo.dfrStructure)
	filo.numVersion = loadNVAR("numVersion", dfr = filo.dfrStructure)

	if(filo.numVersion < cversion)
		print "FILO#structureLoad: Version Change detected."
		printf "current Version:\t%04d\r", numVersion
		StructureUpdate(filo)
		printf "new Version:\t%04d\r", numVersion
	endif
End

Function structureSave(filo)
	Struct experiment &filo

	saveSVAR("strFolder",		filo.strFolder,		dfr = filo.dfrStructure)	
	saveSVAR("strFileList",	  filo.strFileList,	  dfr = filo.dfrStructure)	
	saveSVAR("strFileExtension", filo.strFileExtension, dfr = filo.dfrStructure)	
	
	saveNVAR("numVersion", filo.numVersion, dfr = filo.dfrStructure)	
End
