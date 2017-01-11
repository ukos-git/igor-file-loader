#pragma TextEncoding = "UTF-8"
#pragma rtGlobals=3

static StrConstant cstrPackageName = "Generic File Loader Wrapper"
static StrConstant cstrPreferencesFileName = "GenericFileLoader.bin"

static Constant cnumPrefsRecordID = 0 // The recordID is a unique number identifying a record within the preference file.


Structure FILOpackage
	double version
	uchar  path[256]

	// reserved for future use
	uchar  strReserved[256]
	double dblReserved[100]
	uint32 intReserved[100]
EndStructure

static Function DefaultPackagePrefs(package)
	STRUCT FILOpackage &package

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
	STRUCT FILOpackage &package

	package.path    = cFILOpath
End

static Function SyncPackagePrefs(package)
	STRUCT FILOpackage &package

	package.version = cFILOversion
End

Function LoadPackagePrefs(package)
	STRUCT FILOpackage &package


	LoadPackagePreferences cstrPackageName, cstrPreferencesFileName, cnumPrefsRecordID, package	
	if (V_flag != 0 || V_bytesRead == 0)	
		print "LoadPackagePrefs: Package not initialized"
		DefaultPackagePrefs(package)
	endif

	if (package.version < cFILOversion)
		print "LoadPackagePrefs: Version change detected: "
        printf "current Version:\t%04d\r", package.version
		ResetPackagePrefs(package)
		SavePackagePrefs(package)
        printf "new Version:\t%04d\r", cFILOversion
	endif
End

Function SavePackagePrefs(package)
	STRUCT FILOpackage &package

	SyncPackagePrefs(package)
	SavePackagePreferences cstrPackageName, cstrPreferencesFileName, cnumPrefsRecordID, package
End

// Used to test SavePackagePreferences /KILL flag added in Igor Pro 6.10B04.
Function KillPackagePrefs()
	STRUCT FILOpackage prefs

	SavePackagePreferences /KILL cstrPackageName, cstrPreferencesFileName, cnumPrefsRecordID, prefs
End
