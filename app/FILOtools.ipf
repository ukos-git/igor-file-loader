#pragma TextEncoding = "UTF-8"
#pragma rtGlobals = 3

Function/S FILOpopUpChooseDirectory(strPath)
    String strPath

	NewPath/O/Q path, strPath
	PathInfo/S path

	NewPath/M="choose Folder"/O/Q path
	PathInfo path
	strPath = S_path

	GetFileFolderInfo/Q/Z=1 strPath
	if (!V_isFolder)
		strPath = ""
	endif

    return strPath
End

Function FILOcreateSVAR(name, [dfr, set, init])
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

Function/S FILOloadSVAR(name, [dfr])
    String name
    DFREF dfr
   
    if(ParamIsDefault(dfr))
        dfr = GetDataFolderDFR()
    endif

    SVAR/Z/SDFR=dfr var = $name

    return var
End

Function FILOsaveSVAR(name, set, [dfr])
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

Function FILOsaveNVAR(name, set, [dfr])
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

Function FILOcreateNVAR(name, [dfr, set])
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
