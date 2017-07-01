#include "mdlElement.h"
#include "mdlGeom.h"

int element_readAttributes(MSElementDescr *edP,
        ModelNumber modelRef,
        int* typeP,
        UInt32* levelP,
        UInt32* colorP,
        UInt32* weightP,
        Int32* styleP) {
    int status = TRUE, type;
    UInt32 level;
    if (edP == NULL) return FALSE;
    type = mdlElement_getType(&edP->el);
    if (typeP != NULL) *typeP = type;
    mdlElement_getProperties(&level, NULL, NULL, NULL, NULL, NULL, NULL, NULL, &edP->el);
    if (colorP != NULL) mdlElement_getSymbology(colorP, weightP, styleP, &edP->el);
#if MSVERSION >= 0x790
    {
        ULong kod;
        if (SUCCESS == mdlLevel_getCode(&kod, modelRef, level)) {
            if (levelP != NULL) *levelP = kod;
            status = TRUE;
        } else status = FALSE;
    }
#else
    if (levelP != NULL) *levelP = level;
#endif
    return status;
}

int element_isShape(int elemType) {
    switch (elemType) {
        case SHAPE_ELM:
            return TRUE;
        default:
            return FALSE;
    }
    return FALSE;
}


DPoint3d* shape_getPoints(MSElementDescr* edP, ModelNumber modelRefP, int* nPunktyP) {
    DPoint3d aPunkty[MAX_VERTICES];
    DPoint3d* aPunktyP = NULL;
    int nPunkty = 0;
    int i = 0;
    
    if (SUCCESS != mdlLinear_extract(aPunkty, &nPunkty, &edP->el, modelRefP)) {
        return NULL;
    }
    
    *nPunktyP = nPunkty;
    aPunktyP = (DPoint3d*) calloc(nPunkty, sizeof (DPoint3d));
    
    if (aPunktyP == NULL) {
        return NULL;
    }
    
    for (i = 0; i < nPunkty; i++) {
        aPunktyP[i] = aPunkty[i];
    }

    return aPunktyP;
}

int obiektDgn_jestProsty(int elemType) {
    switch (elemType) {
        case LINE_ELM:
        case LINE_STRING_ELM:
        case SHAPE_ELM:
        case CURVE_ELM:
            return TRUE;
        default:
            return FALSE;
    }
    return FALSE;
}

int obiektDgn_jestZlozony(int elemType) {
    switch (elemType) {
        case CMPLX_SHAPE_ELM:
        case CMPLX_STRING_ELM:
            return TRUE;
        default:
            return FALSE;
    }
    return FALSE;
}

int obiektDgn_jestObszarem(int elemType) {
    switch (elemType) {
        case SHAPE_ELM:
            return TRUE;
        default:
            return FALSE;
    }
    return FALSE;
}
