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

typedef struct podporaSkaner {
    int pomierzoneCount;
    DPoint3d* pomierzonePunkty;
    
    int pierwotneCount;
    DPoint3d* pierwotnePunkty;
    
    int nInne;
    int nObszary;
} PodporaSkaner, *LpPodporaSkaner;

int podporaSkaner_inicjuj(PodporaSkaner* thisP);
int podporaSkaner_zwolnij(PodporaSkaner* thisP);
void podporaSkaner_wczytajPomierzone(PodporaSkaner* thisP);
int podporaSkaner_wczytajPierwotne(PodporaSkaner* thisP);
int podporaSkaner_podsumowanie(PodporaSkaner* thisP);

int skanujPlik(int (*skanujElementFunc)(MSElementDescr* edP, void* vargP), void* argP);
int skanujElement(MSElementDescr* edP, void* vargP);
//wczytajPunkty

#endif
