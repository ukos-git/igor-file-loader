#pragma TextEncoding = "UTF-8"
#pragma rtGlobals = 3
#pragma IndependentModule = FILO

static StrConstant cstrPackageName = "Generic File Loader Wrapper"
static StrConstant cstrPreferencesFileName = "GenericFileLoader.bin"

static Constant cnumPrefsRecordID = 0 // The recordID is a unique number identifying a record within the preference file.


Structure package
	double version
	uchar  path[256]

	// reserved for future use
	uchar  strReserved[256]
	double dblReserved[100]
	uint32 intReserved[100]
EndStructure

static Function DefaultPackagePrefs(package)
	STRUCT package &package

    Variable i

	package.version = 0
	package.strReserved = ""
    package.path = ""

	for (i = 0; i < 100; i += 1)
		package.dblReserved[i] = 0
		package.intReserved[i] = 0
	endfor
End

static Function ResetPackagePrefs(package)
	STRUCT package &package

	package.path    = cpath
End

static Function SyncPackagePrefs(package)
	STRUCT package &package

	package.version = cversion
End

Function LoadPackagePrefs(package, [id])
	STRUCT package &package
    Variable id

    if(ParamIsDefault(id))
        id = cnumPrefsRecordID
    endif

	LoadPackagePreferences cstrPackageName, cstrPreferencesFileName, id, package	
	if (V_flag != 0 || V_bytesRead == 0)	
		print "FILO#LoadPackagePrefs: Package not initialized"
		DefaultPackagePrefs(package)
	endif

	if (package.version < cversion)
		print "FILO#LoadPackagePrefs: Version change detected: "
        printf "current Version:\t%04d\r", package.version
		ResetPackagePrefs(package)
		SavePackagePrefs(package)
        printf "new Version:\t%04d\r", cversion
	endif
End

Function SavePackagePrefs(package, [id])
	STRUCT package &package
    Variable id

    if(ParamIsDefault(id))
        id = cnumPrefsRecordID
    endif

	SyncPackagePrefs(package)
	SavePackagePreferences cstrPackageName, cstrPreferencesFileName, id, package
End

// Used to test SavePackagePreferences /KILL flag added in Igor Pro 6.10B04.
Function KillPackagePrefs()
	STRUCT package prefs

	SavePackagePreferences /KILL cstrPackageName, cstrPreferencesFileName, cnumPrefsRecordID, prefs
End
