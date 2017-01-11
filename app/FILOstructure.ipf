#pragma TextEncoding = "UTF-8"
#pragma rtGlobals = 3

static strConstant cFILOstructure    = "structure" // path for global var in filo Package dfr

Structure FILOexperiment
	String strFolder, strFileList, strFileExtension
	Variable numVersion

	DFREF dfrPackage
	DFREF dfrStructure
EndStructure

static Function/S StructureDF()
    return "root:Packages:" + cFILOpackage + ":" + cFILOstructure
End

static Function StructureIsInit()
    String strDataFolder = StructureDF()

	if (!DataFolderExists(strDataFolder))
        return 0
    endif

    return 1
End

static Function StructureInitDF(filo)
	Struct FILOexperiment &filo
	DFREF dfrSave = GetDataFolderDFR()
	
	SetDataFolder root:
	NewDataFolder/O/S Packages
	NewDataFolder/O/S $cFILOpackage
	NewDataFolder/O/S $cFILOstructure
	
	SetDataFolder dfrSave	
End

static Function StructureUpdate(filo)
	Struct FILOexperiment &filo

    StructureInitGlobalVariables()
End

static Function StructureInitGlobalVariables()
	DFREF dfrStructure = $StructureDF()

    FILOcreateSVAR("strFileList", dfr = dfrStructure)
    FILOcreateSVAR("strFileExtension", dfr = dfrStructure)
    FILOcreateSVAR("strFolder",        dfr = dfrStructure, init = cFILOpath)
    FILOcreateNVAR("numVersion", dfr = dfrStructure, set = cFILOversion)
End 

Function FILOstructureLoad(filo)
	Struct FILOexperiment &filo
	Variable SetDefault = 0
	
	if(!StructureIsInit())
        StructureInitDF(filo)
        StructureInitGlobalVariables()
    endif

	DFREF filo.dfrStructure = $StructureDF()
    if (DataFolderRefStatus(filo.dfrStructure) == 0)
        print "FILOstructureLoad: Unexpected Behaviour." // ASSERT
    endif

    NVAR/SDFR=filo.dfrStructure numVersion
    if (numVersion < cFILOversion)
        print "FILOstructureLoad: Version Change detected."
        printf "current Version:\t%04d\r", numVersion
        StructureUpdate(filo)
        printf "new Version:\t%04d\r", numVersion
    endif
    filo.numVersion = numVersion
    
    filo.strFolder        = FILOloadSVAR("strFolder",        dfr = filo.dfrStructure)
    filo.strFileList      = FILOloadSVAR("strFileList",      dfr = filo.dfrStructure)
    filo.strFileExtension = FILOloadSVAR("strFileExtension", dfr = filo.dfrStructure)
End

Function FILOstructureSave(filo)
	Struct FILOexperiment &filo
	
	DFREF dfrStructure = $StructureDF()

    FILOsaveSVAR("strFolder",        filo.strFolder,        dfr = dfrStructure)	
    FILOsaveSVAR("strFileList",      filo.strFileList,      dfr = dfrStructure)	
    FILOsaveSVAR("strFileExtension", filo.strFileExtension, dfr = dfrStructure)	
	
    FILOsaveNVAR("numVersion", filo.numVersion, dfr = dfrStructure)	
End
