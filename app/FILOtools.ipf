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

Function/S pathActionGetFileList(strFolder, strExtension)
    String strFolder, strExtension

    String listFiles

    NewPath/Q/O path strFolder
    listFiles = IndexedFile(path, -1, strExtension)
    listFiles = SortList(listFiles,";",16)

    return listFiles
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
            String/G dfr:$name
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
