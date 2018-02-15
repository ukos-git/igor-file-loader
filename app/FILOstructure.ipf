#pragma TextEncoding = "UTF-8"
#pragma rtGlobals = 3
#pragma IndependentModule = FILO

static strConstant cstructure    = "structure" // path forglobal var in filo Package dfr

Structure experiment
    String strFolder, strFileList, strFileExtension
    Variable numVersion

    DFREF dfrPackage
    DFREF dfrStructure
EndStructure

static Function/S StructureDF()
    return "root:Packages:" + cpackage + ":" + cstructure
End

static Function StructureIsInit()
    String strDataFolder = StructureDF()

    if(!DataFolderExists(strDataFolder))
        return 0
    endif

    return 1
End

static Function StructureInitDF(filo)
    Struct experiment &filo
    DFREF dfrSave = GetDataFolderDFR()
    
    SetDataFolder root:
    NewDataFolder/O/S Packages
    NewDataFolder/O/S $cpackage
    NewDataFolder/O/S $cstructure
    
    SetDataFolder dfrSave    
End

static Function StructureUpdate(filo)
    Struct experiment &filo

    StructureInitGlobalVariables()
End

static Function StructureInitGlobalVariables()
    DFREF dfrStructure = $StructureDF()

    createSVAR("strFileList", dfr = dfrStructure)
    createSVAR("strFileExtension", dfr = dfrStructure)
    createSVAR("strFolder",        dfr = dfrStructure, init = cpath)
    createNVAR("numVersion", dfr = dfrStructure, set = cversion)
End 

Function structureLoad(filo)
    Struct experiment &filo
    Variable SetDefault = 0
    
    if(!StructureIsInit())
        StructureInitDF(filo)
        StructureInitGlobalVariables()
    endif

    DFREF filo.dfrStructure = $StructureDF()
    if(DataFolderRefStatus(filo.dfrStructure) == 0)
        print "FILO#structureLoad: Unexpected Behaviour." // ASSERT
    endif

    NVAR/SDFR=filo.dfrStructure numVersion
    if(numVersion < cversion)
        print "FILO#structureLoad: Version Change detected."
        printf "current Version:\t%04d\r", numVersion
        StructureUpdate(filo)
        printf "new Version:\t%04d\r", numVersion
    endif
    filo.numVersion = numVersion
    
    filo.strFolder        = loadSVAR("strFolder",        dfr = filo.dfrStructure)
    filo.strFileList      = loadSVAR("strFileList",      dfr = filo.dfrStructure)
    filo.strFileExtension = loadSVAR("strFileExtension", dfr = filo.dfrStructure)
End

Function structureSave(filo)
    Struct experiment &filo
    
    DFREF dfrStructure = $StructureDF()

    saveSVAR("strFolder",        filo.strFolder,        dfr = dfrStructure)    
    saveSVAR("strFileList",      filo.strFileList,      dfr = dfrStructure)    
    saveSVAR("strFileExtension", filo.strFileExtension, dfr = dfrStructure)    
    
    saveNVAR("numVersion", filo.numVersion, dfr = dfrStructure)    
End
