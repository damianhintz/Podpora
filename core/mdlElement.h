#if !defined (H_OBIEKT_DGN)
#define H_OBIEKT_DGN
#include <string.h>
#include <msdb.fdf>
#include <rdbmslib.fdf>
#include <dlogman.fdf>
#include <mselmdsc.fdf>
#include <msrmatrx.fdf>
#include <mdllib.fdf>
#include <mscell.fdf>
#include <mdl.h>
#include <mselems.h>
#include <userfnc.h>
#include <cmdlist.h>
#include <string.h>
#include <mslinkge.fdf>
#include <msoutput.fdf>
#include <msparse.fdf>
#include <msrsrc.fdf>
#include <mslocate.fdf>
#include <msstate.fdf>
#include <msdefs.h>
#include <msfile.fdf>
#include <dlogitem.h>
#include <cexpr.h>
#include <msmisc.fdf>
#include <mssystem.fdf>
#include <msscan.fdf>
#include <mswindow.fdf>
#include <msdialog.fdf>
#include <mselemen.fdf>
#include <msstring.fdf>
#include <ctype.h>
#include <msview.fdf>
#include <msscell.fdf>
#include <mstmatrx.fdf>
#include <msvec.fdf>
#include "..\def-v8.h"

int element_readAttributes(MSElementDescr *edP, ModelNumber modelRef, int* typeP, UInt32* levelP, UInt32* colorP, UInt32* weightP, Int32* styleP);
int element_isShape(int elemType);
DPoint3d* shape_getPoints(MSElementDescr* edP, ModelNumber modelRefP, int* nPunktyP);

int obiektDgn_jestObszarem(int elemType);
int obiektDgn_jestProsty(int elemType);
int obiektDgn_jestZlozony(int elemType);

#endif
