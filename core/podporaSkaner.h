#if !defined (H_SKANOWANIE_DGN)
#define H_SKANOWANIE_DGN
#include <mdl.h>
#include <mselems.h>
#include <userfnc.h>
#include <cmdlist.h>
#include <string.h>
#include <msdb.fdf>
#include <rdbmslib.fdf>
#include <dlogman.fdf>
#include <mssystem.fdf>
#include <mslinkge.fdf>
#include <msoutput.fdf>
#include <msparse.fdf>
#include <mselemen.fdf>
#include <msrsrc.fdf>
#include <mslocate.fdf>
#include <msstate.fdf>
#include <msdefs.h>
#include <msfile.fdf>
#include <dlogitem.h>
#include <cexpr.h>
#include <msmisc.fdf>
#include <scanner.h>
#include <msscan.fdf>
#include <msselect.fdf>
#include <msview.fdf>
#include "..\def-v8.h"
#include "app.h"

typedef struct plikDgnObiekt {
    int filepos;
    int filenum;

} PlikDgnObiekt;

#define MAX_NAME_LENGTH 32

typedef struct _punktPodpory {
    char nazwa[MAX_NAME_LENGTH];
    DPoint3d pomierzony;
    DPoint3d pierwotny;
    int numerPodpory;
    
} PunktPodpory, *LpPunktPodpory;

void punktPodpory_inicjuj(PunktPodpory* thisP, DPoint3d* pomierzony, char* nazwa);

typedef struct _podpora {
    int numer;
    int count;
    DPoint3d* points;
    
} Podpora, *LpPodpora;

typedef struct podporaSkaner {
    int pomierzoneCount;
    DPoint3d pomierzonePunkty[512];
    PunktPodpory pomierzone[512];
    
    int pierwotneCount;
    DPoint3d pierwotnePunkty[512];
    //Podpora podpory[512];
} PodporaSkaner, *LpPodporaSkaner;

int podporaSkaner_inicjuj(PodporaSkaner* thisP);
int podporaSkaner_zwolnij(PodporaSkaner* thisP);
void podporaSkaner_wczytajPomierzone(PodporaSkaner* thisP);
int podporaSkaner_wczytajPierwotne(PodporaSkaner* thisP);
int podporaSkaner_podsumowanie(PodporaSkaner* thisP);

int skanujPlik(int (*skanujElementFunc)(MSElementDescr* edP, void* vargP), void* argP);
int skanujElement(MSElementDescr* edP, void* vargP);
DPoint3d* wczytajPunkty(MSElementDescr* edP, ModelNumber modelRefP, int* nPunktyP);

#endif
