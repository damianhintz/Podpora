#include "fenceReader.h"

void fenceReader_init(LpFenceReader thisP) {
    if (thisP == NULL) return;
    
    thisP->maxCount = 0;
    thisP->masterCount = 0;
    thisP->startPoints = NULL;
    thisP->startPointsCount = 0;
    thisP->endPoints = NULL;
    thisP->endPointsCount = 0;
}

void fenceReader_free(LpFenceReader thisP) {
    if (thisP == NULL) return;
    
    if (thisP->startPoints != NULL) {
        free(thisP->startPoints);
        thisP->startPoints = NULL;
    }
    
    if (thisP->endPoints != NULL) {
        free(thisP->endPoints);
        thisP->endPoints = NULL;
    }
}

void fenceReader_summary(LpFenceReader thisP) {
    char msg[256];
    if (thisP == NULL) return;
    
    sprintf(msg, "start points: %d count (level %d)", thisP->startPointsCount, _pierwotneLevel);
    mdlLogger_info(msg);
    sprintf(msg, "end points: %d count (level %d)", thisP->endPointsCount, _pomierzoneLevel);
    mdlLogger_info(msg);
}

int fenceReader_count(LpFenceReader thisP) {
    //mdlFence_fromUniverse(tcb->lstvw); //remember to set fence
    mdlState_startFenceCommand(fence_countRefElement, NULL, NULL, NULL, 0, 0, FENCE_NO_CLIP);
    mdlLocate_init();
    mdlLocate_allowLocked(); //ref too
    //mdlLocate_normal(); //only master
    mdlSelect_freeAll();
    mdlFence_process(thisP);
    //mdlFence_clear(FALSE);
    
    return TRUE;
}

int fence_countRefElement(LpFenceReader thisP) {
    MSElementDescr* edP = NULL;
    ModelNumber fileNum;
    ULong filePos;
    
    filePos = mdlElement_getFilePos(FILEPOS_CURRENT, &fileNum);
    mdlElmdscr_read(&edP, filePos, fileNum, 0, NULL);
    
    if (fileNum != MASTERFILE) {
        thisP->maxCount++;
    }
    
    mdlElmdscr_freeAll(&edP);
    
    return SUCCESS;
}

int fenceReader_load(LpFenceReader thisP) {
    thisP->startPoints = (PhotoPoint*) calloc(thisP->maxCount, sizeof (PhotoPoint));
    thisP->endPoints = (PhotoPoint*) calloc(thisP->maxCount, sizeof (PhotoPoint));
    //mdlFence_fromUniverse(tcb->lstvw); //remember to set fence
    mdlState_startFenceCommand(fence_selectCurrentRefElement, NULL, NULL, NULL, 0, 0, FENCE_NO_CLIP);
    mdlLocate_init();
    //mdlLocate_allowLocked(); //ref too
    mdlLocate_normal(); //only master
    mdlSelect_freeAll();
    mdlFence_process(thisP);
    //mdlFence_clear(FALSE);
    fence_sort(thisP);
    
    return TRUE;
}

int fence_selectCurrentRefElement(LpFenceReader thisP) {
    MSElementDescr* edP = NULL;
    ModelNumber fileNum;
    ULong filePos;
    
    filePos = mdlElement_getFilePos(FILEPOS_CURRENT, &fileNum);
    mdlElmdscr_read(&edP, filePos, fileNum, 0, NULL);
    
    //if (fileNum != MASTERFILE) {
    //fence_parseRef(thisP, edP, fileNum);
    fence_parseMaster(thisP, edP, fileNum);
    
    mdlElmdscr_freeAll(&edP);
    
    return SUCCESS;
}

int fence_parseMaster(LpFenceReader thisP, MSElementDescr* edP, ModelNumber fileNum) {
    int type;
    UInt32 level;
    char text[256];
    int count;
    
    element_readAttributes(edP, fileNum, &type, &level, NULL, NULL, NULL);
    if (level == _pierwotneLevel) {
        PhotoPoint* photoP = NULL;
        int i = thisP->startPointsCount;
        if (i >= thisP->maxCount) return FALSE;
        photoP = &thisP->startPoints[i];
        strncpy(photoP->name, text, sizeof (photoP->name));
        //photoP->point = point;
        thisP->startPointsCount++;
    }

    if (!element_isShape(type)) return FALSE;
    if (!shape_getPoints(edP, fileNum, &count)) return FALSE;
    
    thisP->masterCount++;
    
    return TRUE;
}

PhotoPoint* fenceReader_searchStartName(LpFenceReader thisP, char* photoName, DPoint3d* foundP) {
    PhotoPoint point;
    PhotoPoint* foundPoint = NULL;
    if (thisP == NULL) return FALSE;
    if (photoName == NULL) return FALSE;
    strncpy(point.name, photoName, MAX_PHOTO_NAME);
    foundPoint = fenceReader_binarySearch(&point, thisP->startPoints, thisP->startPointsCount);
    if (foundPoint != NULL && foundP != NULL) *foundP = foundPoint->point;
    return foundPoint;
}

int fenceReader_searchEndName(LpFenceReader thisP, char* photoName, DPoint3d* foundP) {
    PhotoPoint point;
    PhotoPoint* foundPoint = NULL;
    if (thisP == NULL) return FALSE;
    if (photoName == NULL) return FALSE;
    strncpy(point.name, photoName, MAX_PHOTO_NAME);
    foundPoint = fenceReader_binarySearch(&point, thisP->endPoints, thisP->endPointsCount);
    if (foundPoint != NULL && foundP != NULL) *foundP = foundPoint->point;
    return foundPoint != NULL;
}

PhotoPoint* fenceReader_binarySearch(PhotoPoint* key, PhotoPoint* points, long count) {
    //void* bsearch (void *key, void *base, size_t members, size_t sizeMember, int (*compareFunc)(void *, void *))
    PhotoPoint* result = bsearch(key, points, count, sizeof (PhotoPoint), fenceReader_comparePhotos);
    return result;
}

int fenceReader_comparePhotos(LpPhotoPoint p1, LpPhotoPoint p2) {
    return strcmp(p1->name, p2->name);
}

void fence_sort(LpFenceReader thisP) {
    if (thisP == NULL) return;
    //void mdlUtil_quickSort(void* pFirst, int numEntries, int elementSize, MdlFunctionP compareFunc)
    mdlUtil_quickSort(thisP->startPoints, thisP->startPointsCount, sizeof (PhotoPoint), fence_comparePoints);
    mdlUtil_quickSort(thisP->endPoints, thisP->endPointsCount, sizeof (PhotoPoint), fence_comparePoints);
}

int fence_comparePoints(LpPhotoPoint p1, LpPhotoPoint p2) {
    return strcmp(p1->name, p2->name);
}
