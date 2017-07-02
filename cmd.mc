#include "cmd.h"

int command_loadPomierzone() {
    PodporaSkaner skanerPliku;

    podporaSkaner_inicjuj(&skanerPliku);
    podporaSkaner_wczytajPomierzone(&skanerPliku);
    podporaSkaner_wczytajPierwotne(&skanerPliku);
    podporaSkaner_podsumowanie(&skanerPliku);
    podporaSkaner_zwolnij(&skanerPliku);

    return TRUE;
}

void command_loadConfig() {
    char row[256];
    FILE* file;

    mdlLogger_info(_configPath);
    file = mdlTextFile_open(_configPath, TEXTFILE_READ);

    if (file == NULL) return;

    while (NULL != mdlTextFile_getString(row, 256, file, TEXTFILE_DEFAULT)) {
        if (strncmp(row, "#", 1) == 0) continue; //skip keyin

        //void mdlInput_sendKeyin(char* stringP, int literal, int position, char* taskIdP);
        mdlInput_sendKeyin(row, 0, 0, NULL);
    }

    mdlTextFile_close(file);
}

void command_configPomierzoneLevel(int level) {
    char msg[256];
    _pomierzoneLevel = level;
    sprintf(msg, "command_configPomierzoneLevel: %d", _pomierzoneLevel);
    mdlLogger_info(msg);
}

void command_configPierwotneLevel(int level) {
    char msg[256];
    _pierwotneLevel = level;
    sprintf(msg, "command_configPierwotneLevel: %d", _pierwotneLevel);
    mdlLogger_info(msg);
}

void command_arrowLevel(int level) {
    char msg[256];
    _arrowLevel = level;
    //int mdlParams_setActive(void* param, int paramName);
    mdlParams_setActive((void*) _arrowLevel, ACTIVEPARAM_LEVEL);
    sprintf(msg, "command_arrowLevel: %d", _arrowLevel);
    mdlLogger_info(msg);
}

void command_arrowFont(int font) {
    char msg[256];
    _arrowFont = font;
    sprintf(msg, "command_arrowFont: %d", _arrowFont);
    mdlLogger_info(msg);
}

void command_arrowColor(int color) {
    char msg[256];
    _arrowColor = color;
    //int mdlParams_setActive(void* param, int paramName);
    mdlParams_setActive((void*) _arrowColor, ACTIVEPARAM_COLOR);
    sprintf(msg, "command_arrowColor: %d", _arrowColor);
    mdlLogger_info(msg);
}

void command_arrowStyle(int style) {
    char msg[256];
    _arrowStyle = style;
    //int mdlParams_setActive(void* param, int paramName);
    mdlParams_setActive((void*) _arrowStyle, ACTIVEPARAM_LINESTYLE);
    sprintf(msg, "command_arrowStyle: %d", _arrowStyle);
    mdlLogger_info(msg);
}

void command_arrowWeight(int weight) {
    char msg[256];
    _arrowWeight = weight;
    //int mdlParams_setActive(void* param, int paramName);
    mdlParams_setActive((void*) _arrowWeight, ACTIVEPARAM_LINEWEIGHT);
    sprintf(msg, "command_arrowWeight: %d", _arrowWeight);
    mdlLogger_info(msg);
}

void command_arrowTextSize(double size) {
    char msg[256];
    _arrowTextSize = size;
    sprintf(msg, "command_arrowTextSize: %.2f", _arrowTextSize);
    mdlLogger_info(msg);
}

void command_arrowMaxLength(double length) {
    char msg[256];
    _arrowMaxLength = length;
    sprintf(msg, "command_arrowMaxLength: %.2f", _arrowMaxLength);
    mdlLogger_info(msg);
}
