#include "podporaSkaner.h"
#include "mdlElement.h"
#include "mdlText.h"
#include "..\app\mdlUtil.h"

int podporaSkaner_inicjuj(PodporaSkaner* thisP) {
    if (thisP == NULL)
        return FALSE;

    thisP->pomierzoneCount = 0;
    thisP->pomierzonePunkty = NULL;
    
    thisP->pierwotneCount = 0;
    thisP->pierwotnePunkty = NULL;
    
    thisP->nInne = 0;
    thisP->nObszary = 0;

    return TRUE;
}

int podporaSkaner_zwolnij(PodporaSkaner* thisP) {
    if (thisP == NULL)
        return FALSE;

    return TRUE;
}

void podporaSkaner_wczytajPomierzone(PodporaSkaner* thisP) {
    char row[256];
    char msg[256];
    FILE* file;
    char fileName[MAXFILELENGTH];
    char dev[MAXDEVICELENGTH];
    char dir[MAXDIRLENGTH];
    char name[MAXNAMELENGTH];
    int rowIndex = 0;

    mdlFile_parseName(tcb->dgnfilenm, dev, dir, name, NULL);
    mdlFile_buildName(fileName, dev, dir, name, "txt");
    
    file = mdlTextFile_open(fileName, TEXTFILE_READ);
    
    if (file == NULL) {
        sprintf(msg, "podpora: file not found: %s", fileName);
        mdlLogger_info(msg);
        return;
    }

    while (NULL != mdlTextFile_getString(row, 256, file, TEXTFILE_DEFAULT)) {
        char nazwaPunktu[256];
        DPoint3d pomierzonyPunkt;
        int scanned;
        
        rowIndex++;

        if (strncmp(row, "#", 1) == 0) continue;
        
        scanned = sscanf(row, "%s %f %f %f", nazwaPunktu, &pomierzonyPunkt.x, &pomierzonyPunkt.y, &pomierzonyPunkt.z);
        
        if (scanned != 4) {
            sprintf(msg, "podpora: invalid row %d: %s", rowIndex, row);
            mdlLogger_info(msg);
            continue;
        }
        
        thisP->pomierzoneCount++;
    }
    
    mdlTextFile_close(file);
}

int podporaSkaner_wczytajPierwotne(PodporaSkaner* thisP) {
    if (thisP == NULL)
        return FALSE;

    if (!skanujPlik(skanujElement, thisP)) {
        return FALSE;
    }
    if (SUCCESS == mdlView_updateSingle(tcb->lstvw));

    return TRUE;
}

int podporaSkaner_podsumowanie(PodporaSkaner* thisP) {
    char msg[256];

    if (thisP == NULL)
        return FALSE;

    sprintf(msg, "podpora podsumowanie: %d pomierzone punkty (level %d)",
            thisP->pomierzoneCount, _pomierzoneLevel);
    mdlLogger_info(msg);
    
    sprintf(msg, "podpora podsumowanie: %d podpory, (level %d)",
            thisP->pierwotneCount, _pierwotneLevel);
    mdlLogger_info(msg);

    return TRUE;
}

int skanujPlik(int (*skanujElementFunc)(MSElementDescr* edP, void* argP), void* argP) {
    ULong scanBuf[256];
    int scanSize = sizeof scanBuf;
    int status;
#if MSVERSION >= 0x790
    ULong eofBlock;
#else
    int eofBlock, eofByte;
#endif
    Scanlist scanList;

    if (skanujElementFunc == NULL)
        return FALSE;

    mdlScan_initScanlist(&scanList);
    mdlScan_noRangeCheck(&scanList);

    scanList.extendedType = FILEPOS | ITERATEFUNC;

    /* 0 - MASTERFILE, 1, 2,... - pliki referencyjne */
    mdlScan_initialize(MASTERFILE, &scanList);

    scanSize = sizeof (scanBuf) / sizeof (short);

    mdlSystem_startBusyCursor();

#if MSVERSION >= 0x790
    status = mdlScan_extended(scanBuf, &scanSize, &eofBlock, skanujElementFunc, argP);
#else
    status = mdlScan_extended(scanBuf, &scanSize, &eofBlock, &eofByte, skanujElementFunc, argP);
#endif

    mdlSystem_stopBusyCursor();

    return status == SUCCESS;
}

int skanujElement(MSElementDescr* edP, void* vargP) {
    PodporaSkaner* argP = (PodporaSkaner*) vargP;
    ModelNumber numerPliku = MASTERFILE;
    int typ;
    UInt32 level;
    DPoint3d* punkty;
    int count;
    
    if (!element_readAttributes(edP, numerPliku, &typ, &level, NULL, NULL, NULL)) {
        return SUCCESS;
    }

    if (level != _pierwotneLevel) {
        return SUCCESS;
    }

    if (!obiektDgn_jestObszarem(typ)) {
        return SUCCESS;
    }
    
    //punkty = wczytajPunkty(edP, numerPliku, &count);
    
    argP->pierwotneCount++;
    
    return SUCCESS;
}

DPoint3d* wczytajPunkty(MSElementDescr* edP, ModelNumber modelRefP, int* nPunktyP) {
    DPoint3d aPunkty[MAX_VERTICES];
    DPoint3d* aPunktyP = NULL;
    int nPunkty = 0;
    int i = 0;
    
    if (SUCCESS != mdlLinear_extract(aPunkty, &nPunkty, &edP->el, modelRefP)) {
        return NULL;
    }
    
    aPunktyP = (DPoint3d*) calloc(nPunkty, sizeof (DPoint3d));

    if (aPunktyP) {
        for (i = 0; i < nPunkty; i++) {
            aPunktyP[i] = aPunkty[i];
        }
    }
    
    *nPunktyP = nPunkty;
    
    return aPunktyP;
}
