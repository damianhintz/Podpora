#include "podporaSkaner.h"
#include "mdlElement.h"
#include "mdlText.h"
#include "..\app\mdlUtil.h"

void punktPodpory_inicjuj(PunktPodpory* thisP, DPoint3d* pomierzony, char* nazwa) {
    strncpy(thisP->nazwa, nazwa, MAX_NAME_LENGTH);
    thisP->numerPodpory = -1;
    thisP->pomierzony = *pomierzony;
}

int podporaSkaner_inicjuj(PodporaSkaner* thisP) {
    fileLogger_writeLine("#nr x y z indexPomierzonego", "podpory");
    
    if (thisP == NULL)
        return FALSE;

    thisP->pomierzoneCount = 0;
    thisP->samotnePomierzone = 0;
    
    thisP->pierwotneCount = 0;
    thisP->samotnePierwotne = 0;
    
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
        PunktPodpory pomierzony;
        
        rowIndex++;

        if (strncmp(row, "#", 1) == 0) continue;
        
        scanned = sscanf(row, "%s %f %f %f", nazwaPunktu, &pomierzonyPunkt.y, &pomierzonyPunkt.x, &pomierzonyPunkt.z);
        
        if (scanned != 4) {
            sprintf(msg, "podpora: invalid row %d: %s", rowIndex, row);
            mdlLogger_info(msg);
            continue;
        }
        
        punktPodpory_inicjuj(&pomierzony, &pomierzonyPunkt, nazwaPunktu);
        thisP->pomierzone[thisP->pomierzoneCount] = pomierzony;
        //thisP->pomierzonePunkty[thisP->pomierzoneCount] = pomierzonyPunkt;
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
    
    sprintf(msg, "podpora podsumowanie: %d samotne pierwotne",
            thisP->samotnePierwotne);
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
    DPoint3d* pierwotne;
    int count, i, j;
    int numerPodpory;
    char msg[256];
    
    if (!element_readAttributes(edP, numerPliku, &typ, &level, NULL, NULL, NULL)) {
        return SUCCESS;
    }

    if (level != _pierwotneLevel) {
        return SUCCESS;
    }

    if (!obiektDgn_jestObszarem(typ)) {
        return SUCCESS;
    }
    
    pierwotne = wczytajPunkty(edP, numerPliku, &count);
    
    numerPodpory = argP->pierwotneCount++;
    
    //szukaj pomierzonego punktu
    for(i = 0; i < count; i++) {
        DPoint3d pierwotny = pierwotne[i];
        int pomierzonyIndex = -1;
        
        pierwotny.x = mdlCnv_uorsToMasterUnits(pierwotny.x);
        pierwotny.y = mdlCnv_uorsToMasterUnits(pierwotny.y);
        pierwotny.z = mdlCnv_uorsToMasterUnits(pierwotny.z);
        
        //szukaj punktu pomierzonego
        for(j = 0; j < argP->pomierzoneCount; j++) {
            PunktPodpory pomierzonyPunkt = argP->pomierzone[j];
            DPoint3d pomierzony = pomierzonyPunkt.pomierzony;
            double dystans;
            double length;
            
            if (pomierzonyPunkt.numerPodpory >= 0) {
                continue;
            }
            
            //todo: oblicz dystans bez trzeciego wymiaru z
            dystans = mdlVec_distance(&pierwotny, &pomierzony);
            dystans = mdlCnv_uorsToMasterUnits(dystans);
            length = sqrt((pomierzony.x-pierwotny.x)*(pomierzony.x-pierwotny.x) + 
                    (pomierzony.y-pierwotny.y)*(pomierzony.y-pierwotny.y));
                    
            if (length < 0.5) {
                pomierzonyPunkt.numerPodpory = numerPodpory;
                pomierzonyPunkt.pierwotny = pierwotny;
                pomierzonyIndex = j;
                break;
            }
        }
        
        if (pomierzonyIndex < 0) {
            //todo: samotny pierwotny
            argP->samotnePierwotne++;
            sprintf(msg, "%d %f %f %f %d #", numerPodpory, pierwotny.x, pierwotny.y, pierwotny.z, pomierzonyIndex);
        } else {
            PunktPodpory pomierzonyPunkt = argP->pomierzone[pomierzonyIndex];
            DPoint3d pomierzony = pomierzonyPunkt.pomierzony;
            double dystans;
            double length;
            
            //todo: oblicz dystans bez trzeciego wymiaru z
            dystans = mdlVec_distance(&pierwotny, &pomierzony);
            dystans = mdlCnv_uorsToMasterUnits(dystans);
            length = sqrt((pomierzony.x-pierwotny.x)*(pomierzony.x-pierwotny.x) + 
                    (pomierzony.y-pierwotny.y)*(pomierzony.y-pierwotny.y));
            sprintf(msg, "%d %f %f %f %d %s %f %f %f %f", numerPodpory, pierwotny.x, pierwotny.y, pierwotny.z, pomierzonyIndex, 
                    pomierzonyPunkt.nazwa, pomierzony.x, pomierzony.y, dystans, length);
            
            //wstaw strzałkę
        }
        
        fileLogger_appendLine(msg, "podpory");
    }
    
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
