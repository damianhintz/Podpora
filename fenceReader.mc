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
