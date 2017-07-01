#include "cmd.h"

Public cmdName void cmd_photoInit(char* unparsedP) cmdNumber CMD_PODPORA_START {
    mdlLogger_info("podpora: START");
    command_loadPomierzone();
    mdlLogger_info("podpora: END");
}

Public cmdName void cmd_loadConfig(char* unparsedP) cmdNumber CMD_PODPORA_LOAD_CONFIG {
    //mdlLogger_info("podpora: START");
    command_loadConfig();
    //mdlLogger_info("podpora: END");
}

Public cmdName void cmd_configPomierzoneLevel(char* unparsedP) cmdNumber CMD_PODPORA_CONFIG_POMIERZONELEVEL {
    int ext = -1;
    if (1 != sscanf(unparsedP, "%d", &ext)) {
        mdlLogger_err("podpora config pomierzoneLevel {level}");
        return;
    }
    command_configPomierzoneLevel(ext);
}

Public cmdName void cmd_configPierwotneLevel(char* unparsedP) cmdNumber CMD_PODPORA_CONFIG_PIERWOTNELEVEL {
    int ext = -1;
    if (1 != sscanf(unparsedP, "%d", &ext)) {
        mdlLogger_err("podpora config pierwotneLevel {level}");
        return;
    }
    command_configPierwotneLevel(ext);
}

Public cmdName void cmd_arrowLevel(char* unparsedP) cmdNumber CMD_PODPORA_ARROW_LEVEL {
    int level = -1;
    if (1 != sscanf(unparsedP, "%d", &level)) {
        mdlLogger_info("podpora arrow level {level}");
        return;
    }
    command_arrowLevel(level);
}

Public cmdName void cmd_arrowFont(char* unparsedP) cmdNumber CMD_PODPORA_ARROW_FONT {
    int font = -1;
    if (1 != sscanf(unparsedP, "%d", &font)) {
        mdlLogger_info("podpora arrow font {font}");
        return;
    }
    command_arrowFont(font);
}

Public cmdName void cmd_arrowColor(char* unparsedP) cmdNumber CMD_PODPORA_ARROW_COLOR {
    int color;
    if (1 != sscanf(unparsedP, "%d", &color)) {
        mdlLogger_info("podpora arrow color {color}");
        return;
    }
    command_arrowColor(color);
}

Public cmdName void cmd_arrowTextSize(char* unparsedP) cmdNumber CMD_PODPORA_ARROW_TEXTSIZE {
    double size;
    if (1 != sscanf(unparsedP, "%f", &size)) {
        mdlLogger_info("podpora arrow textSize {size}");
        return;
    }
    command_arrowTextSize(size);
}

Public cmdName void cmd_arrowStyle(char* unparsedP) cmdNumber CMD_PODPORA_ARROW_STYLE {
    int style;
    if (1 != sscanf(unparsedP, "%d", &style)) {
        mdlLogger_info("podpora arrow style {style}");
        return;
    }
    command_arrowStyle(style);
}
Public cmdName void cmd_arrowWeight(char* unparsedP) cmdNumber CMD_PODPORA_ARROW_WEIGHT {
    int weight;
    if (1 != sscanf(unparsedP, "%d", &weight)) {
        mdlLogger_info("podpora arrow weight {weight}");
        return;
    }
    command_arrowWeight(weight);
}

Public cmdName void cmd_arrowMaxLength(char* unparsedP) cmdNumber CMD_PODPORA_ARROW_MAXLENGTH {
    double length;
    if (1 != sscanf(unparsedP, "%f", &length)) {
        mdlLogger_info("podpora arrow maxLength {length}");
        return;
    }
    command_arrowMaxLength(length);
}
